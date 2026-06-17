// ignore_for_file: implementation_imports
import "dart:async";

import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view.dart";
import "package:esim_open_source/presentation/views/start_up_view/startup_view_model.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_core_platform_interface/src/pigeon/mocks.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../helpers/fake_build_context.dart";
import "../../../helpers/view_helper.dart";
import "../../../helpers/view_model_helper.dart";
import "../../../locator_test.dart";
import "../../../locator_test.mocks.dart";

/// A BuildContext fake whose `mounted` is false, to exercise the
/// `if (context.mounted)` false branches without a real element.
class UnmountedFakeContext extends Fake implements BuildContext {
  @override
  bool get mounted => false;
}

Future<void> main() async {
  await prepareTest();

  late StartUpViewModel viewModel;
  late MockDeviceInfoService mockDeviceInfoService;
  late MockApiAuthRepository mockApiAuthRepository;
  late MockLocalStorageService mockLocalStorageService;
  late MockNavigationService mockNavigationService;
  late MockRedirectionsHandlerService mockRedirectionsHandlerService;
  late MockUserAuthenticationService mockUserAuthenticationService;
  late MockPushNotificationService mockPushNotificationService;
  late MockSocialLoginService mockSocialLoginService;
  late MockAppConfigurationService mockAppConfigurationService;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() async {
    await setupTest();

    // The repo's FirebaseHelper (invoked by setupTest) installs an obsolete raw
    // MethodChannel handler on the Pigeon channel name, which is a no-op against
    // firebase_core 4.x and actually clobbers any Pigeon handler. Re-assert the
    // supported Pigeon test host API AFTER setupTest so it wins, then create the
    // default app so the real _initializePushServices() can read its options.
    setupFirebaseCoreMocks();
    try {
      await Firebase.initializeApp();
    } on Object catch (_) {
      // Already initialised by a previous test.
    }

    onViewModelReadyMock(viewName: "StartUpView");

    mockDeviceInfoService =
        locator<DeviceInfoService>() as MockDeviceInfoService;
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockRedirectionsHandlerService =
        locator<RedirectionsHandlerService>() as MockRedirectionsHandlerService;
    mockUserAuthenticationService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    mockPushNotificationService =
        locator<PushNotificationService>() as MockPushNotificationService;
    mockSocialLoginService =
        locator<SocialLoginService>() as MockSocialLoginService;
    mockAppConfigurationService =
        locator<AppConfigurationService>() as MockAppConfigurationService;
    mockAnalyticsService = locator<AnalyticsService>() as MockAnalyticsService;

    // Default stubs so the unawaited init futures started at the very top of
    // handleStartUpLogic (_initializePushServices + _initializeConfigurations)
    // complete without throwing into the test zone.
    when(mockAppConfigurationService.getSupabaseUrl)
        .thenAnswer((_) async => "https://test.supabase.co");
    when(mockAppConfigurationService.getSupabaseAnon)
        .thenAnswer((_) async => "test-anon-key");
    when(
      mockSocialLoginService.initialise(
        url: anyNamed("url"),
        anonKey: anyNamed("anonKey"),
      ),
    ).thenAnswer((_) async => const Stream<SocialLoginResult>.empty());
    when(
      mockPushNotificationService.initialise(
        handlePushData: anyNamed("handlePushData"),
      ),
    ).thenAnswer((_) async {});
    when(mockPushNotificationService.getFcmToken())
        .thenAnswer((_) async => "test-fcm-token");
    when(mockLocalStorageService.setString(any, any))
        .thenAnswer((_) async => true);
    when(mockRedirectionsHandlerService.handleInitialRedirection(any))
        .thenAnswer((_) async {});

    viewModel = StartUpViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("Initialization", () {
    test("constructs with its use case and push service wired", () {
      expect(viewModel, isNotNull);
      expect(viewModel, isA<StartUpViewModel>());
      expect(viewModel.refreshTokenUseCase, isNotNull);
      expect(viewModel.pushNotificationService, isNotNull);
    });
  });

  group("handleStartUpLogic (real)", () {
    test("runs push + config init and dispatches redirection when logged out",
        () async {
      when(mockDeviceInfoService.isRooted).thenAnswer((_) async => false);
      when(mockDeviceInfoService.isDevelopmentModeEnable)
          .thenAnswer((_) async => false);
      when(mockDeviceInfoService.isPhysicalDevice)
          .thenAnswer((_) async => true);
      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(false);

      await viewModel.handleStartUpLogic(FakeContext());

      verify(
        mockPushNotificationService.initialise(
          handlePushData: anyNamed("handlePushData"),
        ),
      ).called(1);
      verify(
        mockSocialLoginService.initialise(
          url: anyNamed("url"),
          anonKey: anyNamed("anonKey"),
        ),
      ).called(1);
      verify(mockRedirectionsHandlerService.handleInitialRedirection(any))
          .called(1);
    });

    test("triggers token refresh when user is logged in", () async {
      when(mockDeviceInfoService.isRooted).thenAnswer((_) async => false);
      when(mockDeviceInfoService.isDevelopmentModeEnable)
          .thenAnswer((_) async => false);
      when(mockDeviceInfoService.isPhysicalDevice)
          .thenAnswer((_) async => true);
      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.userEmailAddress).thenReturn("");
      when(mockApiAuthRepository.refreshTokenAPITrigger()).thenAnswer(
        (_) async => Resource<AuthResponseModel>.success(
          AuthResponseModel(),
          message: "Success",
        ),
      );

      await viewModel.handleStartUpLogic(FakeContext());

      verify(mockApiAuthRepository.refreshTokenAPITrigger()).called(1);
      verify(mockRedirectionsHandlerService.handleInitialRedirection(any))
          .called(1);
    });
  });

  group("refreshTokenTrigger (real)", () {
    test("success with non-empty email hashes it and sets analytics user id",
        () async {
      when(mockApiAuthRepository.refreshTokenAPITrigger()).thenAnswer(
        (_) async => Resource<AuthResponseModel>.success(
          AuthResponseModel(),
          message: "Success",
        ),
      );
      when(mockUserAuthenticationService.userEmailAddress)
          .thenReturn("test@example.com");
      when(mockAnalyticsService.setUserId(any)).thenAnswer((_) async {});

      await viewModel.refreshTokenTrigger();

      expect(viewModel.viewState, ViewState.idle);
      // 64-char SHA-256 hex digest is passed, never the raw email.
      verify(mockAnalyticsService.setUserId(argThat(hasLength(64)))).called(1);
    });

    test("success with empty email skips analytics", () async {
      when(mockApiAuthRepository.refreshTokenAPITrigger()).thenAnswer(
        (_) async => Resource<AuthResponseModel>.success(
          AuthResponseModel(),
          message: "Success",
        ),
      );
      when(mockUserAuthenticationService.userEmailAddress).thenReturn("");

      await viewModel.refreshTokenTrigger();

      expect(viewModel.viewState, ViewState.idle);
      verifyNever(mockAnalyticsService.setUserId(any));
    });

    test("error response settles to idle", () async {
      when(mockApiAuthRepository.refreshTokenAPITrigger()).thenAnswer(
        (_) async => Resource<AuthResponseModel>.error("Error occurred"),
      );

      await viewModel.refreshTokenTrigger();

      expect(viewModel.viewState, ViewState.idle);
    });

    test("loading response settles to idle", () async {
      when(mockApiAuthRepository.refreshTokenAPITrigger())
          .thenAnswer((_) async => Resource<AuthResponseModel>.loading());

      await viewModel.refreshTokenTrigger();

      expect(viewModel.viewState, ViewState.idle);
    });

    test("thrown exception is caught and state settles to idle", () async {
      when(mockApiAuthRepository.refreshTokenAPITrigger())
          .thenThrow(Exception("Network error"));

      await viewModel.refreshTokenTrigger();

      expect(viewModel.viewState, ViewState.idle);
    });
  });

  group("getInitialRoute (real)", () {
    // Note: the Platform.isAndroid first-start branch cannot be reached on a
    // non-Android test host, so it is intentionally not covered here.
    test("replaces with AppClipSelection when launched from an app clip",
        () async {
      AppEnvironment.isFromAppClip = true;
      when(mockNavigationService.replaceWith(AppClipSelectionView.routeName))
          .thenAnswer((_) async => true);

      await viewModel.getInitialRoute();

      verify(mockNavigationService.replaceWith(AppClipSelectionView.routeName))
          .called(1);

      AppEnvironment.isFromAppClip = false;
    });

    test("falls through to the home pager for the normal flow", () async {
      AppEnvironment.isFromAppClip = false;
      when(
        mockNavigationService.pushNamedAndRemoveUntil(
          any,
          arguments: anyNamed("arguments"),
        ),
      ).thenAnswer((_) async => true);

      await viewModel.getInitialRoute();

      verify(
        mockNavigationService.pushNamedAndRemoveUntil(
          any,
          arguments: anyNamed("arguments"),
        ),
      ).called(1);
    });
  });

  group("checkIfDeviceCompatible (real)", () {
    test("returns false when every integrity check passes", () async {
      when(mockDeviceInfoService.isRooted).thenAnswer((_) async => false);
      when(mockDeviceInfoService.isDevelopmentModeEnable)
          .thenAnswer((_) async => false);
      when(mockDeviceInfoService.isPhysicalDevice)
          .thenAnswer((_) async => true);

      final bool result =
          await viewModel.checkIfDeviceCompatible(FakeContext());

      expect(result, isFalse);
      verify(mockDeviceInfoService.isRooted).called(1);
      verify(mockDeviceInfoService.isDevelopmentModeEnable).called(1);
      verify(mockDeviceInfoService.isPhysicalDevice).called(1);
    });

    testWidgets("returns true and shows the dialog when the device is rooted",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const SizedBox()));
      final BuildContext context = tester.element(find.byType(SizedBox));

      when(mockDeviceInfoService.isRooted).thenAnswer((_) async => true);
      when(mockDeviceInfoService.isDevelopmentModeEnable)
          .thenAnswer((_) async => false);
      when(mockDeviceInfoService.isPhysicalDevice)
          .thenAnswer((_) async => true);

      final bool result = await viewModel.checkIfDeviceCompatible(context);

      expect(result, isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets("returns true when development mode is enabled",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const SizedBox()));
      final BuildContext context = tester.element(find.byType(SizedBox));

      when(mockDeviceInfoService.isRooted).thenAnswer((_) async => false);
      when(mockDeviceInfoService.isDevelopmentModeEnable)
          .thenAnswer((_) async => true);
      when(mockDeviceInfoService.isPhysicalDevice)
          .thenAnswer((_) async => true);

      final bool result = await viewModel.checkIfDeviceCompatible(context);

      expect(result, isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets("returns true when the device is not physical",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const SizedBox()));
      final BuildContext context = tester.element(find.byType(SizedBox));

      when(mockDeviceInfoService.isRooted).thenAnswer((_) async => false);
      when(mockDeviceInfoService.isDevelopmentModeEnable)
          .thenAnswer((_) async => false);
      when(mockDeviceInfoService.isPhysicalDevice)
          .thenAnswer((_) async => false);

      final bool result = await viewModel.checkIfDeviceCompatible(context);

      expect(result, isTrue);
      await tester.pumpAndSettle();
    });
  });

  group("showDeviceCompromisedDialog (real)", () {
    testWidgets("shows a native dialog when the context is mounted",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(const SizedBox()));
      final BuildContext context = tester.element(find.byType(SizedBox));

      await viewModel.showDeviceCompromisedDialog(context);
      await tester.pumpAndSettle();

      expect(find.text("Your device is compromised"), findsOneWidget);
    });

    test("does nothing when the context is not mounted", () async {
      await viewModel.showDeviceCompromisedDialog(UnmountedFakeContext());

      expect(viewModel, isNotNull);
    });
  });
}

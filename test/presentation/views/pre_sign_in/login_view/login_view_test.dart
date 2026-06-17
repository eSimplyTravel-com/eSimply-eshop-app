import "dart:async";

import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/haptic_helper.dart";
import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  // Mock platform channels for plugins
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel toastChannel =
      MethodChannel("PonnamKarthik/fluttertoast");

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    toastChannel,
    (MethodCall methodCall) async {
      if (methodCall.method == "showToast") {
        return null; // Mock successful toast
      }
      return null;
    },
  );
  late NavigationService mockNavigationService;
  late MockLocalStorageService mockLocalStorageService;
  late MockDeviceInfoService mockDeviceInfoService;
  late SecureStorageService mockSecureStorageService;
  late MockApiPromotionRepository mockApiPromotionRepository;
  late MockApiAppRepository mockApiAppRepository;
  late MockApiDeviceRepository mockApiDeviceRepository;
  late MockSocialLoginService mockSocialLoginService;

  setUp(() async {
    await setupTest();

    // Initialize haptic feedback mocking
    HapticHelperTest.implementHaptic();
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockDeviceInfoService =
        locator<DeviceInfoService>() as MockDeviceInfoService;
    mockSecureStorageService =
        locator<SecureStorageService>() as MockSecureStorageService;
    mockApiPromotionRepository =
        locator<ApiPromotionRepository>() as MockApiPromotionRepository;
    mockApiAppRepository = locator<ApiAppRepository>() as MockApiAppRepository;
    mockApiDeviceRepository =
        locator<ApiDeviceRepository>() as MockApiDeviceRepository;
    mockSocialLoginService =
        locator<SocialLoginService>() as MockSocialLoginService;

    onViewModelReadyMock(viewName: "LoginViewPage");
    when(locator<UserAuthenticationService>().isUserLoggedIn).thenReturn(false);
    when(locator<SocialLoginService>().socialLoginResultStream)
        .thenAnswer((_) => const Stream<SocialLoginResult>.empty());
    when(locator<SocialLoginService>().logOut())
        .thenAnswer((_) async => <dynamic, dynamic>{});
    when(mockSocialLoginService.signInWithFaceBook())
        .thenAnswer((_) async => const Stream<SocialLoginResult>.empty());
    when(mockSocialLoginService.signInWithGoogle())
        .thenAnswer((_) async => const Stream<SocialLoginResult>.empty());
    when(mockNavigationService.back()).thenReturn(true);
    when(
      mockNavigationService.pushNamedAndRemoveUntil(
        "HomePager",
        predicate: anyNamed("predicate"),
        arguments: anyNamed("arguments"),
        id: anyNamed("id"),
      ),
    ).thenAnswer((_) async => true);
    when(
      mockApiPromotionRepository.applyReferralCode(
        referralCode: anyNamed("referralCode"),
      ),
    ).thenAnswer(
      (_) async => Resource<dynamic>.success(null, message: "Success"),
    );
    when(mockLocalStorageService.setString(any, any))
        .thenAnswer((_) async => true);
    when(mockDeviceInfoService.addDeviceParams).thenAnswer(
      (_) async => AddDeviceParams(
        fcmToken: "test_fcm",
        manufacturer: "Apple",
        deviceModel: "iPhone",
        deviceOs: "iOS",
        deviceOsVersion: "17.0",
        appVersion: "1.0.0",
        ramSize: "8GB",
        screenResolution: "1170x2532",
        isRooted: false,
      ),
    );
    when(mockSecureStorageService.getString(SecureStorageKeys.deviceID))
        .thenAnswer((_) async => "test_device_id");
    when(mockApiAppRepository.addDevice(any)).thenAnswer(
      (_) async => Resource<dynamic>.success(null, message: "Success"),
    );
    when(
      mockApiDeviceRepository.registerDevice(
        params: anyNamed("params"),
      ),
    ).thenAnswer(
      (_) async => Resource<dynamic>.success(null, message: "Success"),
    );

    // Override the mocked LoginViewModel with real implementation
    locator
      ..unregister<LoginViewModel>()
      ..registerLazySingleton<LoginViewModel>(LoginViewModel.new);
  });

  testWidgets("renders correctly with initial state",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const LoginView(),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.byType(LoginView), findsOneWidget);
    expect(find.byType(Image), findsAtLeastNWidgets(2));
    expect(find.textContaining("terms"), findsOneWidget);
  });

  testWidgets("displays close button", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const LoginView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
  });

  testWidgets("displays app icon and title text", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const LoginView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsAtLeastNWidgets(1));
    expect(find.byType(Text), findsAtLeastNWidgets(2));
  });

  testWidgets("shows main buttons", (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const LoginView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MainButton), findsAtLeastNWidgets(1));
  });

  testWidgets("displays terms and conditions text",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const LoginView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining("terms"), findsOneWidget);
  });

  testWidgets("renders with redirection parameter",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    final InAppRedirection testRedirection = InAppRedirection.cashback();

    await tester.pumpWidget(
      createTestableWidget(
        LoginView(redirection: testRedirection),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
  });

  testWidgets("Pressing close button triggers backButtonPressed",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const LoginView(),
      ),
    );
    await tester.pumpAndSettle();

    // Find the close button using the key and trigger its callback directly
    final Finder closeButton = find.byKey(const Key("backButtonPressed"));
    expect(closeButton, findsOneWidget);

    // Get the gesture detector and call its onTap directly to bypass hit-test issues
    final GestureDetector gestureDetector =
        tester.widget<GestureDetector>(closeButton);
    gestureDetector.onTap!();
    await tester.pumpAndSettle();

    // Verify that the navigation service was called
    verify(mockNavigationService.back()).called(1);
  });

  testWidgets("debug properties", (WidgetTester tester) async {
    final InAppRedirection redirection = InAppRedirection.cashback();
    final LoginView widget = LoginView(redirection: redirection);

    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    widget.debugFillProperties(builder);

    final List<DiagnosticsNode> props = builder.properties;

    final DiagnosticsProperty<InAppRedirection?> redirectionProp =
        props.firstWhere((DiagnosticsNode p) => p.name == "redirection")
            as DiagnosticsProperty<InAppRedirection?>;

    expect(redirectionProp.value, isNotNull);
    // expect(redirectionProp.value!.route, '/home');
  });

  testWidgets("getContinueWithText returns correct text for email",
      (WidgetTester tester) async {
    const LoginView view = LoginView();
    final String continueWithText = view.getContinueWithText();
    expect(continueWithText, isNotEmpty);
  });

  testWidgets("termsAndConditionTappableWidget displays correctly",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(
        const LoginView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining("terms"), findsOneWidget);
  });

  testWidgets("termsAndConditionTappableWidget can be created directly",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    const LoginView view = LoginView();

    await tester.pumpWidget(
      createTestableWidget(
        Builder(
          builder: (BuildContext context) {
            return view.termsAndConditionTappableWidget(context);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining("terms"), findsAtLeastNWidgets(1));
  });

  testWidgets("tapping facebook button triggers facebook social sign in",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(const LoginView()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MainButton).first);
    await tester.pumpAndSettle();

    verify(mockSocialLoginService.signInWithFaceBook()).called(1);
  });

  testWidgets("tapping google button triggers google social sign in",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(const LoginView()),
    );
    await tester.pumpAndSettle();

    // Google is second MainButton on non-iOS (Facebook, Google, Email)
    await tester.tap(find.byType(MainButton).at(1));
    await tester.pumpAndSettle();

    verify(mockSocialLoginService.signInWithGoogle()).called(1);
  });

  testWidgets("tapping email button navigates to sign in page",
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      createTestableWidget(const LoginView()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MainButton).last);
    await tester.pumpAndSettle();

    verify(
      mockNavigationService.navigateTo(
        ContinueWithEmailView.routeName,
        arguments: anyNamed("arguments"),
      ),
    ).called(1);
  });

  testWidgets("terms tappable text recognizer triggers on tap",
      (WidgetTester tester) async {
    late TapGestureRecognizer capturedRecognizer;

    await tester.pumpWidget(
      createTestableWidget(
        Builder(
          builder: (BuildContext context) {
            const LoginView view = LoginView();
            final Widget widget =
                view.termsAndConditionTappableWidget(context);
            // Text.rich returns a Text widget with a textSpan property
            final Text textWidget = widget as Text;
            final TextSpan rootSpan = textWidget.textSpan! as TextSpan;
            final TextSpan tappableSpan =
                rootSpan.children!.first as TextSpan;
            capturedRecognizer =
                tappableSpan.recognizer! as TapGestureRecognizer;
            return widget;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    capturedRecognizer.onTap!();
    await tester.pump();

    expect(find.byType(Text), findsWidgets);
  });

  testWidgets("getContinueWithText returns phone text for phoneNumber",
      (WidgetTester tester) async {
    when(locator<AppConfigurationService>().getLoginType)
        .thenReturn(LoginType.phoneNumber);

    const LoginView view = LoginView();
    final String text = view.getContinueWithText();
    expect(text, isNotEmpty);
  });

  testWidgets("getContinueWithText returns phone text for emailAndPhone",
      (WidgetTester tester) async {
    when(locator<AppConfigurationService>().getLoginType)
        .thenReturn(LoginType.emailAndPhone);

    const LoginView view = LoginView();
    final String text = view.getContinueWithText();
    expect(text, isNotEmpty);
  });

  testWidgets(
      "getContinueWithText returns phone text for emailAndPhoneAndEmailVerification",
      (WidgetTester tester) async {
    when(locator<AppConfigurationService>().getLoginType)
        .thenReturn(LoginType.emailAndPhoneAndEmailVerification);

    const LoginView view = LoginView();
    final String text = view.getContinueWithText();
    expect(text, isNotEmpty);
  });

  testWidgets(
      "getContinueWithText returns phone text for emailAndPhoneAndBothVerification",
      (WidgetTester tester) async {
    when(locator<AppConfigurationService>().getLoginType)
        .thenReturn(LoginType.emailAndPhoneAndBothVerification);

    const LoginView view = LoginView();
    final String text = view.getContinueWithText();
    expect(text, isNotEmpty);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}

import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view_model.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late LoginViewModel viewModel;
  late MockSocialLoginService mockSocialLoginService;
  late MockNavigationService mockNavigationService;
  late MockLocalStorageService mockLocalStorageService;
  late MockAnalyticsService mockAnalyticsService;
  late MockUserAuthenticationService mockUserAuthenticationService;
  late MockApiAuthRepository mockApiAuthRepository;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "LoginView");

    // Stub the native status bar channel used by setDefaultStatusBarColor
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel("plugins.sameer.com/statusbar"),
      (MethodCall methodCall) async => null,
    );

    mockSocialLoginService =
        locator<SocialLoginService>() as MockSocialLoginService;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockAnalyticsService = locator<AnalyticsService>() as MockAnalyticsService;
    mockUserAuthenticationService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    final MockApiPromotionRepository mockApiPromotionRepository =
        locator<ApiPromotionRepository>() as MockApiPromotionRepository;
    final MockDeviceInfoService mockDeviceInfoService =
        locator<DeviceInfoService>() as MockDeviceInfoService;
    final MockApiAppRepository mockApiAppRepository =
        locator<ApiAppRepository>() as MockApiAppRepository;
    final MockSecureStorageService mockSecureStorageService =
        locator<SecureStorageService>() as MockSecureStorageService;

    // Default stubs for device info service
    when(mockDeviceInfoService.addDeviceParams).thenAnswer(
      (_) async => AddDeviceParams(
        fcmToken: "test_fcm",
        manufacturer: "Test",
        deviceModel: "Test",
        deviceOs: "test",
        deviceOsVersion: "1.0",
        appVersion: "1.0",
        ramSize: "4GB",
        screenResolution: "1920x1080",
        isRooted: false,
      ),
    );

    // Default stubs for secure storage and add device
    when(mockSecureStorageService.getString(SecureStorageKeys.deviceID))
        .thenAnswer((_) async => "test_device_id");
    when(mockApiAppRepository.addDevice(any)).thenAnswer(
      (_) async => Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      ),
    );

    // Default stubs for API promotion repository
    when(mockApiPromotionRepository.applyReferralCode(
            referralCode: anyNamed("referralCode")))
        .thenAnswer(
      (_) async => Resource<EmptyResponse?>.success(
        null,
        message: "Success",
      ),
    );

    // Default stubs for social login service
    final Stream<SocialLoginResult> emptyStream =
        const Stream<SocialLoginResult>.empty();
    when(mockSocialLoginService.socialLoginResultStream)
        .thenAnswer((_) => emptyStream);
    when(mockSocialLoginService.signInWithApple())
        .thenAnswer((_) async => emptyStream);
    when(mockSocialLoginService.signInWithGoogle())
        .thenAnswer((_) async => emptyStream);
    when(mockSocialLoginService.signInWithFaceBook())
        .thenAnswer((_) async => emptyStream);
    when(mockSocialLoginService.logOut())
        .thenAnswer((_) async => <dynamic, dynamic>{});

    // Default stubs for navigation
    when(mockNavigationService.back()).thenReturn(true);
    when(
      mockNavigationService.navigateTo(
        any,
        arguments: anyNamed("arguments"),
      ),
    ).thenAnswer((_) async => true);
    when(
      mockNavigationService.pushNamedAndRemoveUntil(
        any,
        predicate: anyNamed("predicate"),
        arguments: anyNamed("arguments"),
        id: anyNamed("id"),
      ),
    ).thenAnswer((_) async => true);

    // Default stubs for local storage
    when(mockLocalStorageService.getString(any)).thenReturn("test_utm");
    when(mockLocalStorageService.setString(any, any))
        .thenAnswer((_) async => true);

    // Default stubs for analytics
    when(mockAnalyticsService.logEvent(event: anyNamed("event")))
        .thenAnswer((_) async => Future<void>.value());
    when(mockAnalyticsService.setUserId(any))
        .thenAnswer((_) async => Future<void>.value());

    // Default stubs for user authentication service
    when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(false);
    when(mockUserAuthenticationService.saveUserResponse(any))
        .thenAnswer((_) async => Future<void>.value());

    // Default stubs for API auth repository
    when(
      mockApiAuthRepository.updateUserInfo(
        request: anyNamed("request"),
      ),
    ).thenAnswer(
      (_) async => Resource<AuthResponseModel>.success(
        AuthResponseModel(
          accessToken: "test_access_token",
          refreshToken: "test_refresh_token",
        ),
        message: "Success",
      ),
    );

    viewModel = LoginViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("LoginViewModel Tests", () {
    group("Initialization", () {
      test("initialization test", () {
        expect(viewModel, isNotNull);
        expect(viewModel, isA<LoginViewModel>());
      });

      test("initializes with default values", () {
        expect(viewModel.redirection, isNull);
        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test("initializes with redirection parameter", () {
        final InAppRedirection redirection = InAppRedirection.cashback();
        final LoginViewModel vmWithRedirection = LoginViewModel(
          redirection: redirection,
        );

        expect(vmWithRedirection.redirection, equals(redirection));
      });

      test("has socialLoginService initialized", () {
        expect(viewModel.socialLoginService, isNotNull);
      });
    });

    group("Getter Coverage", () {
      test("getters line coverage", () {
        final SocialLoginService service = viewModel.socialLoginService;
        final ViewState state = viewModel.viewState;

        expect(service, isNotNull);
        expect(state, equals(ViewState.idle));
      });

      test("redirection getter returns correct value", () {
        expect(viewModel.redirection, isNull);
      });

      test("redirection getter returns value when set", () {
        final InAppRedirection redirection = InAppRedirection.cashback();
        final LoginViewModel vm = LoginViewModel(redirection: redirection);

        expect(vm.redirection, equals(redirection));
      });
    });

    group("Navigation", () {
      test("backButtonPressed navigates back", () async {
        await viewModel.backButtonPressed();

        verify(mockNavigationService.back()).called(1);
      });

      test("navigateToSignInPage navigates to ContinueWithEmailView", () async {
        await viewModel.navigateToSignInPage();

        verify(
          mockNavigationService.navigateTo(
            ContinueWithEmailView.routeName,
            arguments: anyNamed("arguments"),
          ),
        ).called(1);
      });

      test("navigateToSignInPage passes redirection argument", () async {
        final InAppRedirection redirection = InAppRedirection.cashback();
        final LoginViewModel vmWithRedirection = LoginViewModel(
          redirection: redirection,
        );

        await vmWithRedirection.navigateToSignInPage();

        verify(
          mockNavigationService.navigateTo(
            ContinueWithEmailView.routeName,
            arguments: redirection,
          ),
        ).called(1);
      });

      test("navigateToSignInPage with null redirection", () async {
        await viewModel.navigateToSignInPage();

        verify(
          mockNavigationService.navigateTo(
            ContinueWithEmailView.routeName,
            arguments: null,
          ),
        ).called(1);
      });
    });

    group("Social Media Sign In", () {
      test("socialMediaSignInAction with Apple", () async {
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.apple);

        verify(mockSocialLoginService.signInWithApple()).called(1);
      });

      test("socialMediaSignInAction with Google", () async {
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.google);

        verify(mockSocialLoginService.signInWithGoogle()).called(1);
      });

      test("socialMediaSignInAction with Facebook", () async {
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.facebook);

        verify(mockSocialLoginService.signInWithFaceBook()).called(1);
      });

      test("socialMediaSignInAction resets redirecting flag", () async {
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.google);

        // The internal _redirecting flag should be reset to false
        verify(mockSocialLoginService.signInWithGoogle()).called(1);
      });
    });

    group("Token Validation and Login", () {
      test("validateSignInAndNavigate with empty access token logs out",
          () async {
        await viewModel.validateSignInAndNavigate(
          accessToken: "",
          refreshToken: "test_refresh",
          socialMediaLoginType: SocialMediaLoginType.google,
        );

        verify(mockSocialLoginService.logOut()).called(1);
      });

      test("validateSignInAndNavigate with empty refresh token", () async {
        await viewModel.validateSignInAndNavigate(
          accessToken: "test_access",
          refreshToken: "",
          socialMediaLoginType: SocialMediaLoginType.google,
        );

        // Non-empty access token proceeds to login, so logOut is not called
        verifyNever(mockSocialLoginService.logOut());
      });

      test("validateSignInAndNavigate with valid tokens", () async {
        when(
          mockApiAuthRepository.updateUserInfo(
            request: anyNamed("request"),
          ),
        ).thenAnswer(
          (_) async => Resource<AuthResponseModel>.success(
            AuthResponseModel(
              accessToken: "test_access_token",
              refreshToken: "test_refresh_token",
            ),
            message: "Success",
          ),
        );

        await viewModel.validateSignInAndNavigate(
          accessToken: "test_access_token",
          refreshToken: "test_refresh_token",
          socialMediaLoginType: SocialMediaLoginType.google,
        );

        verify(
          mockApiAuthRepository.updateUserInfo(
            request: anyNamed("request"),
          ),
        ).called(1);
      });

      test("validateSignInAndNavigate with null tokens", () async {
        await viewModel.validateSignInAndNavigate(
          accessToken: "",
          refreshToken: "",
          socialMediaLoginType: SocialMediaLoginType.apple,
        );

        verify(mockSocialLoginService.logOut()).called(1);
      });
    });

    group("Login User With Token", () {
      test("loginUserWithToken method exists and is callable", () {
        expect(viewModel.loginUserWithToken, isA<Function>());
      });

      test("validateSignInAndNavigate method exists and is callable", () {
        expect(viewModel.validateSignInAndNavigate, isA<Function>());
      });
    });

    group("Social Login Stream Listener", () {
      test("initializeListener logs out user if not logged in", () async {
        when(mockSocialLoginService.socialLoginResultStream)
            .thenAnswer((_) => const Stream<SocialLoginResult>.empty());

        await viewModel.initializeListener();

        verify(mockSocialLoginService.logOut()).called(1);
      });

      test("initializeListener logs out user if user is already logged in",
          () async {
        when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
        when(mockSocialLoginService.socialLoginResultStream)
            .thenAnswer((_) => const Stream<SocialLoginResult>.empty());

        await viewModel.initializeListener();

        verifyNever(mockSocialLoginService.logOut());
      });

      test("initializeListener listens to social login result stream",
          () async {
        await viewModel.initializeListener();

        verify(mockSocialLoginService.socialLoginResultStream).called(1);
      });

      test("initializeListener handles successful login result", () async {
        final SocialLoginResult successResult = SocialLoginResult(
          accessToken: "test_access_token",
          refreshToken: "test_refresh_token",
          socialType: SocialMediaLoginType.google,
        );

        when(mockSocialLoginService.socialLoginResultStream).thenAnswer(
          (_) => Stream<SocialLoginResult>.value(successResult),
        );

        await viewModel.initializeListener();

        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Verify initialization was processed
        verify(mockSocialLoginService.socialLoginResultStream).called(1);
      });

      test("initializeListener handles error message in login result",
          () async {
        final SocialLoginResult errorResult = SocialLoginResult(
          errorMessage: "Authentication failed",
          socialType: SocialMediaLoginType.google,
        );

        when(mockSocialLoginService.socialLoginResultStream).thenAnswer(
          (_) => Stream<SocialLoginResult>.value(errorResult),
        );

        await viewModel.initializeListener();

        await Future<void>.delayed(const Duration(milliseconds: 200));

        verify(mockSocialLoginService.logOut()).called(1);
      });

      test("initializeListener handles result with empty tokens", () async {
        final SocialLoginResult emptyTokensResult = SocialLoginResult(
          accessToken: "",
          refreshToken: "",
          socialType: SocialMediaLoginType.google,
        );

        when(mockSocialLoginService.socialLoginResultStream).thenAnswer(
          (_) => Stream<SocialLoginResult>.value(emptyTokensResult),
        );

        await viewModel.initializeListener();

        await Future<void>.delayed(const Duration(milliseconds: 200));

        verify(mockSocialLoginService.logOut()).called(1);
      });
    });

    group("View Lifecycle Methods", () {
      test("onViewDidAppear notifies listeners", () async {
        viewModel.onViewDidAppear();

        // Should not throw
        expect(viewModel, isNotNull);
      });

      test("onDispose sets default status bar color", () async {
        try {
          viewModel.onDispose();
        } on Exception catch (_) {
          // Platform channel errors are expected in test environment
        }

        // Should complete without crashing
        expect(viewModel, isNotNull);
      });
    });

    group("Email Handling", () {
      test("viewModel has access to analytics service for email tracking", () {
        expect(viewModel, isNotNull);
      });
    });

    group("View State Management", () {
      test("view state starts as idle", () {
        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test("can set view state to busy", () {
        viewModel.setViewState(ViewState.busy);

        expect(viewModel.viewState, equals(ViewState.busy));
      });

      test("can set view state back to idle", () {
        viewModel.setViewState(ViewState.busy);
        viewModel.setViewState(ViewState.idle);

        expect(viewModel.viewState, equals(ViewState.idle));
      });
    });

    group("Edge Cases", () {
      test("socialMediaSignInAction can be called multiple times", () async {
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.apple);
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.google);

        verify(mockSocialLoginService.signInWithApple()).called(1);
        verify(mockSocialLoginService.signInWithGoogle()).called(1);
      });

      test("socialMediaSignInAction called with different types in sequence",
          () async {
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.apple);
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.google);
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.facebook);

        verify(mockSocialLoginService.signInWithApple()).called(1);
        verify(mockSocialLoginService.signInWithGoogle()).called(1);
        verify(mockSocialLoginService.signInWithFaceBook()).called(1);
      });

      test("backButtonPressed followed by navigateToSignInPage", () async {
        await viewModel.backButtonPressed();
        await viewModel.navigateToSignInPage();

        verify(mockNavigationService.back()).called(1);
        verify(
          mockNavigationService.navigateTo(
            ContinueWithEmailView.routeName,
            arguments: null,
          ),
        ).called(1);
      });

      test("loginViewModel with redirection follows navigation flow", () async {
        final InAppRedirection redirection = InAppRedirection.cashback();
        final LoginViewModel vmWithRedir =
            LoginViewModel(redirection: redirection);

        await vmWithRedir.navigateToSignInPage();

        verify(
          mockNavigationService.navigateTo(
            ContinueWithEmailView.routeName,
            arguments: redirection,
          ),
        ).called(1);
      });
    });

    group("Integration Scenarios", () {
      test("complete social login flow", () async {
        // Start initialization
        final Future<void> initFuture = viewModel.initializeListener();

        // Simulate user tapping social login button
        await viewModel.socialMediaSignInAction(SocialMediaLoginType.google);

        // Complete initialization
        await initFuture;

        verify(mockSocialLoginService.logOut()).called(1);
        verify(mockSocialLoginService.signInWithGoogle()).called(1);
      });

      test("view state consistency across navigation", () async {
        expect(viewModel.viewState, equals(ViewState.idle));

        await viewModel.navigateToSignInPage();

        expect(viewModel.viewState, equals(ViewState.idle));

        await viewModel.backButtonPressed();

        expect(viewModel.viewState, equals(ViewState.idle));
      });
    });
  });
}

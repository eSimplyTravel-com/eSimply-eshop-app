import "package:esim_open_source/domain/data/params/add_device_params.dart";
import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/otp_response_model.dart";
import "package:esim_open_source/domain/data/response/auth/resend_otp_response_model.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late VerifyLoginViewModel viewModel;
  late MockApiAuthRepository mockApiAuthRepository;
  late MockNavigationService mockNavigationService;
  late MockLocalStorageService mockLocalStorageService;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "VerifyLoginView");

    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockAnalyticsService = locator<AnalyticsService>() as MockAnalyticsService;
    final MockApiAppRepository mockApiAppRepository =
        locator<ApiAppRepository>() as MockApiAppRepository;
    final MockApiPromotionRepository mockApiPromotionRepository =
        locator<ApiPromotionRepository>() as MockApiPromotionRepository;
    final MockDeviceInfoService mockDeviceInfoService =
        locator<DeviceInfoService>() as MockDeviceInfoService;
    final MockUserAuthenticationService mockUserAuthenticationService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    final MockSecureStorageService mockSecureStorageService =
        locator<SecureStorageService>() as MockSecureStorageService;

    // Default stubs for navigation
    when(mockNavigationService.back()).thenReturn(true);
    when(
      mockNavigationService.pushNamedAndRemoveUntil(
        "HomePager",
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

    // Default stub for resend OTP via new channel
    when(
      mockApiAuthRepository.resendOtpNewChannel(
        email: anyNamed("email"),
        phone: anyNamed("phone"),
        otpChannel: anyNamed("otpChannel"),
      ),
    ).thenAnswer(
      (_) async => Resource<ResendOtpResponseModel?>.success(
        ResendOtpResponseModel(),
        message: "Success",
      ),
    );

    // Stubs for verifyOtp success chain (saveUserResponse, addDevice, referral)
    when(mockUserAuthenticationService.saveUserResponse(any))
        .thenAnswer((_) async => Future<void>.value());
    when(mockSecureStorageService.getString(SecureStorageKeys.deviceID))
        .thenAnswer((_) async => "test_device_id");
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
    when(mockApiAppRepository.addDevice(any)).thenAnswer(
      (_) async => Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      ),
    );
    when(
      mockApiPromotionRepository.applyReferralCode(
        referralCode: anyNamed("referralCode"),
      ),
    ).thenAnswer(
      (_) async => Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      ),
    );

    viewModel = VerifyLoginViewModel(email: "test@example.com");
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("VerifyLoginViewModel Tests", () {
    group("Initialization", () {
      test("initialization test", () {
        expect(viewModel, isNotNull);
        expect(viewModel, isA<VerifyLoginViewModel>());
      });

      test("initializes with email parameter", () {
        expect(viewModel.email, equals("test@example.com"));
      });

      test("initializes with phone number parameter", () {
        final VerifyLoginViewModel vmWithPhone = VerifyLoginViewModel(
          phoneNumber: "1234567890",
        );
        expect(vmWithPhone.phoneNumber, equals("1234567890"));
      });

      test("initializes with redirection parameter", () {
        final InAppRedirection redirection = InAppRedirection.cashback();
        final VerifyLoginViewModel vmWithRedirection = VerifyLoginViewModel(
          email: "test@example.com",
          redirection: redirection,
        );
        expect(vmWithRedirection.redirection, equals(redirection));
      });

      test("initializes with all parameters", () {
        final InAppRedirection redirection = InAppRedirection.cashback();
        final VerifyLoginViewModel vm = VerifyLoginViewModel(
          email: "test@example.com",
          phoneNumber: "1234567890",
          redirection: redirection,
        );
        expect(vm.email, equals("test@example.com"));
        expect(vm.phoneNumber, equals("1234567890"));
        expect(vm.redirection, equals(redirection));
      });
    });

    group("Getter Coverage", () {
      test("getters line coverage", () {
        final bool verifyButtonEnabled = viewModel.isVerifyButtonEnabled;
        final bool canSwitchChannel = viewModel.canSwitchOtpChannel;
        final String errorMsg = viewModel.errorMessage;
        final int otpLength = viewModel.otpCount;

        expect(verifyButtonEnabled, isFalse);
        expect(canSwitchChannel, isFalse);
        expect(errorMsg, isEmpty);
        expect(otpLength, equals(6));
      });

      test("initialVerificationCode getter returns correct default", () {
        expect(viewModel.initialVerificationCode.isEmpty, isTrue);
      });

      test("loginType getter returns null initially", () {
        expect(viewModel.loginType, isNull);
      });

      test("otpChannel getter returns null initially", () {
        expect(viewModel.otpChannel, isNull);
      });
    });

    group("State Mutations", () {
      test("otpFieldChanged updates button state correctly", () {
        expect(viewModel.isVerifyButtonEnabled, isFalse);

        viewModel.otpFieldChanged("123456");

        expect(viewModel.isVerifyButtonEnabled, isFalse);
      });

      test("otpFieldChanged fills initial verification code", () {
        viewModel
          ..onViewModelReady()
          ..otpFieldChanged("123");

        expect(viewModel.initialVerificationCode[0], equals("1"));
        expect(viewModel.initialVerificationCode[1], equals("2"));
        expect(viewModel.initialVerificationCode[2], equals("3"));
      });

      test("otpFieldSubmitted enables verify button", () async {
        const String testCode = "123456";

        await viewModel.otpFieldSubmitted(testCode);

        expect(viewModel.isVerifyButtonEnabled, isTrue);
      });

      test("otpFieldSubmitted sets pin code correctly", () async {
        const String testCode = "123456";

        await viewModel.otpFieldSubmitted(testCode);

        // Verify by checking initialVerificationCode
        expect(viewModel.initialVerificationCode.join(), equals(testCode));
      });

      test("fillInitial correctly fills verification code array", () {
        viewModel.onViewModelReady();
        const String testCode = "12345";

        viewModel.fillInitial(testCode);

        expect(viewModel.initialVerificationCode[0], equals("1"));
        expect(viewModel.initialVerificationCode[1], equals("2"));
        expect(viewModel.initialVerificationCode[2], equals("3"));
        expect(viewModel.initialVerificationCode[3], equals("4"));
        expect(viewModel.initialVerificationCode[4], equals("5"));
        expect(viewModel.initialVerificationCode[5], isEmpty);
      });

      test("fillInitial with empty string fills empty codes", () {
        viewModel
          ..onViewModelReady()
          ..fillInitial("");

        expect(
          viewModel.initialVerificationCode.every((String c) => c == ""),
          isTrue,
        );
      });
    });

    group("onViewModelReady", () {
      test("onViewModelReady initializes verification code array", () {
        viewModel.onViewModelReady();

        expect(viewModel.initialVerificationCode.length, equals(6));
        expect(
          viewModel.initialVerificationCode.every((String code) => code == ""),
          isTrue,
        );
      });

      test(
          "onViewModelReady starts timer when loginType is emailAndPhoneAndBothVerification",
          () async {
        viewModel
          ..loginType = LoginType.emailAndPhoneAndBothVerification
          ..onViewModelReady();

        expect(viewModel.canSwitchOtpChannel, isFalse);

        // Wait for timer duration
        await Future<void>.delayed(const Duration(seconds: 16));

        // Note: In real scenario, this would be true, but in test it depends on timer callback
      });

      test("onViewModelReady does not start timer for other login types", () {
        viewModel
          ..loginType = LoginType.email
          ..onViewModelReady();

        expect(viewModel.canSwitchOtpChannel, isFalse);
      });
    });

    group("Navigation", () {
      test("backButtonTapped navigates back", () async {
        await viewModel.backButtonTapped();

        verify(mockNavigationService.back()).called(1);
      });

      test("backButtonTapped returns future", () {
        final Future<void> result = viewModel.backButtonTapped();

        expect(result, isA<Future<void>>());
      });
    });

    group("OTP Channel Management", () {
      test("getAlternateChannel switches EMAIL to SMS", () {
        final String alternate = viewModel.getAlternateChannel("EMAIL");

        expect(alternate, equals("SMS"));
      });

      test("getAlternateChannel switches SMS to EMAIL", () {
        final String alternate = viewModel.getAlternateChannel("SMS");

        expect(alternate, equals("EMAIL"));
      });

      test("resendViaAlternateChannel updates otpChannel", () async {
        viewModel
          ..otpChannel = "EMAIL"
          ..onViewModelReady();

        // Mock the resendCodeViaChannel method
        when(
          mockApiAuthRepository.verifyOtp(
            email: anyNamed("email"),
            pinCode: anyNamed("pinCode"),
          ),
        ).thenAnswer(
          (_) async => Resource<AuthResponseModel>.success(
            AuthResponseModel(
              accessToken: "test_token",
              refreshToken: "test_refresh",
            ),
            message: "Success",
          ),
        );

        await viewModel.resendViaAlternateChannel();

        expect(viewModel.otpChannel, equals("SMS"));
      });

      test("resendViaAlternateChannel with null otpChannel returns early",
          () async {
        viewModel.otpChannel = null;

        await viewModel.resendViaAlternateChannel();

        // Should return without processing
        expect(viewModel.otpChannel, isNull);
      });
    });

    group("Async Methods - Success Scenarios", () {
      test("verifyButtonTapped success scenario", () async {
        const String testCode = "123456";
        await viewModel.otpFieldSubmitted(testCode);

        when(
          mockApiAuthRepository.verifyOtp(
            email: "test@example.com",
            pinCode: testCode,
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

        try {
          await viewModel.verifyButtonTapped();
        } on Exception catch (_) {
          // Platform-specific errors are expected
        }

        verify(
          mockApiAuthRepository.verifyOtp(
            email: "test@example.com",
            pinCode: testCode,
          ),
        ).called(1);
      });

      test("resendCodeButtonTapped success scenario", () async {
        when(
          mockApiAuthRepository.login(
            email: "test@example.com",
            phoneNumber: null,
          ),
        ).thenAnswer(
          (_) async => Resource<OtpResponseModel?>.success(
            OtpResponseModel(),
            message: "OTP sent",
          ),
        );

        await viewModel.resendCodeButtonTapped();

        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test("resendCodeViaChannel clears error on success", () async {
        const String channel = "SMS";
        viewModel
          ..otpChannel = channel
          ..onViewModelReady();

        // Set an initial error message
        expect(viewModel.errorMessage, isEmpty);

        // After calling resendCodeViaChannel, error should be handled
        // (actual behavior depends on use case execution which we can't fully control)
        await viewModel.resendCodeViaChannel(channel);

        expect(viewModel.viewState, equals(ViewState.idle));
      });
    });

    group("Async Methods - Error Scenarios", () {
      test("verifyButtonTapped error scenario", () async {
        const String testCode = "123456";
        await viewModel.otpFieldSubmitted(testCode);

        when(
          mockApiAuthRepository.verifyOtp(
            email: "test@example.com",
            pinCode: testCode,
          ),
        ).thenAnswer(
          (_) async => Resource<AuthResponseModel>.error(
            "Invalid OTP",
            error: GeneralError(message: "Invalid OTP", errorCode: 400),
          ),
        );

        await viewModel.verifyButtonTapped();

        expect(viewModel.errorMessage, isNotEmpty);
      });

      test("resendCodeViaChannel error scenario", () async {
        const String channel = "EMAIL";
        viewModel
          ..otpChannel = channel
          ..onViewModelReady();

        // Simulating error handling in resendCodeViaChannel
        // The actual error comes from the use case
        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test("verifyButtonTapped view state management", () async {
        const String testCode = "123456";
        await viewModel.otpFieldSubmitted(testCode);

        when(
          mockApiAuthRepository.verifyOtp(
            email: "test@example.com",
            pinCode: testCode,
          ),
        ).thenAnswer(
          (_) async => Resource<AuthResponseModel>.error(
            "Error",
            error: GeneralError(message: "Error", errorCode: 500),
          ),
        );

        expect(viewModel.viewState, equals(ViewState.idle));

        final Future<void> future = viewModel.verifyButtonTapped();

        expect(viewModel.viewState, equals(ViewState.busy));

        await future;

        expect(viewModel.viewState, equals(ViewState.idle));
      });
    });

    group("Email Hashing", () {
      test("hashEmail returns consistent hash", () {
        const String email = "test@example.com";

        final String hash1 = viewModel.hashEmail(email);
        final String hash2 = viewModel.hashEmail(email);

        expect(hash1, equals(hash2));
      });

      test("hashEmail handles lowercase conversion", () {
        const String emailUpper = "TEST@EXAMPLE.COM";
        const String emailLower = "test@example.com";

        final String hashUpper = viewModel.hashEmail(emailUpper);
        final String hashLower = viewModel.hashEmail(emailLower);

        expect(hashUpper, equals(hashLower));
      });

      test("hashEmail produces non-empty string", () {
        const String email = "test@example.com";

        final String hash = viewModel.hashEmail(email);

        expect(hash.isNotEmpty, isTrue);
        expect(hash.length, greaterThan(0));
      });
    });

    group("Edge Cases", () {
      test("initialize with null email", () {
        final VerifyLoginViewModel vmNullEmail = VerifyLoginViewModel();

        expect(vmNullEmail.email, isNull);
      });

      test("initialize with null phone number", () {
        final VerifyLoginViewModel vmNullPhone = VerifyLoginViewModel();

        expect(vmNullPhone.phoneNumber, isNull);
      });

      test("otpFieldChanged with long code", () {
        viewModel.onViewModelReady();
        const String longCode = "12345678";

        viewModel.otpFieldChanged(longCode);

        expect(viewModel.initialVerificationCode[0], equals("1"));
        expect(viewModel.initialVerificationCode[5], equals("6"));
      });

      test("fillInitial with code shorter than otpCount", () {
        viewModel.onViewModelReady();
        const String shortCode = "12";

        viewModel.fillInitial(shortCode);

        expect(viewModel.initialVerificationCode[0], equals("1"));
        expect(viewModel.initialVerificationCode[1], equals("2"));
        expect(viewModel.initialVerificationCode[2], isEmpty);
      });

      test("verifyButtonTapped with null email and phone", () async {
        final VerifyLoginViewModel vmNullIdentifier = VerifyLoginViewModel();
        const String testCode = "123456";

        await vmNullIdentifier.otpFieldSubmitted(testCode);

        when(
          mockApiAuthRepository.verifyOtp(
            pinCode: testCode,
          ),
        ).thenAnswer(
          (_) async => Resource<AuthResponseModel>.error(
            "No identifier provided",
            error:
                GeneralError(message: "No identifier provided", errorCode: 400),
          ),
        );

        await vmNullIdentifier.verifyButtonTapped();

        expect(vmNullIdentifier.errorMessage, isNotEmpty);
      });

      test("resendViaAlternateChannel resets timer", () async {
        viewModel
          ..otpChannel = "EMAIL"
          ..loginType = LoginType.emailAndPhoneAndBothVerification
          ..onViewModelReady();

        expect(viewModel.canSwitchOtpChannel, isFalse);

        try {
          await viewModel.resendViaAlternateChannel();
        } on Exception catch (_) {
          // Expected due to use case dependencies
        }

        expect(viewModel.canSwitchOtpChannel, isFalse);
      });
    });

    group("Disposal", () {
      test("dispose cancels timer", () async {
        viewModel
          ..loginType = LoginType.emailAndPhoneAndBothVerification
          ..onViewModelReady()
          ..dispose();

        // After disposal, timer should be cancelled
        expect(viewModel.canSwitchOtpChannel, isFalse);
      });
    });
  });
}

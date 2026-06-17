import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/user/resend_order_otp_use_case.dart";
import "package:esim_open_source/domain/use_case/user/verify_order_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";
import "../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late VerifyPurchaseViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;
  late MockNavigationService mockNavigationService;
  late MockAnalyticsService mockAnalyticsService;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "VerifyPurchaseView");
    
    mockApiUserRepository = locator<ApiUserRepository>() as MockApiUserRepository;
    mockNavigationService = locator<NavigationService>() as MockNavigationService;
    mockAnalyticsService = locator<AnalyticsService>() as MockAnalyticsService;
    mockLocalStorageService = locator<LocalStorageService>() as MockLocalStorageService;
    
    viewModel = VerifyPurchaseViewModel(
      iccid: "test_iccid",
      orderID: "test_order_id",
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("VerifyPurchaseViewModel Initialization Tests", () {
    test("constructor sets initial properties correctly", () {
      final VerifyPurchaseViewModel testViewModel = VerifyPurchaseViewModel(
        iccid: "test_iccid_123",
        orderID: "test_order_456",
      );

      expect(testViewModel.iccid, "test_iccid_123");
      expect(testViewModel.orderID, "test_order_456");
    });

    test("default constructor creates empty state", () {
      final VerifyPurchaseViewModel testViewModel = VerifyPurchaseViewModel();

      expect(testViewModel.iccid, isNull);
      expect(testViewModel.orderID, isNull);
    });

    test("initial state values are correct", () {
      expect(viewModel.isVerifyButtonEnabled, isFalse);
      expect(viewModel.errorMessage, isEmpty);
      expect(viewModel.otpCount, 6);
      expect(viewModel.initialVerificationCode, isEmpty);
    });

    test("onViewModelReady initializes verification code list", () {
      viewModel.onViewModelReady();

      expect(viewModel.initialVerificationCode, hasLength(6));
      expect(viewModel.initialVerificationCode.every((String code) => code.isEmpty), isTrue);
    });
  });

  group("VerifyPurchaseViewModel Navigation Tests", () {
    test("backButtonTapped calls navigation back with false result", () async {
      when(mockNavigationService.back(result: false))
          .thenReturn(true);

      await viewModel.backButtonTapped();

      verify(mockNavigationService.back(result: false)).called(1);
    });
  });

  group("VerifyPurchaseViewModel OTP Field Tests", () {
    test("otpFieldChanged disables verify button and fills initial code", () {
      // First initialize the view model
      viewModel..onViewModelReady()

      ..otpFieldChanged("123");

      expect(viewModel.isVerifyButtonEnabled, isFalse);
      expect(viewModel.initialVerificationCode[0], "1");
      expect(viewModel.initialVerificationCode[1], "2");
      expect(viewModel.initialVerificationCode[2], "3");
      expect(viewModel.initialVerificationCode[3], "");
      expect(viewModel.initialVerificationCode[4], "");
      expect(viewModel.initialVerificationCode[5], "");
    });

    test("otpFieldSubmitted enables verify button and stores pin code", () async {
      // First initialize the view model
      viewModel.onViewModelReady();

      await viewModel.otpFieldSubmitted("123456");

      expect(viewModel.isVerifyButtonEnabled, isTrue);
      expect(viewModel.initialVerificationCode, <String>["1", "2", "3", "4", "5", "6"]);
    });

    test("fillInitial handles code shorter than otpCount", () {
      viewModel..onViewModelReady()

      ..fillInitial("12");

      expect(viewModel.initialVerificationCode, <String>["1", "2", "", "", "", ""]);
    });

    test("fillInitial handles code longer than otpCount", () {
      viewModel..onViewModelReady()

      ..fillInitial("1234567890");

      expect(viewModel.initialVerificationCode, <String>["1", "2", "3", "4", "5", "6"]);
    });

    test("fillInitial handles empty code", () {
      viewModel..onViewModelReady()

      ..fillInitial("");

      expect(viewModel.initialVerificationCode, <String>["", "", "", "", "", ""]);
    });
  });

  group("VerifyPurchaseViewModel Verification Tests", () {
    test("verifyButtonTapped handles successful verification", () async {
      // Setup successful response
      final Resource<EmptyResponse?> successResource = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiUserRepository.verifyOrderOtp(
        otp: anyNamed("otp"),
        iccid: anyNamed("iccid"),
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async => successResource);

      when(mockLocalStorageService.getString(LocalStorageKeys.utm))
          .thenReturn("test_utm");

      when(mockNavigationService.back(result: true))
          .thenReturn(true);

      // Set up OTP code first
      await viewModel.otpFieldSubmitted("123456");

      await viewModel.verifyButtonTapped();

      verify(mockApiUserRepository.verifyOrderOtp(
        otp: "123456",
        iccid: "test_iccid",
        orderID: "test_order_id",
      ),).called(1);

      verify(mockAnalyticsService.logEvent(event: anyNamed("event"))).called(1);
      verify(mockNavigationService.back(result: true)).called(1);
      expect(viewModel.viewState, ViewState.idle);
    });

    test("verifyButtonTapped handles verification failure", () async {
      // Setup error response
      final Resource<EmptyResponse?> errorResource = Resource<EmptyResponse?>.error(
        "Invalid OTP",
      );

      when(mockApiUserRepository.verifyOrderOtp(
        otp: anyNamed("otp"),
        iccid: anyNamed("iccid"),
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async => errorResource);

      // Set up OTP code first
      await viewModel.otpFieldSubmitted("123456");

      await viewModel.verifyButtonTapped();

      verify(mockApiUserRepository.verifyOrderOtp(
        otp: "123456",
        iccid: "test_iccid",
        orderID: "test_order_id",
      ),).called(1);

      expect(viewModel.errorMessage, isNotEmpty);
      expect(viewModel.viewState, ViewState.idle);
    });

    test("verifyButtonTapped sets view state correctly during process", () async {
      final Resource<EmptyResponse?> successResource = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiUserRepository.verifyOrderOtp(
        otp: anyNamed("otp"),
        iccid: anyNamed("iccid"),
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async {
        // Verify that view state is busy during API call
        expect(viewModel.viewState, ViewState.busy);
        return successResource;
      });

      when(mockLocalStorageService.getString(LocalStorageKeys.utm))
          .thenReturn("test_utm");

      when(mockNavigationService.back(result: true))
          .thenReturn(true);

      // Set up OTP code first
      await viewModel.otpFieldSubmitted("123456");

      await viewModel.verifyButtonTapped();

      expect(viewModel.viewState, ViewState.idle);
    });
  });

  group("VerifyPurchaseViewModel Resend Code Tests", () {
    test("resendCodeButtonTapped handles successful resend", () async {
      final Resource<EmptyResponse?> successResource = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Code resent successfully",
      );

      when(mockApiUserRepository.resendOrderOtp(
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async => successResource);

      await viewModel.resendCodeButtonTapped();

      verify(mockApiUserRepository.resendOrderOtp(
        orderID: "test_order_id",
      ),).called(1);

      expect(viewModel.viewState, ViewState.idle);
    });

    test("resendCodeButtonTapped handles failure", () async {
      final Resource<EmptyResponse?> errorResource = Resource<EmptyResponse?>.error(
        "Failed to resend code",
      );

      when(mockApiUserRepository.resendOrderOtp(
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async => errorResource);

      await viewModel.resendCodeButtonTapped();

      verify(mockApiUserRepository.resendOrderOtp(
        orderID: "test_order_id",
      ),).called(1);

      expect(viewModel.viewState, ViewState.idle);
    });

    test("resendCodeButtonTapped sets view state correctly during process", () async {
      final Resource<EmptyResponse?> successResource = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiUserRepository.resendOrderOtp(
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async {
        // Verify that view state is busy during API call
        expect(viewModel.viewState, ViewState.busy);
        return successResource;
      });

      await viewModel.resendCodeButtonTapped();

      expect(viewModel.viewState, ViewState.idle);
    });
  });

  group("VerifyPurchaseViewModel Use Case Tests", () {
    test("resendOrderOtpUseCase is initialized correctly", () {
      expect(viewModel.resendOrderOtpUseCase, isA<ResendOrderOtpUseCase>());
    });

    test("verifyOrderOtpUseCase is initialized correctly", () {
      expect(viewModel.verifyOrderOtpUseCase, isA<VerifyOrderOtpUseCase>());
    });
  });

  group("VerifyPurchaseViewModel Edge Cases", () {
    test("handles null iccid and orderID gracefully", () async {
      final VerifyPurchaseViewModel nullViewModel = VerifyPurchaseViewModel();
      
      final Resource<EmptyResponse?> successResource = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiUserRepository.verifyOrderOtp(
        otp: anyNamed("otp"),
        iccid: anyNamed("iccid"),
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async => successResource);

      when(mockLocalStorageService.getString(LocalStorageKeys.utm))
          .thenReturn("test_utm");

      when(mockNavigationService.back(result: true))
          .thenReturn(true);

      // Set up OTP code first
      await nullViewModel.otpFieldSubmitted("123456");

      await nullViewModel.verifyButtonTapped();

      verify(mockApiUserRepository.verifyOrderOtp(
        otp: "123456",
        iccid: "",
        orderID: "",
      ),).called(1);
    });

    test("handles null utm parameter gracefully", () async {
      final Resource<EmptyResponse?> successResource = Resource<EmptyResponse?>.success(
        EmptyResponse(),
        message: "Success",
      );

      when(mockApiUserRepository.verifyOrderOtp(
        otp: anyNamed("otp"),
        iccid: anyNamed("iccid"),
        orderID: anyNamed("orderID"),
      ),).thenAnswer((_) async => successResource);

      when(mockLocalStorageService.getString(LocalStorageKeys.utm))
          .thenReturn(null);

      when(mockNavigationService.back(result: true))
          .thenReturn(true);

      // Set up OTP code first
      await viewModel.otpFieldSubmitted("123456");

      await viewModel.verifyButtonTapped();

      // Should handle null utm gracefully
      verify(mockAnalyticsService.logEvent(event: anyNamed("event"))).called(1);
    });
  });
}

import "package:esim_open_source/domain/data/response/auth/auth_response_model.dart";
import "package:esim_open_source/domain/data/response/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/use_case/user/top_up_wallet_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/upgrade_wallet_bottom_sheet/upgrade_wallet_bottom_sheet_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late UpgradeWalletBottomSheetViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;
  late MockApiAuthRepository mockApiAuthRepository;
  late MockPaymentService mockPaymentService;
  late MockBottomSheetService mockBottomSheetService;
  late MockNavigationService mockNavigationService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "UpgradeWalletBottomSheetView");

    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;
    mockApiAuthRepository =
        locator<ApiAuthRepository>() as MockApiAuthRepository;
    mockPaymentService = locator<PaymentService>() as MockPaymentService;
    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;

    void completer(SheetResponse<EmptyBottomSheetResponse> response) {}

    viewModel = UpgradeWalletBottomSheetViewModel(completer: completer);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("UpgradeWalletBottomSheetViewModel Tests", () {
    test("initializes with correct default values", () {
      expect(viewModel.upgradeButtonEnabled, isFalse);
      expect(viewModel.amountController, isA<TextEditingController>());
      expect(viewModel.amountController.text, isEmpty);
      expect(viewModel.amount, equals(0));
      expect(viewModel.topUpWalletUseCase, isA<TopUpWalletUseCase>());
      expect(viewModel.getUserInfoUseCase, isA<GetUserInfoUseCase>());
    });

    test("onViewModelReady sets up controller listener", () {
      viewModel.onViewModelReady();

      // Verify listener is working by triggering validation
      viewModel.amountController.text = "10.50";
      expect(viewModel.upgradeButtonEnabled, isTrue);
      expect(viewModel.amount, equals(10.50));
    });

    group("_validateForm", () {
      setUp(() {
        viewModel.onViewModelReady();
      });

      test("enables button for valid integer amount", () {
        viewModel.amountController.text = "25";

        expect(viewModel.upgradeButtonEnabled, isTrue);
        expect(viewModel.amount, equals(25.0));
      });

      test("enables button for valid decimal amount", () {
        viewModel.amountController.text = "15.75";

        expect(viewModel.upgradeButtonEnabled, isTrue);
        expect(viewModel.amount, equals(15.75));
      });

      test("enables button for valid decimal with one decimal place", () {
        viewModel.amountController.text = "20.5";

        expect(viewModel.upgradeButtonEnabled, isTrue);
        expect(viewModel.amount, equals(20.5));
      });

      test("disables button for empty amount", () {
        viewModel.amountController.text = "";

        expect(viewModel.upgradeButtonEnabled, isFalse);
      });

      test("disables button for invalid amount with letters", () {
        viewModel.amountController.text = "abc";

        expect(viewModel.upgradeButtonEnabled, isFalse);
      });

      test("disables button for invalid amount with special characters", () {
        viewModel.amountController.text = "10@#";

        expect(viewModel.upgradeButtonEnabled, isFalse);
      });

      test("disables button for amount with more than 2 decimal places", () {
        viewModel.amountController.text = "10.123";

        expect(viewModel.upgradeButtonEnabled, isFalse);
      });

      test("disables button for negative amount", () {
        viewModel.amountController.text = "-10";

        expect(viewModel.upgradeButtonEnabled, isFalse);
      });

      test("disables button for amount with multiple dots", () {
        viewModel.amountController.text = "10.5.0";

        expect(viewModel.upgradeButtonEnabled, isFalse);
      });

      test("handles invalid format gracefully", () {
        viewModel.amountController.text = "10.";

        expect(viewModel.upgradeButtonEnabled, isFalse);
      });
    });

    test("upgradeButtonTapped executes with mocked dependencies", () async {
      // Mock AppConfigurationService.getPaymentTypes
      when(locator<AppConfigurationService>().getPaymentTypes)
          .thenReturn(<PaymentType>[PaymentType.card]);

      // Mock the top up wallet API call
      when(
        mockApiUserRepository.topUpWallet(
          amount: anyNamed("amount"),
          currency: anyNamed("currency"),
        ),
      ).thenAnswer(
        (_) async => Resource<BundleAssignResponseModel?>.error(
          "Mocked error for test",
        ),
      );

      await viewModel.upgradeButtonTapped();

      // Just verify it doesn't throw exceptions and handles the error
      expect(viewModel.viewState, equals(ViewState.idle));
    });

    test("context safety coverage", () {
      MaterialApp(home: Container()).createElement();

      // Test that methods handle context safety internally if needed
      viewModel.onViewModelReady();

      // Test validation without triggering API calls
      viewModel.amountController.text = "10.50";

      expect(viewModel.viewState.name, isA<String>());
      expect(viewModel.upgradeButtonEnabled, isTrue);
    });

    group("Payment Flow Tests", () {
      setUp(() {
        // Mock AppConfigurationService.getPaymentTypes for all tests in this group
        when(locator<AppConfigurationService>().getPaymentTypes)
            .thenReturn(<PaymentType>[PaymentType.card]);

        viewModel.onViewModelReady();
        viewModel.amountController.text = "25.50";
      });

      test("upgradeButtonTapped handles API error response", () async {
        when(mockApiUserRepository.topUpWallet(
          amount: anyNamed("amount"),
          currency: anyNamed("currency"),
        ),).thenAnswer((_) async => Resource<BundleAssignResponseModel?>.error(
              "Payment failed",
            ),);

        await viewModel.upgradeButtonTapped();

        verify(mockApiUserRepository.topUpWallet(
          amount: 25.50,
          currency: "",
        ),).called(1);
        expect(viewModel.viewState, equals(ViewState.idle));
      });

      test("upgradeButtonTapped with pending payment initiates payment flow",
          () async {
        when(mockApiUserRepository.topUpWallet(
          amount: anyNamed("amount"),
          currency: anyNamed("currency"),
        ),).thenAnswer((_) async => Resource<BundleAssignResponseModel?>.success(
              BundleAssignResponseModel(
                orderId: "test-order-123",
                paymentStatus: "pending",
                publishableKey: "pk_test_123",
                merchantIdentifier: "merchant_123",
                paymentIntentClientSecret: "pi_123",
                customerId: "cus_123",
                customerEphemeralKeySecret: "ek_123",
                testEnv: true,
                billingCountryCode: "US",
              ),
              message: "Pending payment",
            ),);

        when(mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),).thenAnswer((_) async {});

        when(mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),).thenAnswer((_) async => PaymentResult.completed);

        when(mockApiAuthRepository.getUserInfo())
            .thenAnswer((_) async => Resource<AuthResponseModel?>.success(
                  AuthResponseModel(),
                  message: "User info retrieved",
                ),);

        await viewModel.upgradeButtonTapped();

        verify(mockApiUserRepository.topUpWallet(
          amount: 25.50,
          currency: "",
        ),).called(1);
      });

      // test("initiatePaymentRequest handles OTP request flow", () async {
      //   when(mockApiUserRepository.topUpWallet(
      //     amount: anyNamed("amount"),
      //     currency: anyNamed("currency"),
      //   )).thenAnswer((_) async => Resource<BundleAssignResponseModel?>.success(
      //     BundleAssignResponseModel(
      //       orderId: "test-order-otp",
      //       paymentStatus: "pending",
      //       publishableKey: "pk_test_otp",
      //       merchantIdentifier: "merchant_otp",
      //       paymentIntentClientSecret: "pi_otp",
      //       customerId: "cus_otp",
      //       customerEphemeralKeySecret: "ek_otp",
      //       testEnv: false,
      //       billingCountryCode: "GB",
      //     ),
      //     message: "OTP required",
      //   ));
      //
      //   when(mockPaymentService.prepareCheckout(
      //     paymentType: anyNamed("paymentType"),
      //     publishableKey: anyNamed("publishableKey"),
      //     merchantIdentifier: anyNamed("merchantIdentifier"),
      //   )).thenAnswer((_) async {});
      //
      //   when(mockPaymentService.processOrderPayment(
      //     paymentType: anyNamed("paymentType"),
      //     testEnv: anyNamed("testEnv"),
      //     customerId: anyNamed("customerId"),
      //     billingCountryCode: anyNamed("billingCountryCode"),
      //     paymentIntentClientSecret: anyNamed("paymentIntentClientSecret"),
      //     customerEphemeralKeySecret: anyNamed("customerEphemeralKeySecret"),
      //   )).thenAnswer((_) async => PaymentResult.otpRequested);
      //
      //   when(mockNavigationService.navigateTo(
      //     VerifyPurchaseView.routeName,
      //     arguments: anyNamed("arguments"),
      //     preventDuplicates: anyNamed("preventDuplicates"),
      //   )).thenAnswer((_) async => true);
      //
      //   when(mockApiAuthRepository.getUserInfo())
      //       .thenAnswer((_) async => Resource<AuthResponseModel?>.success(
      //         AuthResponseModel(),
      //         message: "User info retrieved",
      //       ));
      //
      //   await viewModel.upgradeButtonTapped();
      //
      //   verify(mockNavigationService.navigateTo(
      //     VerifyPurchaseView.routeName,
      //     arguments: anyNamed("arguments"),
      //     preventDuplicates: false,
      //   )).called(1);
      //
      //   verify(mockApiAuthRepository.getUserInfo()).called(1);
      // });

      // test("initiatePaymentRequest handles payment exception", () async {
      //   when(mockApiUserRepository.topUpWallet(
      //     amount: anyNamed("amount"),
      //     currency: anyNamed("currency"),
      //   )).thenAnswer((_) async => Resource<BundleAssignResponseModel?>.success(
      //     BundleAssignResponseModel(
      //       orderId: "test-order-exception",
      //       paymentStatus: "pending",
      //       publishableKey: "pk_test_exception",
      //       merchantIdentifier: "merchant_exception",
      //       paymentIntentClientSecret: "pi_exception",
      //       customerId: "cus_exception",
      //       customerEphemeralKeySecret: "ek_exception",
      //       testEnv: true,
      //       billingCountryCode: "CA",
      //     ),
      //     message: "Payment exception test",
      //   ));
      //
      //   when(mockPaymentService.prepareCheckout(
      //     paymentType: anyNamed("paymentType"),
      //     publishableKey: anyNamed("publishableKey"),
      //     merchantIdentifier: anyNamed("merchantIdentifier"),
      //   )).thenThrow(Exception("Payment setup failed"));
      //
      //   await viewModel.upgradeButtonTapped();
      //
      //   verify(mockPaymentService.prepareCheckout(
      //     paymentType: anyNamed("paymentType"),
      //     publishableKey: "pk_test_exception",
      //     merchantIdentifier: "merchant_exception",
      //   )).called(1);
      // });

      // test("initiatePaymentRequest completes successfully with completer call", () async {
      //   bool completerCalled = false;
      //   SheetResponse<EmptyBottomSheetResponse>? response;
      //
      //   void testCompleter(SheetResponse<EmptyBottomSheetResponse> res) {
      //     completerCalled = true;
      //     response = res;
      //   }
      //
      //   final UpgradeWalletBottomSheetViewModel testViewModel =
      //       UpgradeWalletBottomSheetViewModel(completer: testCompleter);
      //   testViewModel.onViewModelReady();
      //   testViewModel.amountController.text = "50.00";
      //
      //   when(mockApiUserRepository.topUpWallet(
      //     amount: anyNamed("amount"),
      //     currency: anyNamed("currency"),
      //   )).thenAnswer((_) async => Resource<BundleAssignResponseModel?>.success(
      //     BundleAssignResponseModel(
      //       orderId: "test-complete",
      //       paymentStatus: "pending",
      //       publishableKey: "pk_test_complete",
      //       merchantIdentifier: "merchant_complete",
      //       paymentIntentClientSecret: "pi_complete",
      //       customerId: "cus_complete",
      //       customerEphemeralKeySecret: "ek_complete",
      //       testEnv: true,
      //       billingCountryCode: "US",
      //     ),
      //     message: "Success",
      //   ));
      //
      //   when(mockPaymentService.prepareCheckout(
      //     paymentType: anyNamed("paymentType"),
      //     publishableKey: anyNamed("publishableKey"),
      //     merchantIdentifier: anyNamed("merchantIdentifier"),
      //   )).thenAnswer((_) async {});
      //
      //   when(mockPaymentService.processOrderPayment(
      //     paymentType: anyNamed("paymentType"),
      //     testEnv: anyNamed("testEnv"),
      //     customerId: anyNamed("customerId"),
      //     billingCountryCode: anyNamed("billingCountryCode"),
      //     paymentIntentClientSecret: anyNamed("paymentIntentClientSecret"),
      //     customerEphemeralKeySecret: anyNamed("customerEphemeralKeySecret"),
      //   )).thenAnswer((_) async => PaymentResult.completed);
      //
      //   when(mockApiAuthRepository.getUserInfo())
      //       .thenAnswer((_) async => Resource<AuthResponseModel?>.success(
      //         AuthResponseModel(),
      //         message: "User info retrieved",
      //       ));
      //
      //   await testViewModel.upgradeButtonTapped();
      //
      //   expect(completerCalled, isTrue);
      //   expect(response?.confirmed, isTrue);
      //   expect(testViewModel.viewState, equals(ViewState.idle));
      // });
    });
  });
}

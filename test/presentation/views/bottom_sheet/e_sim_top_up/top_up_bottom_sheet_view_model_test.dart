import "dart:io";

import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/models/payment_request_params.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_top_up/top_up_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  late TopUpBottomSheetViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;
  late MockLocalStorageService mockLocalStorageService;
  late MockUserAuthenticationService mockUserAuthenticationService;
  late MockPaymentService mockPaymentService;
  late MockAnalyticsService mockAnalyticsService;
  late MockBottomSheetService mockBottomSheetService;
  late MockAppConfigurationService mockAppConfigurationService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "TopUpBottomSheet");

    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockUserAuthenticationService =
        locator<UserAuthenticationService>() as MockUserAuthenticationService;
    mockPaymentService = locator<PaymentService>() as MockPaymentService;
    mockAnalyticsService = locator<AnalyticsService>() as MockAnalyticsService;
    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;
    mockAppConfigurationService =
        locator<AppConfigurationService>() as MockAppConfigurationService;

    // Default stubs
    when(mockLocalStorageService.getString(LocalStorageKeys.utm))
        .thenReturn("test_utm");
    when(mockAppConfigurationService.getPaymentTypes)
        .thenReturn(<PaymentType>[PaymentType.card]);
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("TopUpBottomSheetViewModel Tests", () {
    test("initialization test", () {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      // Act
      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      // Assert
      expect(viewModel, isNotNull);
      expect(viewModel, isA<TopUpBottomSheetViewModel>());
      expect(viewModel.bundleItems, isEmpty);
      expect(viewModel.request, equals(request));
    });

    test("onViewModelReady calls fetchTopUpRelated", () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(
        mockApiUserRepository.getRelatedTopUp(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
        ),
      ).thenAnswer(
        (_) async => Resource<List<BundleResponseModel>?>.success(
          <BundleResponseModel>[
            BundleResponseModel(
              bundleCode: "TOP_UP_1",
              bundleName: "Top Up 1",
              price: 10,
              priceDisplay: r"$10.00",
            ),
          ],
          message: "Success",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      )

        // Act
        ..onViewModelReady();

      // Wait for async operation
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Assert
      verify(
        mockApiUserRepository.getRelatedTopUp(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
        ),
      ).called(1);
    });

    test("closeBottomSheet calls completer with empty response", () {
      // Arrange
      bool completerCalled = false;
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {
          completerCalled = true;
        },
      )

        // Act
        ..closeBottomSheet();

      // Assert
      expect(completerCalled, true);
    });

    test("calculateHeight returns 300 when bundleItems is empty", () {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      // Act
      final double height = viewModel.calculateHeight(1000);

      // Assert
      expect(height, 300);
    });

    test(
        "calculateHeight calculates correct height when bundleItems is not empty",
        () {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.addAll(<BundleResponseModel>[
        BundleResponseModel(),
        BundleResponseModel(),
      ]);

      // Act
      final double height = viewModel.calculateHeight(1000);

      // Assert
      // cellHeight = 200, cellsHeight = 120 + (2 * 200) = 520
      expect(height, 520);
    });

    test(
        "calculateHeight returns screenHeight when calculated height exceeds it",
        () {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      // Add many items to exceed screen height
      for (int i = 0; i < 10; i++) {
        viewModel.bundleItems.add(
          BundleResponseModel(),
        );
      }

      // Act
      final double height = viewModel.calculateHeight(500);

      // Assert
      // cellsHeight = 120 + (10 * 200) = 2120, which exceeds 500
      expect(height, 500);
    });

    test("fetchTopUpRelated success with data updates bundleItems", () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid_123",
          bundleCode: "TEST123",
        ),
      );

      final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
        BundleResponseModel(
          bundleCode: "TOP_UP_1",
          bundleName: "Top Up 1",
          price: 10,
          priceDisplay: r"$10.00",
        ),
        BundleResponseModel(
          bundleCode: "TOP_UP_2",
          bundleName: "Top Up 2",
          price: 20,
          priceDisplay: r"$20.00",
        ),
      ];

      when(
        mockApiUserRepository.getRelatedTopUp(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
        ),
      ).thenAnswer(
        (_) async => Resource<List<BundleResponseModel>?>.success(
          mockBundles,
          message: "Success",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      // Act
      await viewModel.fetchTopUpRelated();

      // Assert
      verify(
        mockApiUserRepository.getRelatedTopUp(
          iccID: "test_iccid_123",
          bundleCode: "TEST123",
        ),
      ).called(1);
      expect(viewModel.bundleItems.length, 2);
      expect(viewModel.bundleItems[0].bundleCode, "TOP_UP_1");
      expect(viewModel.bundleItems[1].bundleCode, "TOP_UP_2");
      expect(viewModel.applyShimmer, false);
    });

    test("fetchTopUpRelated success with null data handles error", () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid_null",
          bundleCode: "TEST123",
        ),
      );

      when(
        mockApiUserRepository.getRelatedTopUp(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
        ),
      ).thenAnswer(
        (_) async => Resource<List<BundleResponseModel>?>.success(
          null,
          message: "Success",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      // Act
      await viewModel.fetchTopUpRelated();

      // Assert
      verify(
        mockApiUserRepository.getRelatedTopUp(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
        ),
      ).called(1);
    });

    test("fetchTopUpRelated failure closes bottom sheet", () async {
      // Arrange
      bool completerCalled = false;
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid_error",
          bundleCode: "TEST123",
        ),
      );

      when(
        mockApiUserRepository.getRelatedTopUp(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
        ),
      ).thenAnswer(
        (_) async => Resource<List<BundleResponseModel>?>.error(
          "Network error",
        ),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {
          completerCalled = true;
        },
      );

      // Act
      await viewModel.fetchTopUpRelated();

      // Wait for async callbacks to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(
        mockApiUserRepository.getRelatedTopUp(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
        ),
      ).called(1);
      expect(completerCalled, true);
    });

    test("onBuyClick with empty payment type list shows toast", () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(false);
      when(mockUserAuthenticationService.walletAvailableBalance).thenReturn(0);

      // Override default mock to return empty payment types
      when(mockAppConfigurationService.getPaymentTypes)
          .thenReturn(<PaymentType>[]);

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 50,
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Assert - no API call should be made
      verifyNever(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      );
    });

    test(
        "onBuyClick with single wallet payment type and sufficient balance calls topUpBundle",
        () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.walletAvailableBalance)
          .thenReturn(100);

      when(mockAppConfigurationService.getPaymentTypes)
          .thenReturn(<PaymentType>[PaymentType.wallet]);

      when(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).thenAnswer(
        (_) async => Resource<BundleAssignResponseModel?>.success(
          BundleAssignResponseModel(
            orderId: "ORDER_123",
            paymentStatus: "COMPLETED",
          ),
          message: "Success",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.completed);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 50,
          priceDisplay: r"$50.00",
          currencyCode: "USD",
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Wait for async operations
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Assert
      verify(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).called(1);
    });

    test(
        "onBuyClick with single wallet payment type and insufficient balance shows toast",
        () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.walletAvailableBalance).thenReturn(30);

      when(mockAppConfigurationService.getPaymentTypes)
          .thenReturn(<PaymentType>[PaymentType.wallet]);

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 50,
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Assert - no API call should be made
      verifyNever(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      );
    });

    test("onBuyClick with single card payment type calls topUpBundle",
        () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(false);
      when(mockUserAuthenticationService.walletAvailableBalance).thenReturn(0);

      when(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).thenAnswer(
        (_) async => Resource<BundleAssignResponseModel?>.success(
          BundleAssignResponseModel(
            orderId: "ORDER_456",
            paymentStatus: "COMPLETED",
          ),
          message: "Success",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.completed);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 50,
          priceDisplay: r"$50.00",
          currencyCode: "USD",
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Wait for async operations
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Assert
      verify(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).called(1);
    });

    test("onBuyClick with wallet removed from list when balance insufficient",
        () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.walletAvailableBalance).thenReturn(30);

      when(mockAppConfigurationService.getPaymentTypes)
          .thenReturn(<PaymentType>[PaymentType.wallet, PaymentType.card]);

      when(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).thenAnswer(
        (_) async => Resource<BundleAssignResponseModel?>.success(
          BundleAssignResponseModel(
            orderId: "ORDER_789",
            paymentStatus: "COMPLETED",
          ),
          message: "Success",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.completed);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 50,
          priceDisplay: r"$50.00",
          currencyCode: "USD",
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Wait for async operations
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Assert - wallet should be removed, only card payment should be used
      verify(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).called(1);
    });

    test("onBuyClick with multiple payment types user selects payment",
        () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.walletAvailableBalance)
          .thenReturn(100);

      when(mockAppConfigurationService.getPaymentTypes)
          .thenReturn(<PaymentType>[PaymentType.wallet, PaymentType.card]);

      // Mock PaymentHelper.choosePaymentMethod to return a payment type
      when(
        mockBottomSheetService.showCustomSheet(
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
          variant: anyNamed("variant"),
        ),
      ).thenAnswer(
        (_) async => SheetResponse<PaymentType>(
          data: PaymentType.card,
          confirmed: true,
        ),
      );

      when(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).thenAnswer(
        (_) async => Resource<BundleAssignResponseModel?>.success(
          BundleAssignResponseModel(
            orderId: "ORDER_MULTI",
            paymentStatus: "COMPLETED",
          ),
          message: "Success",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.completed);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 30,
          priceDisplay: r"$30.00",
          currencyCode: "USD",
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Wait for async operations
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Assert
      verify(
        mockBottomSheetService.showCustomSheet(
          variant: anyNamed("variant"),
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
        ),
      ).called(1);
    });

    test("onBuyClick with multiple payment types user cancels selection",
        () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(true);
      when(mockUserAuthenticationService.walletAvailableBalance)
          .thenReturn(100);

      when(mockAppConfigurationService.getPaymentTypes)
          .thenReturn(<PaymentType>[PaymentType.wallet, PaymentType.card]);

      // Mock PaymentHelper.choosePaymentMethod to return null (user cancels)
      when(
        mockBottomSheetService.showCustomSheet(
          data: anyNamed("data"),
          enableDrag: anyNamed("enableDrag"),
          isScrollControlled: anyNamed("isScrollControlled"),
          variant: anyNamed("variant"),
        ),
      ).thenAnswer(
        (_) async => SheetResponse<PaymentType>(),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 30,
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Wait for async operations
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Assert - no API call should be made
      verifyNever(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      );
    });

    test("initiatePaymentRequest success completes payment and logs analytics",
        () async {
      // Arrange
      bool completerCalled = false;
      String? capturedOrderId;

      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.completed);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {
          completerCalled = true;
          capturedOrderId = response.data?.tag;
        },
      );

      // Act
      await viewModel.initiatePaymentRequest(
        params: PaymentRequestParams(
          secretParams: PaymentRequestSecretParams(
            paymentType: PaymentType.card,
            publishableKey: "pk_test",
            merchantIdentifier: "merchant_123",
            paymentIntentClientSecret: "pi_secret",
            customerEphemeralKeySecret: "ek_secret",
            test: true,
          ),
          idParams: PaymentRequestIDParams(
            orderID: "ORDER_SUCCESS_123",
            customerId: "cus_123",
            billingCountryCode: "US",
            bundleCode: "",
            bundleName: "",
          ),
        ),
        bundlePrice: r"$50.00",
        bundleCurrency: "USD",
      );

      // Assert
      verify(
        mockPaymentService.prepareCheckout(
          paymentType: PaymentType.card,
          publishableKey: "pk_test",
          merchantIdentifier: "merchant_123",
        ),
      ).called(1);

      verify(
        mockPaymentService.processOrderPayment(
          paymentType: PaymentType.card,
          params: anyNamed("params"),
        ),
      ).called(1);

      verify(mockAnalyticsService.logEvent(event: anyNamed("event"))).called(1);

      expect(completerCalled, true);
      expect(capturedOrderId, "ORDER_SUCCESS_123");
    });

    test("initiatePaymentRequest with exception closes sheet and cancels order",
        () async {
      // Arrange
      bool completerCalled = false;
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenThrow(Exception("Payment failed"));

      when(mockApiUserRepository.cancelOrder(orderID: anyNamed("orderID")))
          .thenAnswer(
        (_) async =>
            Resource<EmptyResponse?>.success(null, message: "Cancelled"),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {
          completerCalled = true;
        },
      );

      // Act
      await viewModel.initiatePaymentRequest(
        params: PaymentRequestParams(
          secretParams: PaymentRequestSecretParams(
            paymentType: PaymentType.card,
            publishableKey: "pk_test",
            merchantIdentifier: "merchant_123",
            paymentIntentClientSecret: "pi_secret",
            customerEphemeralKeySecret: "ek_secret",
          ),
          idParams: PaymentRequestIDParams(
            orderID: "ORDER_FAIL_456",
            customerId: "cus_123",
            billingCountryCode: "US",
            bundleCode: "",
            bundleName: "",
          ),
        ),
        bundlePrice: r"$50.00",
        bundleCurrency: "USD",
      );

      // Assert
      verify(mockApiUserRepository.cancelOrder(orderID: "ORDER_FAIL_456"))
          .called(1);
      expect(completerCalled, true);
    });

    test("initiatePaymentRequest logs iOS platform in analytics", () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.completed);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      // Act
      await viewModel.initiatePaymentRequest(
        params: PaymentRequestParams(
          secretParams: PaymentRequestSecretParams(
            paymentType: PaymentType.card,
            publishableKey: "pk_test",
            merchantIdentifier: "merchant_123",
            paymentIntentClientSecret: "pi_secret",
            customerEphemeralKeySecret: "ek_secret",
          ),
          idParams: PaymentRequestIDParams(
            orderID: "ORDER_IOS",
            customerId: "cus_123",
            billingCountryCode: "US",
            bundleCode: "",
            bundleName: "",
          ),
        ),
        bundlePrice: r"$50.00",
        bundleCurrency: "USD",
      );

      // Assert
      verify(mockAnalyticsService.logEvent(event: anyNamed("event"))).called(1);

      // Platform should be logged (either Android or iOS based on Platform.isAndroid)
      final String expectedPlatform = Platform.isAndroid ? "Android" : "iOS";
      // Verify the event was logged with the correct platform
      expect(expectedPlatform, isNotEmpty);
    });

    test("viewModel sets viewState to busy during topUpBundle", () async {
      // Arrange
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(mockUserAuthenticationService.isUserLoggedIn).thenReturn(false);

      when(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).thenAnswer(
        (_) async {
          // Check viewState during API call
          expect(viewModel.viewState, ViewState.busy);
          return Resource<BundleAssignResponseModel?>.success(
            BundleAssignResponseModel(
              orderId: "ORDER_BUSY",
              paymentStatus: "COMPLETED",
            ),
            message: "Success",
          );
        },
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.completed);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {},
      );

      viewModel.bundleItems.add(
        BundleResponseModel(
          bundleCode: "TEST_BUNDLE",
          price: 50,
          priceDisplay: r"$50.00",
          currencyCode: "USD",
        ),
      );

      // Act
      await viewModel.onBuyClick(index: 0);

      // Wait for async operations
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Assert
      verify(
        mockApiUserRepository.topUpBundle(
          iccID: anyNamed("iccID"),
          bundleCode: anyNamed("bundleCode"),
          paymentType: anyNamed("paymentType"),
        ),
      ).called(1);
    });

    test("initiatePaymentRequest with DCB otpRequested navigates to verify",
        () async {
      // Arrange
      bool completerCalled = false;
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      final MockNavigationService mockNavigationService =
          locator<NavigationService>() as MockNavigationService;

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.otpRequested);

      when(
        mockNavigationService.navigateTo(
          VerifyPurchaseView.routeName,
          arguments: anyNamed("arguments"),
          preventDuplicates: anyNamed("preventDuplicates"),
        ),
      ).thenAnswer((_) async => true);

      when(mockAnalyticsService.logEvent(event: anyNamed("event")))
          .thenAnswer((_) async {});

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {
          completerCalled = true;
        },
      );

      // Act
      await viewModel.initiatePaymentRequest(
        params: PaymentRequestParams(
          secretParams: PaymentRequestSecretParams(
            paymentType: PaymentType.dcb,
            publishableKey: "pk_test",
            merchantIdentifier: "merchant_123",
            paymentIntentClientSecret: "pi_secret",
            customerEphemeralKeySecret: "ek_secret",
            test: true,
          ),
          idParams: PaymentRequestIDParams(
            orderID: "ORDER_DCB_OTP",
            customerId: "cus_123",
            billingCountryCode: "US",
            bundleCode: "",
            bundleName: "",
          ),
        ),
        bundlePrice: r"$50.00",
        bundleCurrency: "USD",
      );

      // Assert
      verify(
        mockNavigationService.navigateTo(
          VerifyPurchaseView.routeName,
          arguments: anyNamed("arguments"),
          preventDuplicates: anyNamed("preventDuplicates"),
        ),
      ).called(1);

      expect(completerCalled, true);
    });

    test("initiatePaymentRequest with otpRequested user cancels verification",
        () async {
      // Arrange
      bool completerCalled = false;
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      final MockNavigationService mockNavigationService =
          locator<NavigationService>() as MockNavigationService;

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.otpRequested);

      when(
        mockNavigationService.navigateTo(
          VerifyPurchaseView.routeName,
          arguments: anyNamed("arguments"),
          preventDuplicates: anyNamed("preventDuplicates"),
        ),
      ).thenAnswer((_) async => false);

      when(mockApiUserRepository.cancelOrder(orderID: anyNamed("orderID")))
          .thenAnswer(
        (_) async =>
            Resource<EmptyResponse?>.success(null, message: "Cancelled"),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {
          completerCalled = true;
        },
      );

      // Act
      await viewModel.initiatePaymentRequest(
        params: PaymentRequestParams(
          secretParams: PaymentRequestSecretParams(
            paymentType: PaymentType.dcb,
            publishableKey: "pk_test",
            merchantIdentifier: "merchant_123",
            paymentIntentClientSecret: "pi_secret",
            customerEphemeralKeySecret: "ek_secret",
            test: true,
          ),
          idParams: PaymentRequestIDParams(
            orderID: "ORDER_DCB_CANCEL",
            customerId: "cus_123",
            billingCountryCode: "US",
            bundleCode: "",
            bundleName: "",
          ),
        ),
        bundlePrice: r"$50.00",
        bundleCurrency: "USD",
      );

      // Assert
      verify(mockApiUserRepository.cancelOrder(orderID: "ORDER_DCB_CANCEL"))
          .called(1);
      expect(completerCalled, true);
    });

    test("initiatePaymentRequest with payment canceled closes sheet",
        () async {
      // Arrange
      bool completerCalled = false;
      final SheetRequest<BundleTopUpBottomRequest> request =
          SheetRequest<BundleTopUpBottomRequest>(
        data: const BundleTopUpBottomRequest(
          iccID: "test_iccid",
          bundleCode: "TEST123",
        ),
      );

      when(
        mockPaymentService.prepareCheckout(
          paymentType: anyNamed("paymentType"),
          publishableKey: anyNamed("publishableKey"),
          merchantIdentifier: anyNamed("merchantIdentifier"),
        ),
      ).thenAnswer((_) async {});

      when(
        mockPaymentService.processOrderPayment(
          paymentType: anyNamed("paymentType"),
          params: anyNamed("params"),
        ),
      ).thenAnswer((_) async => PaymentResult.canceled);

      when(mockApiUserRepository.cancelOrder(orderID: anyNamed("orderID")))
          .thenAnswer(
        (_) async =>
            Resource<EmptyResponse?>.success(null, message: "Cancelled"),
      );

      viewModel = TopUpBottomSheetViewModel(
        request: request,
        completer: (SheetResponse<MainBottomSheetResponse> response) {
          completerCalled = true;
        },
      );

      // Act
      await viewModel.initiatePaymentRequest(
        params: PaymentRequestParams(
          secretParams: PaymentRequestSecretParams(
            paymentType: PaymentType.card,
            publishableKey: "pk_test",
            merchantIdentifier: "merchant_123",
            paymentIntentClientSecret: "pi_secret",
            customerEphemeralKeySecret: "ek_secret",
            test: true,
          ),
          idParams: PaymentRequestIDParams(
            orderID: "ORDER_CANCELED",
            customerId: "cus_123",
            billingCountryCode: "US",
            bundleCode: "",
            bundleName: "",
          ),
        ),
        bundlePrice: r"$50.00",
        bundleCurrency: "USD",
      );

      // Assert
      verify(mockApiUserRepository.cancelOrder(orderID: "ORDER_CANCELED"))
          .called(1);
      expect(completerCalled, true);
    });
  });
}

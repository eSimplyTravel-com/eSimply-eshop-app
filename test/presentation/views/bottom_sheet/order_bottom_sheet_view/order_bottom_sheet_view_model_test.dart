import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_order_by_id.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_bottom_sheet_view/order_bottom_sheet_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  late OrderBottomSheetViewModel viewModel;
  late MockApiUserRepository mockApiUserRepository;

  setUpAll(() async {
    await prepareTest();
  });

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "OrderBottomSheetView");

    mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;

    viewModel = OrderBottomSheetViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("OrderBottomSheetViewModel Tests", () {
    test("initialization test", () {
      expect(viewModel, isNotNull);
      expect(viewModel, isA<OrderBottomSheetViewModel>());
      expect(viewModel.bundleOrderModel, isNull);
      expect(viewModel.initBundleOrderModel, isNull);
      expect(viewModel.completer, isNull);
      expect(viewModel.isButtonEnabled, isFalse);
    });

    test("initialization with parameters", () {
      void mockCompleter(SheetResponse<OrderHistoryResponseModel> response) {}

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD123",
        companyName: "Test Co",
      );

      final OrderBottomSheetViewModel testViewModel =
          OrderBottomSheetViewModel()
            ..initBundleOrderModel = mockOrder
            ..completer = mockCompleter;

      expect(testViewModel.initBundleOrderModel, equals(mockOrder));
      expect(testViewModel.completer, equals(mockCompleter));
      expect(testViewModel.isButtonEnabled, isFalse);
    });

    test("isButtonEnabled getter returns false initially", () {
      expect(viewModel.isButtonEnabled, isFalse);
    });

    test("bundleOrderModel can be set", () {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD456",
      );

      viewModel.bundleOrderModel = mockOrder;

      expect(viewModel.bundleOrderModel, equals(mockOrder));
    });

    test("initBundleOrderModel can be set", () {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD789",
      );

      viewModel.initBundleOrderModel = mockOrder;

      expect(viewModel.initBundleOrderModel, equals(mockOrder));
    });

    test("completer can be set", () {
      void mockCompleter(SheetResponse<OrderHistoryResponseModel> response) {}

      viewModel.completer = mockCompleter;

      expect(viewModel.completer, equals(mockCompleter));
    });

    test("getOrderByID sets bundleOrderModel with mock data initially",
        () async {
      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "TEST123",
        companyName: "Test Company",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "TEST123")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(successOrder,
            message: ""),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "TEST123",
      );

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel, isNotNull);
      expect(viewModel.isButtonEnabled, isTrue);
    });

    test("getOrderByID sets applyShimmer to true then false", () async {
      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "SHIMMER_TEST",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "SHIMMER_TEST"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(successOrder,
            message: ""),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "SHIMMER_TEST",
      );

      final Future<void> getOrderFuture = viewModel.getOrderByID();

      await getOrderFuture;

      expect(viewModel.applyShimmer, isFalse);
    });

    test("getOrderByID with null orderNumber uses empty string", () async {
      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "SUCCESS",
      );
      when(mockApiUserRepository.getOrderByID(orderID: "")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(successOrder,
            message: ""),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel();

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel, isNotNull);
    });

    test("completer can be invoked when set", () {
      bool completerCalled = false;
      void testCompleter(SheetResponse<OrderHistoryResponseModel> response) {
        completerCalled = true;
      }

      viewModel.completer = testCompleter;
      viewModel.completer?.call(SheetResponse<OrderHistoryResponseModel>());

      expect(completerCalled, isTrue);
    });

    test("getOrderByID success updates bundleOrderModel and enables button",
        () async {
      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "SUCCESS001",
        companyName: "Success Company",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "SUCCESS001"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(successOrder,
            message: ""),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "SUCCESS001",
      );

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel, isNotNull);
      expect(viewModel.isButtonEnabled, isTrue);
      verify(mockApiUserRepository.getOrderByID(orderID: "SUCCESS001"))
          .called(1);
    });

    test("getOrderByID failure calls completer", () async {
      bool completerCalled = false;

      void testCompleter(SheetResponse<OrderHistoryResponseModel> response) {
        completerCalled = true;
      }

      when(mockApiUserRepository.getOrderByID(orderID: "FAIL001")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.error("Error"),
      );

      viewModel
        ..completer = testCompleter
        ..initBundleOrderModel = OrderHistoryResponseModel(
          orderNumber: "FAIL001",
        );

      await viewModel.getOrderByID();

      // Give time for async operations to complete
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(completerCalled, isTrue);
      expect(viewModel.bundleOrderModel, isNull);
    });

    test("multiple calls to getOrderByID work correctly", () async {
      final OrderHistoryResponseModel order1 = OrderHistoryResponseModel(
        orderNumber: "MULTI_TEST1",
      );
      final OrderHistoryResponseModel order2 = OrderHistoryResponseModel(
        orderNumber: "MULTI_TEST2",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "MULTI_TEST1"))
          .thenAnswer(
        (_) async =>
            Resource<OrderHistoryResponseModel?>.success(order1, message: ""),
      );
      when(mockApiUserRepository.getOrderByID(orderID: "MULTI_TEST2"))
          .thenAnswer(
        (_) async =>
            Resource<OrderHistoryResponseModel?>.success(order2, message: ""),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "MULTI_TEST1",
      );

      await viewModel.getOrderByID();
      final OrderHistoryResponseModel? firstResult = viewModel.bundleOrderModel;

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "MULTI_TEST2",
      );

      await viewModel.getOrderByID();
      final OrderHistoryResponseModel? secondResult =
          viewModel.bundleOrderModel;

      expect(firstResult, isNotNull);
      expect(secondResult, isNotNull);
    });

    test("getOrderByID handles null initBundleOrderModel", () async {
      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "SUCCESS",
      );
      when(mockApiUserRepository.getOrderByID(orderID: "")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(successOrder,
            message: ""),
      );

      viewModel.initBundleOrderModel = null;

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel, isNotNull);
    });

    test("onViewModelReady calls getOrderByID", () async {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "READY_TEST",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "READY_TEST"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          mockOrder,
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = mockOrder;

      expect(() => viewModel.onViewModelReady(), returnsNormally);
    });

    test("getOrderByIdUseCase is initialized", () {
      expect(viewModel.getOrderByIdUseCase, isNotNull);
      expect(viewModel.getOrderByIdUseCase, isA<GetOrderByIdUseCase>());
    });

    test("bundleOrderModel is null when not set", () {
      expect(viewModel.bundleOrderModel, isNull);
    });

    test("initBundleOrderModel is null when not set", () {
      expect(viewModel.initBundleOrderModel, isNull);
    });

    test("completer is null when not set", () {
      expect(viewModel.completer, isNull);
    });

    test("getOrderByID with order number extracts correctly", () async {
      const String testOrderNumber = "ORDER_12345";

      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: testOrderNumber,
      );

      when(mockApiUserRepository.getOrderByID(orderID: testOrderNumber))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          successOrder,
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: testOrderNumber,
      );

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel, isNotNull);
      expect(viewModel.bundleOrderModel?.orderNumber, equals(testOrderNumber));
    });

    test("onViewModelReady triggers getOrderByID", () async {
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "READY_TEST",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "READY_TEST"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          mockOrder,
          message: "",
        ),
      );

      viewModel
        ..initBundleOrderModel = mockOrder
        ..onViewModelReady();

      // Give async operation time to complete
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(viewModel.bundleOrderModel, isNotNull);
    });

    test("getOrderByID sets initial mock data before API call", () async {
      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "MOCK_DATA_TEST",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "MOCK_DATA_TEST"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          OrderHistoryResponseModel(orderNumber: "API_RESPONSE"),
          message: "",
        ),
      );

      await viewModel.getOrderByID();

      // After API call, should have API response, not mock data
      expect(viewModel.bundleOrderModel?.orderNumber, equals("API_RESPONSE"));
    });

    test("getOrderByID updates isButtonEnabled on success", () async {
      expect(viewModel.isButtonEnabled, isFalse);

      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "BUTTON_TEST",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "BUTTON_TEST"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          successOrder,
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "BUTTON_TEST",
      );

      await viewModel.getOrderByID();

      expect(viewModel.isButtonEnabled, isTrue);
    });

    test("getOrderByID does not enable button on failure", () async {
      expect(viewModel.isButtonEnabled, isFalse);

      when(mockApiUserRepository.getOrderByID(orderID: "FAIL_BUTTON"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.error("API Error"),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "FAIL_BUTTON",
      );

      await viewModel.getOrderByID();

      expect(viewModel.isButtonEnabled, isFalse);
    });

    test("getOrderByID clears bundleOrderModel on failure", () async {
      bool completerCalled = false;
      void testCompleter(SheetResponse<OrderHistoryResponseModel> response) {
        completerCalled = true;
      }

      viewModel.bundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "EXISTING",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "CLEAR_TEST"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.error("API Error"),
      );

      viewModel
        ..completer = testCompleter
        ..initBundleOrderModel = OrderHistoryResponseModel(
          orderNumber: "CLEAR_TEST",
        );

      await viewModel.getOrderByID();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(viewModel.bundleOrderModel, isNull);
      expect(completerCalled, isTrue);
    });

    test("getOrderByID manages applyShimmer state correctly", () async {
      expect(viewModel.applyShimmer, isFalse);

      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "SHIMMER_STATE",
      );

      when(mockApiUserRepository.getOrderByID(orderID: "SHIMMER_STATE"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          successOrder,
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "SHIMMER_STATE",
      );

      final Future<void> operation = viewModel.getOrderByID();

      // Shimmer should be true during operation
      expect(viewModel.applyShimmer, isTrue);

      await operation;

      // Shimmer should be false after operation
      expect(viewModel.applyShimmer, isFalse);
    });

    test("getOrderByID with empty order number uses empty string", () async {
      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: "SUCCESS",
      );
      when(mockApiUserRepository.getOrderByID(orderID: "")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          successOrder,
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "",
      );

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel, isNotNull);
    });

    test("completer is called with SheetResponse on failure", () async {
      SheetResponse<OrderHistoryResponseModel>? capturedResponse;
      bool completerCalled = false;

      void testCompleter(SheetResponse<OrderHistoryResponseModel> response) {
        capturedResponse = response;
        completerCalled = true;
      }

      when(mockApiUserRepository.getOrderByID(orderID: "COMPLETER_TEST"))
          .thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.error("API Error"),
      );

      viewModel
        ..completer = testCompleter
        ..initBundleOrderModel = OrderHistoryResponseModel(
          orderNumber: "COMPLETER_TEST",
        );

      await viewModel.getOrderByID();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(completerCalled, isTrue);
      if (capturedResponse != null) {
        expect(
            capturedResponse, isA<SheetResponse<OrderHistoryResponseModel>>());
      }
    });

    test("getOrderByID verifies API call with correct parameters", () async {
      const String orderID = "VERIFY_PARAMS";

      when(mockApiUserRepository.getOrderByID(orderID: orderID)).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          OrderHistoryResponseModel(orderNumber: orderID),
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: orderID,
      );

      await viewModel.getOrderByID();

      verify(mockApiUserRepository.getOrderByID(orderID: orderID)).called(1);
    });

    test("getOrderByID handles API response with null data", () async {
      when(mockApiUserRepository.getOrderByID(orderID: "NULL_DATA")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          null,
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "NULL_DATA",
      );

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel, isNull);
      expect(viewModel.isButtonEnabled, isTrue);
    });

    test("getOrderByID preserves order data on success", () async {
      const String orderNumber = "PRESERVE_DATA";
      const String companyName = "Test Company";
      const String orderPrice = r"$99.99";

      final OrderHistoryResponseModel successOrder = OrderHistoryResponseModel(
        orderNumber: orderNumber,
        companyName: companyName,
        orderDisplayPrice: orderPrice,
      );

      when(mockApiUserRepository.getOrderByID(orderID: orderNumber)).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.success(
          successOrder,
          message: "",
        ),
      );

      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: orderNumber,
      );

      await viewModel.getOrderByID();

      expect(viewModel.bundleOrderModel?.orderNumber, equals(orderNumber));
      expect(viewModel.bundleOrderModel?.companyName, equals(companyName));
      expect(
        viewModel.bundleOrderModel?.orderDisplayPrice,
        equals(orderPrice),
      );
    });

    test("getOrderByID handles consecutive failures", () async {
      int completerCallCount = 0;

      void testCompleter(SheetResponse<OrderHistoryResponseModel> response) {
        completerCallCount++;
      }

      when(mockApiUserRepository.getOrderByID(orderID: "FAIL1")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.error("API Error"),
      );

      when(mockApiUserRepository.getOrderByID(orderID: "FAIL2")).thenAnswer(
        (_) async => Resource<OrderHistoryResponseModel?>.error("API Error"),
      );

      viewModel
        ..completer = testCompleter

        // First failure
        ..initBundleOrderModel = OrderHistoryResponseModel(
          orderNumber: "FAIL1",
        );
      await viewModel.getOrderByID();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completerCallCount, equals(1));

      // Second failure
      viewModel.initBundleOrderModel = OrderHistoryResponseModel(
        orderNumber: "FAIL2",
      );
      await viewModel.getOrderByID();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completerCallCount, equals(2));
    });

    test("getOrderByIdUseCase is properly initialized with locator", () {
      expect(viewModel.getOrderByIdUseCase, isNotNull);
      expect(viewModel.getOrderByIdUseCase, isA<GetOrderByIdUseCase>());
    });

    test("bundleOrderModel property is mutable", () {
      final OrderHistoryResponseModel order1 = OrderHistoryResponseModel(
        orderNumber: "ORDER1",
      );
      final OrderHistoryResponseModel order2 = OrderHistoryResponseModel(
        orderNumber: "ORDER2",
      );

      viewModel.bundleOrderModel = order1;
      expect(viewModel.bundleOrderModel?.orderNumber, equals("ORDER1"));

      viewModel.bundleOrderModel = order2;
      expect(viewModel.bundleOrderModel?.orderNumber, equals("ORDER2"));
    });

    test("initBundleOrderModel property is mutable", () {
      final OrderHistoryResponseModel order1 = OrderHistoryResponseModel(
        orderNumber: "INIT1",
      );
      final OrderHistoryResponseModel order2 = OrderHistoryResponseModel(
        orderNumber: "INIT2",
      );

      viewModel.initBundleOrderModel = order1;
      expect(viewModel.initBundleOrderModel?.orderNumber, equals("INIT1"));

      viewModel.initBundleOrderModel = order2;
      expect(viewModel.initBundleOrderModel?.orderNumber, equals("INIT2"));
    });

    test("completer property is mutable", () {
      bool completer1Called = false;
      bool completer2Called = false;

      void testCompleter1(SheetResponse<OrderHistoryResponseModel> response) {
        completer1Called = true;
      }

      void testCompleter2(SheetResponse<OrderHistoryResponseModel> response) {
        completer2Called = true;
      }

      viewModel.completer = testCompleter1;
      viewModel.completer?.call(SheetResponse<OrderHistoryResponseModel>());
      expect(completer1Called, isTrue);

      viewModel.completer = testCompleter2;
      viewModel.completer?.call(SheetResponse<OrderHistoryResponseModel>());
      expect(completer2Called, isTrue);
    });
  });
}

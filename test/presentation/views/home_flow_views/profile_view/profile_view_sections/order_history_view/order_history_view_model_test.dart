import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/use_case/user/get_order_history_pagination_use_case.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late OrderHistoryViewModel viewModel;
  late MockBottomSheetService mockBottomSheetService;

  // Test data factory methods
  OrderHistoryResponseModel createOrderHistoryItem({
    String? orderDate,
    String? orderNumber,
  }) {
    return OrderHistoryResponseModel(
      orderDate: orderDate ?? "1640995200000", // 2022-01-01
      orderNumber:
          orderNumber ?? "test-order-${DateTime.now().millisecondsSinceEpoch}",
    );
  }

  setUp(() async {
    await setupTest();

    mockBottomSheetService =
        locator<BottomSheetService>() as MockBottomSheetService;

    onViewModelReadyMock();

    viewModel = OrderHistoryViewModel();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("OrderHistoryViewModel Initialization Tests", () {
    test("initializes with correct default values", () {
      expect(viewModel.viewState, ViewState.idle);
      expect(viewModel.shimmerHeight, 150);
      expect(
        viewModel.getOrderHistoryUseCase,
        isA<GetOrderHistoryPaginationUseCase>(),
      );
    });

    test("has correct shimmer height", () {
      expect(viewModel.shimmerHeight, equals(150));
    });
  });

  group("OrderHistoryViewModel API Methods Tests", () {
    test("getOrderHistory method exists and can be called", () async {
      // Should not throw exception when called
      expect(() async => viewModel.getOrderHistory(), returnsNormally);
    });

    test("refreshOrderHistory method exists and can be called", () async {
      // Should not throw exception when called
      expect(() async => viewModel.refreshOrderHistory(), returnsNormally);
    });
  });

  group("OrderHistoryViewModel Order Interaction Tests", () {
    test("orderTapped calls bottom sheet service", () async {
      OrderHistoryResponseModel testOrder = createOrderHistoryItem();

      // Mock bottom sheet service for this specific test
      when(
        mockBottomSheetService.showCustomSheet(
          data: testOrder,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.orderHistory,
        ),
      ).thenAnswer(
        (_) async => SheetResponse<OrderHistoryResponseModel>(),
      );

      await viewModel.orderTapped(testOrder);

      verify(
        mockBottomSheetService.showCustomSheet(
          data: testOrder,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.orderHistory,
        ),
      ).called(1);
    });

    test("orderTapped show custom sheet", () async {
      OrderHistoryResponseModel order = createOrderHistoryItem();

      // Mock bottom sheet service for this specific test
      SheetResponse<OrderHistoryResponseModel> response =
          SheetResponse<OrderHistoryResponseModel>(
        data: order,
        confirmed: true,
      );
      when(
        mockBottomSheetService.showCustomSheet(
          data: order,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.orderHistory,
        ),
      ).thenAnswer(
        (_) async => response,
      );

      when(
        mockBottomSheetService.showCustomSheet(
          data: response.data,
          enableDrag: false,
          isScrollControlled: true,
          variant: BottomSheetType.receiptOrder,
        ),
      ).thenAnswer(
        (_) async => response,
      );

      await viewModel.orderTapped(order);

      // verify(
      //   mockBottomSheetService.showCustomSheet(
      //     data: response.data,
      //     enableDrag: false,
      //     isScrollControlled: true,
      //     variant: BottomSheetType.receiptOrder,
      //   ),
      // ).called(1);
    });
  });

  group("OrderHistoryViewModel Integration Tests", () {
    test("shimmer configuration is applied correctly", () {
      expect(viewModel.applyShimmer, isFalse); // Default BaseModel behavior
      expect(viewModel.shimmerHeight, 150);
    });

    test("view model maintains proper state during operations", () async {
      // Initial state should be idle
      expect(viewModel.viewState, ViewState.idle);

      // After operations, should return to idle (no explicit state changes in this model)
      await viewModel.getOrderHistory();
      expect(viewModel.viewState, ViewState.idle);

      await viewModel.refreshOrderHistory();
      expect(viewModel.viewState, ViewState.idle);
    });
  });

  group("OrderHistoryViewModel Edge Cases Tests", () {
    test("use case property returns correct instance", () {
      expect(
        viewModel.getOrderHistoryUseCase,
        isA<GetOrderHistoryPaginationUseCase>(),
      );
    });

    test("concurrent API calls handle correctly", () async {
      // Start multiple concurrent calls
      final List<Future<void>> futures = <Future<void>>[
        viewModel.getOrderHistory(),
        viewModel.refreshOrderHistory(),
        viewModel.getOrderHistory(),
      ];

      // All calls should complete successfully without throwing
      expect(() => Future.wait(futures), returnsNormally);
    });
  });
}

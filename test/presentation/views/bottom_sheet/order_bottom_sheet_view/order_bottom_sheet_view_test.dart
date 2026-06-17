import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/domain/data/response/user/payment_details_response_model.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_bottom_sheet_view/order_bottom_sheet_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/order_bottom_sheet_view/order_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/bundle_validity_view.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:flutter/foundation.dart";
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

  setUp(() async {
    await setupTest();

    FlutterError.onError = (FlutterErrorDetails details) {
      final String message = details.exceptionAsString();
      if (message.contains("A RenderFlex overflowed") ||
          message.contains("overflowed by") ||
          message.contains("RenderFlex") ||
          message.contains("OVERFLOWING")) {
        return;
      }
      if (!details.silent) {
        FlutterError.presentError(details);
      }
    };
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("OrderBottomSheetView Widget Tests", () {
    testWidgets("renders basic structure with mock ViewModel",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "OrderBottomSheetView");

      final MockOrderBottomSheetViewModel mockViewModel =
          locator<OrderBottomSheetViewModel>() as MockOrderBottomSheetViewModel;

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD-001",
        orderStatus: "Completed",
        orderDate: "1640995200000",
        companyName: "Test Co",
        paymentDetails:
            PaymentDetailsResponseModel(cardDisplay: "Visa ****4242"),
      );

      when(mockViewModel.initBundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.bundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.isButtonEnabled).thenReturn(true);
      when(mockViewModel.applyShimmer).thenReturn(false);
      when(mockViewModel.viewState).thenReturn(ViewState.idle);
      when(mockViewModel.isBusy).thenReturn(false);

      final SheetRequest<OrderHistoryResponseModel> request =
          SheetRequest<OrderHistoryResponseModel>(data: mockOrder);

      void completer(SheetResponse<OrderHistoryResponseModel> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: Scaffold(
              body: OrderBottomSheetView(
                requestBase: request,
                completer: completer,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      expect(find.byType(OrderBottomSheetView), findsOneWidget);
      expect(find.byType(BottomSheetCloseButton), findsOneWidget);
    });

    testWidgets("renders main button", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "OrderBottomSheetView");

      final MockOrderBottomSheetViewModel mockViewModel =
          locator<OrderBottomSheetViewModel>() as MockOrderBottomSheetViewModel;

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD-002",
        orderStatus: "Completed",
        orderDate: "1640995200000",
      );

      when(mockViewModel.initBundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.bundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.isButtonEnabled).thenReturn(true);
      when(mockViewModel.applyShimmer).thenReturn(false);
      when(mockViewModel.viewState).thenReturn(ViewState.idle);
      when(mockViewModel.isBusy).thenReturn(false);

      final SheetRequest<OrderHistoryResponseModel> request =
          SheetRequest<OrderHistoryResponseModel>(data: mockOrder);

      void completer(SheetResponse<OrderHistoryResponseModel> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: Scaffold(
              body: OrderBottomSheetView(
                requestBase: request,
                completer: completer,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      expect(find.byType(MainButton), findsOneWidget);
    });

    testWidgets("renders bundle validity view", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "OrderBottomSheetView");

      final MockOrderBottomSheetViewModel mockViewModel =
          locator<OrderBottomSheetViewModel>() as MockOrderBottomSheetViewModel;

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD-003",
        orderDate: "1640995200000",
      );

      when(mockViewModel.initBundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.bundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.isButtonEnabled).thenReturn(false);
      when(mockViewModel.applyShimmer).thenReturn(false);
      when(mockViewModel.viewState).thenReturn(ViewState.idle);
      when(mockViewModel.isBusy).thenReturn(false);

      final SheetRequest<OrderHistoryResponseModel> request =
          SheetRequest<OrderHistoryResponseModel>(data: mockOrder);

      void completer(SheetResponse<OrderHistoryResponseModel> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: Scaffold(
              body: OrderBottomSheetView(
                requestBase: request,
                completer: completer,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      expect(find.byType(BundleValidityView), findsOneWidget);
    });

    testWidgets("close button triggers completer", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "OrderBottomSheetView");

      final MockOrderBottomSheetViewModel mockViewModel =
          locator<OrderBottomSheetViewModel>() as MockOrderBottomSheetViewModel;

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD-004",
        orderDate: "1640995200000",
      );

      when(mockViewModel.initBundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.bundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.isButtonEnabled).thenReturn(true);
      when(mockViewModel.applyShimmer).thenReturn(false);
      when(mockViewModel.viewState).thenReturn(ViewState.idle);
      when(mockViewModel.isBusy).thenReturn(false);

      final SheetRequest<OrderHistoryResponseModel> request =
          SheetRequest<OrderHistoryResponseModel>(data: mockOrder);

      bool completerCalled = false;
      void completer(SheetResponse<OrderHistoryResponseModel> response) {
        completerCalled = true;
      }

      await tester.pumpWidget(
        createTestableWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: Scaffold(
              body: OrderBottomSheetView(
                requestBase: request,
                completer: completer,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      final Finder closeButtonFinder = find.descendant(
        of: find.byType(BottomSheetCloseButton),
        matching: find.byType(GestureDetector),
      );
      await tester.tap(closeButtonFinder.first);
      await tester.pump(const Duration(milliseconds: 300));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      expect(completerCalled, isTrue);
    });

    testWidgets("main button triggers completer with confirmed response",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "OrderBottomSheetView");

      final MockOrderBottomSheetViewModel mockViewModel =
          locator<OrderBottomSheetViewModel>() as MockOrderBottomSheetViewModel;

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD-005",
        orderDate: "1640995200000",
      );

      when(mockViewModel.initBundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.bundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.isButtonEnabled).thenReturn(true);
      when(mockViewModel.applyShimmer).thenReturn(false);
      when(mockViewModel.viewState).thenReturn(ViewState.idle);
      when(mockViewModel.isBusy).thenReturn(false);

      final SheetRequest<OrderHistoryResponseModel> request =
          SheetRequest<OrderHistoryResponseModel>(data: mockOrder);

      bool completerCalled = false;
      SheetResponse<OrderHistoryResponseModel>? capturedResponse;
      void completer(SheetResponse<OrderHistoryResponseModel> response) {
        completerCalled = true;
        capturedResponse = response;
      }

      await tester.pumpWidget(
        createTestableWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: Scaffold(
              body: OrderBottomSheetView(
                requestBase: request,
                completer: completer,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      await tester.tap(find.byType(MainButton));
      await tester.pump(const Duration(milliseconds: 300));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      expect(completerCalled, isTrue);
      expect(capturedResponse?.confirmed, isTrue);
    });

    testWidgets("renders with shimmer state", (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "OrderBottomSheetView");

      final MockOrderBottomSheetViewModel mockViewModel =
          locator<OrderBottomSheetViewModel>() as MockOrderBottomSheetViewModel;

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORD-006",
        orderDate: "1640995200000",
      );

      when(mockViewModel.initBundleOrderModel).thenReturn(mockOrder);
      when(mockViewModel.bundleOrderModel).thenReturn(null);
      when(mockViewModel.isButtonEnabled).thenReturn(false);
      when(mockViewModel.applyShimmer).thenReturn(true);
      when(mockViewModel.viewState).thenReturn(ViewState.idle);
      when(mockViewModel.isBusy).thenReturn(false);

      final SheetRequest<OrderHistoryResponseModel> request =
          SheetRequest<OrderHistoryResponseModel>(data: mockOrder);

      void completer(SheetResponse<OrderHistoryResponseModel> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: Scaffold(
              body: OrderBottomSheetView(
                requestBase: request,
                completer: completer,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      expect(find.byType(OrderBottomSheetView), findsOneWidget);
    });

    testWidgets("renders with null bundleOrderModel",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "OrderBottomSheetView");

      final MockOrderBottomSheetViewModel mockViewModel =
          locator<OrderBottomSheetViewModel>() as MockOrderBottomSheetViewModel;

      when(mockViewModel.initBundleOrderModel).thenReturn(null);
      when(mockViewModel.bundleOrderModel).thenReturn(null);
      when(mockViewModel.isButtonEnabled).thenReturn(false);
      when(mockViewModel.applyShimmer).thenReturn(false);
      when(mockViewModel.viewState).thenReturn(ViewState.idle);
      when(mockViewModel.isBusy).thenReturn(false);

      final SheetRequest<OrderHistoryResponseModel> request =
          SheetRequest<OrderHistoryResponseModel>();

      void completer(SheetResponse<OrderHistoryResponseModel> response) {}

      await tester.pumpWidget(
        createTestableWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(1200, 2000)),
            child: Scaffold(
              body: OrderBottomSheetView(
                requestBase: request,
                completer: completer,
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      tester.takeException();
      await tester.pump();
      tester.takeException();

      expect(find.byType(OrderBottomSheetView), findsOneWidget);
    });

    test("view created with required parameters", () {
      void mockCompleter(SheetResponse<OrderHistoryResponseModel> response) {}

      final SheetRequest<OrderHistoryResponseModel> requestBase =
          SheetRequest<OrderHistoryResponseModel>();

      final OrderBottomSheetView view = OrderBottomSheetView(
        completer: mockCompleter,
        requestBase: requestBase,
      );

      expect(view.completer, equals(mockCompleter));
      expect(view.requestBase, equals(requestBase));
    });

    test("completer can be called", () {
      bool completerCalled = false;
      void testCompleter(SheetResponse<OrderHistoryResponseModel> response) {
        completerCalled = true;
      }

      final SheetRequest<OrderHistoryResponseModel> requestBase =
          SheetRequest<OrderHistoryResponseModel>();

      final OrderBottomSheetView view = OrderBottomSheetView(
        completer: testCompleter,
        requestBase: requestBase,
      );

      view.completer(SheetResponse<OrderHistoryResponseModel>());
      expect(completerCalled, isTrue);
    });

    test("completer called with confirmed response", () {
      bool completerCalled = false;
      SheetResponse<OrderHistoryResponseModel>? capturedResponse;

      void testCompleter(SheetResponse<OrderHistoryResponseModel> response) {
        completerCalled = true;
        capturedResponse = response;
      }

      final SheetRequest<OrderHistoryResponseModel> requestBase =
          SheetRequest<OrderHistoryResponseModel>();

      final OrderBottomSheetView view = OrderBottomSheetView(
        completer: testCompleter,
        requestBase: requestBase,
      );

      view.completer(SheetResponse<OrderHistoryResponseModel>(confirmed: true));

      expect(completerCalled, isTrue);
      expect(capturedResponse?.confirmed, isTrue);
    });

    test("requestBase data is accessible", () {
      void mockCompleter(SheetResponse<OrderHistoryResponseModel> response) {}

      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderNumber: "ORDER-12345",
        companyName: "Flutter eSIM Company",
        orderDisplayPrice: r"$25.99",
        orderDate: "1640995200000",
        orderStatus: "Completed",
      );

      final SheetRequest<OrderHistoryResponseModel> requestBase =
          SheetRequest<OrderHistoryResponseModel>(data: mockOrder);

      final OrderBottomSheetView view = OrderBottomSheetView(
        completer: mockCompleter,
        requestBase: requestBase,
      );

      expect(view.requestBase.data?.orderNumber, equals("ORDER-12345"));
      expect(
          view.requestBase.data?.companyName, equals("Flutter eSIM Company"));
      expect(view.requestBase.data?.orderDisplayPrice, equals(r"$25.99"));
    });

    test("requestBase with null data", () {
      void mockCompleter(SheetResponse<OrderHistoryResponseModel> response) {}

      final SheetRequest<OrderHistoryResponseModel> requestBase =
          SheetRequest<OrderHistoryResponseModel>();

      final OrderBottomSheetView view = OrderBottomSheetView(
        completer: mockCompleter,
        requestBase: requestBase,
      );

      expect(view.requestBase.data, isNull);
    });

    test("debugFillProperties adds requestBase and completer", () {
      void mockCompleter(SheetResponse<OrderHistoryResponseModel> response) {}

      final SheetRequest<OrderHistoryResponseModel> requestBase =
          SheetRequest<OrderHistoryResponseModel>();

      final OrderBottomSheetView view = OrderBottomSheetView(
        completer: mockCompleter,
        requestBase: requestBase,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      view.debugFillProperties(builder);

      final List<DiagnosticsNode> properties = builder.properties;
      expect(
        properties.any((DiagnosticsNode node) => node.name == "requestBase"),
        isTrue,
      );
      expect(
        properties.any((DiagnosticsNode node) => node.name == "completer"),
        isTrue,
      );
    });
  });
}

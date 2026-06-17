import "package:esim_open_source/domain/data/response/user/order_history_response_model.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/order_history_view/order_history_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_paginated_state_list_view.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";
import "../../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();

    // Mock NavigationRouter to avoid missing stub error
    MockNavigationRouter mockNavigationRouter = locator<NavigationRouter>() as MockNavigationRouter;
    when(mockNavigationRouter.isPageVisible(any)).thenReturn(true);

    onViewModelReadyMock();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("OrderHistoryView Widget Tests", () {
    testWidgets("renders basic structure with navigation title",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Verify navigation title is present
      expect(find.byType(CommonNavigationTitle), findsOneWidget);

      // Verify main structure is present
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets("renders empty paginated list view component",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Verify EmptyPaginatedStateListView is present
      expect(
          find.byType(EmptyPaginatedStateListView<OrderHistoryResponseModel>),
          findsOneWidget,);
    });

    testWidgets("displays correct shimmer structure",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // The shimmer method creates a ListView with SizedBox items
      final OrderHistoryView orderHistoryView = const OrderHistoryView();
      final Widget shimmerWidget = orderHistoryView.getShimmerData();

      expect(shimmerWidget, isA<ListView>());
    });

    testWidgets("widget can be created without errors",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OrderHistoryView(),
        ),
      );
      await tester.pump();

      // Basic verification that the widget renders without errors
      expect(find.byType(OrderHistoryView), findsOneWidget);
    });

    testWidgets("bundleOrderHistoryView method executes correctly",
        (WidgetTester tester) async {
      const OrderHistoryView orderHistoryView = OrderHistoryView();

      // Create mock order data
      final OrderHistoryResponseModel mockOrder = OrderHistoryResponseModel(
        orderDate: "1640995200000",
        orderNumber: "test-order-123",
      );

      // Get view model from locator
      final OrderHistoryViewModel viewModel =
          locator<OrderHistoryViewModel>();

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (BuildContext context) {
              // Call bundleOrderHistoryView method
              return orderHistoryView.bundleOrderHistoryView(
                context: context,
                viewModel: viewModel,
                bundleOrder: mockOrder,
              );
            },
          ),
        ),
      );

      await tester.pump();

      // Verify the widget was built
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets("getShimmerData returns correct ListView structure",
        (WidgetTester tester) async {
      const OrderHistoryView orderHistoryView = OrderHistoryView();

      // Call getShimmerData method directly
      final Widget shimmerWidget = orderHistoryView.getShimmerData();

      // Verify it returns a ListView
      expect(shimmerWidget, isA<ListView>());

      // Test the widget can be rendered
      await tester.pumpWidget(
        createTestableWidget(shimmerWidget),
      );

      await tester.pump();

      // Verify it renders without errors
      expect(find.byType(ListView), findsOneWidget);
    });

    test("routeName constant is correctly defined", () {
      expect(OrderHistoryView.routeName, equals("OrderHistoryView"));
    });
  });
}

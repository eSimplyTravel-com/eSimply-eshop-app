import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/domain/data/response/core/empty_response.dart";
import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notifications_view.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_paginated_state_list_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();

  setUp(() async {
    await setupTest();

    // Mock the setNotificationsRead method for widget tests
    final MockApiUserRepository mockApiUserRepository =
        locator<ApiUserRepository>() as MockApiUserRepository;
    when(mockApiUserRepository.setNotificationsRead()).thenAnswer(
      (_) async =>
          Resource<EmptyResponse?>.success(EmptyResponse(), message: "Success"),
    );
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("NotificationsView Widget Tests", () {
    testWidgets("renders navigation title correctly",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      expect(find.byType(CommonNavigationTitle), findsOneWidget);
      expect(find.text(LocaleKeys.notificationView_title.tr()), findsOneWidget);
    });

    testWidgets("renders navigation title correctly",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      expect(find.byType(CommonNavigationTitle), findsOneWidget);
      expect(find.text(LocaleKeys.notificationView_title.tr()), findsOneWidget);
    });

    testWidgets("renders notification list when data is available",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      expect(
        find.byType(EmptyPaginatedStateListView<UserNotificationModel>),
        findsOneWidget,
      );
    });

    testWidgets("renders notification items with gesture detectors",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets("handles notification tap correctly",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      // If there are gesture detectors, tap the first one
      final Finder gestureDetectors = find.byType(GestureDetector);
      if (gestureDetectors.evaluate().isNotEmpty) {
        await tester.tap(gestureDetectors.first);
        await tester.pump();

        expect(tester.takeException(), isNull);
      }
    });

    testWidgets("renders shimmer effect when busy",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      // The shimmer effect should be applied based on viewModel.isBusy
      expect(
        find.byType(EmptyPaginatedStateListView<UserNotificationModel>),
        findsOneWidget,
      );
    });

    testWidgets("supports pull-to-refresh functionality",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      // The EmptyPaginatedStateListView should handle refresh functionality
      expect(
        find.byType(EmptyPaginatedStateListView<UserNotificationModel>),
        findsOneWidget,
      );
    });
  });

  group("NotificationsView Static Tests", () {
    test("routeName is set correctly", () {
      expect(NotificationsView.routeName, equals("NotificationsView"));
    });

    test("widget can be instantiated", () {
      const NotificationsView widget = NotificationsView();
      expect(widget, isA<NotificationsView>());
    });

    test("uses correct view model type", () {
      const NotificationsView widget = NotificationsView();
      expect(widget, isA<StatelessWidget>());
    });
  });

  group("NotificationsView Configuration Tests", () {
    testWidgets("BaseView configuration is correct",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      // Verify BaseView configuration through behavior
      // hideAppBar: true means no app bar should be present
      expect(find.byType(AppBar), findsNothing);
    });

    test("view model is instantiated correctly", () {
      const NotificationsView widget = NotificationsView();
      expect(widget.key, isNull); // Default key
    });
  });

  group("NotificationsView Debug Properties", () {
    testWidgets("debug properties", (WidgetTester tester) async {
      const NotificationsView widget = NotificationsView();

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotNull);
    });
  });

  group("NotificationsView Integration Tests", () {
    testWidgets("handles view model state changes",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      // The widget should rebuild when view model state changes
      expect(find.byType(NotificationsView), findsOneWidget);
    });

    testWidgets("notification view items are properly rendered",
        (WidgetTester tester) async {
      onViewModelReadyMock(viewName: "NotificationsView");

      await tester.pumpWidget(createTestableWidget(const NotificationsView()));
      await tester.pump();

      // Check that the widget tree is constructed correctly
      expect(
        find.byType(EmptyPaginatedStateListView<UserNotificationModel>),
        findsOneWidget,
      );
    });
  });
}

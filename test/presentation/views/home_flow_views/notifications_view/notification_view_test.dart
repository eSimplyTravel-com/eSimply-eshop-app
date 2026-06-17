import "package:esim_open_source/domain/data/response/user/user_notification_response.dart";
import "package:esim_open_source/presentation/views/home_flow_views/notifications_view/notification_view.dart";
import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("NotificationView Widget Tests", () {
    late UserNotificationModel testNotificationModel;

    setUp(() async {
      await setupTest();
      testNotificationModel = UserNotificationModel(
        notificationId: 1,
        title: "Test Notification",
        content: "Test content",
        datetime: "1640995200", // 2022-01-01 00:00:00 UTC timestamp
        status: false, // Unread notification
        transactionStatus: "success",
        transaction: "test_transaction",
        transactionMessage: "Test message",
        iccid: "test_iccid",
        category: "general",
        translatedMessage: "Translated message",
      );
    });

    testWidgets("renders correctly with all components", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: testNotificationModel),
        ),
      );
      await tester.pump();

      expect(find.byType(NotificationView), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Badge), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(2));
    });

    testWidgets("displays notification title correctly", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: testNotificationModel),
        ),
      );
      await tester.pump();

      expect(find.text("Test Notification"), findsOneWidget);
    });

    testWidgets("displays formatted date correctly", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: testNotificationModel),
        ),
      );
      await tester.pump();

      final String expectedDate = DateTimeUtils.formatTimestampToDate(
        timestamp: int.parse(testNotificationModel.datetime ?? "0"),
        format: DateTimeUtils.ddMmYyyy,
      );
      expect(find.text(expectedDate), findsOneWidget);
    });

    testWidgets("shows unread badge when status is false", (WidgetTester tester) async {
      final UserNotificationModel unreadModel = testNotificationModel.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(status: false),
        ),
      );
      
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: unreadModel),
        ),
      );
      await tester.pump();

      final Badge badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isTrue);
    });

    testWidgets("hides badge when status is true", (WidgetTester tester) async {
      final UserNotificationModel readModel = testNotificationModel.copyWith(
        UserNotificationModelParams(
          metaInfo: NotificationMetaParams(status: true),
        ),
      );
      
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: readModel),
        ),
      );
      await tester.pump();

      final Badge badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isFalse);
    });

    testWidgets("handles null title gracefully", (WidgetTester tester) async {
      final UserNotificationModel nullTitleModel = UserNotificationModel(
        notificationId: 1,
        datetime: "1640995200",
        status: false,
      );
      
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: nullTitleModel),
        ),
      );
      await tester.pump();

      expect(find.text("N/A"), findsOneWidget);
    });

    testWidgets("handles null datetime gracefully", (WidgetTester tester) async {
      final UserNotificationModel nullDateModel = UserNotificationModel(
        notificationId: 1,
        title: "Test",
        status: false,
      );
      
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: nullDateModel),
        ),
      );
      await tester.pump();

      final String expectedDate = DateTimeUtils.formatTimestampToDate(
        timestamp: 0,
        format: DateTimeUtils.ddMmYyyy,
      );
      expect(find.text(expectedDate), findsOneWidget);
    });

    testWidgets("handles null status gracefully", (WidgetTester tester) async {
      final UserNotificationModel nullStatusModel = UserNotificationModel(
        notificationId: 1,
        title: "Test",
        datetime: "1640995200",
      );
      
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: nullStatusModel),
        ),
      );
      await tester.pump();

      final Badge badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isTrue); // null status treated as unread
    });

    testWidgets("has proper widget structure", (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          NotificationView(notificationsModel: testNotificationModel),
        ),
      );
      await tester.pump();

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Align), findsOneWidget);
      expect(find.byType(Badge), findsOneWidget);
      
      final Column column = tester.widget<Column>(find.byType(Column));
      expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
    });

    testWidgets("debug properties", (WidgetTester tester) async {
      final NotificationView widget = NotificationView(notificationsModel: testNotificationModel);

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      final List<DiagnosticsNode> props = builder.properties;

      final DiagnosticsProperty<UserNotificationModel> notificationsModelProp = 
          props.firstWhere((DiagnosticsNode p) => p.name == "notificationsModel")
              as DiagnosticsProperty<UserNotificationModel>;

      expect(notificationsModelProp.value, equals(testNotificationModel));
      expect(notificationsModelProp.value?.title, equals("Test Notification"));
    });
  });

  group("NotificationView Method Coverage Tests", () {
    late UserNotificationModel testNotificationModel;

    setUp(() async {
      await setupTest();
      testNotificationModel = UserNotificationModel(
        notificationId: 1,
        title: "Coverage Test",
        datetime: "1640995200",
        status: false,
      );
    });

    test("build method coverage", () {
      final NotificationView widget = NotificationView(
        notificationsModel: testNotificationModel,
      );
      
      expect(widget.notificationsModel, equals(testNotificationModel));
      expect(widget.runtimeType, equals(NotificationView));
    });

    test("debugFillProperties method coverage", () {
      final NotificationView widget = NotificationView(notificationsModel: testNotificationModel);
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      
      expect(() => widget.debugFillProperties(builder), returnsNormally);
      
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.length, greaterThan(0));
      expect(props.any((DiagnosticsNode p) => p.name == "notificationsModel"), isTrue);
    });

    test("constructor coverage", () {
      final UserNotificationModel model = testNotificationModel;
      
      expect(() => NotificationView(notificationsModel: model), returnsNormally);
      expect(() => NotificationView(notificationsModel: UserNotificationModel()), returnsNormally);
    });

    test("widget properties access coverage", () {
      final NotificationView widget = NotificationView(notificationsModel: testNotificationModel);
      
      expect(widget.notificationsModel, equals(testNotificationModel));
      expect(widget.key, isNull);
      expect(widget.runtimeType, equals(NotificationView));
    });
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });
}

import "package:esim_open_source/presentation/widgets/empty_state_list_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  const SizedBox emptyWidget = SizedBox(
    height: 200,
    child: Center(child: Text("Empty")),
  );

  group("EmptyStateListView Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("shows empty state widget when items is empty",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EmptyStateListView<String>(
              items: const <String>[],
              emptyStateWidget: emptyWidget,
              itemBuilder: (BuildContext context, int index) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text("Empty"), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets("shows list when items are present",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EmptyStateListView<String>(
              items: const <String>["a", "b", "c"],
              emptyStateWidget: emptyWidget,
              itemBuilder: (BuildContext context, int index) =>
                  Text("Item ${index}"),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text("Item 0"), findsOneWidget);
      expect(find.text("Empty"), findsNothing);
    });

    testWidgets("uses custom separatorBuilder when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EmptyStateListView<String>(
              items: const <String>["a", "b"],
              emptyStateWidget: emptyWidget,
              itemBuilder: (BuildContext context, int index) =>
                  Text("Item ${index}"),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(key: Key("sep")),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(const Key("sep")), findsWidgets);
    });

    testWidgets("invokes onRefresh on empty pull-to-refresh",
        (WidgetTester tester) async {
      // Arrange
      bool refreshed = false;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EmptyStateListView<String>(
              items: const <String>[],
              emptyStateWidget: emptyWidget,
              onRefresh: () async => refreshed = true,
              itemBuilder: (BuildContext context, int index) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      );
      await tester.fling(
        find.byType(SingleChildScrollView),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      // Assert
      expect(refreshed, isTrue);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final EmptyStateListView<String> widget = EmptyStateListView<String>(
        items: const <String>["x"],
        emptyStateWidget: emptyWidget,
        itemBuilder: (BuildContext context, int index) => const SizedBox(),
        onRefresh: () async {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "items"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "itemBuilder"), isTrue);
      expect(
        props.any((DiagnosticsNode p) => p.name == "separatorBuilder"),
        isTrue,
      );
      expect(props.any((DiagnosticsNode p) => p.name == "onRefresh"), isTrue);
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(emptyStateListViewPreview()),
      );

      // Assert
      expect(find.byType(EmptyStateListView<String>), findsOneWidget);
      expect(find.text("No items to display"), findsOneWidget);
    });
  });
}

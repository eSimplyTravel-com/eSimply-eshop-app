import "package:esim_open_source/presentation/widgets/creation_aware_list_item.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("CreationAwareListItem Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders its child", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const CreationAwareListItem(child: Text("Item")),
        ),
      );

      // Assert
      expect(find.byType(CreationAwareListItem), findsOneWidget);
      expect(find.text("Item"), findsOneWidget);
    });

    testWidgets("invokes itemCreated on init", (WidgetTester tester) async {
      // Arrange
      bool called = false;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          CreationAwareListItem(
            itemCreated: () => called = true,
            child: const Text("Item"),
          ),
        ),
      );

      // Assert
      expect(called, isTrue);
    });

    testWidgets("does not crash when itemCreated is null",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const CreationAwareListItem(child: Text("Item")),
        ),
      );

      // Assert
      expect(tester.takeException(), isNull);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final CreationAwareListItem widget = CreationAwareListItem(
        itemCreated: () {},
        child: const SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      expect(
        builder.properties.any((DiagnosticsNode p) => p.name == "itemCreated"),
        isTrue,
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(creationAwareListItemPreview()),
      );

      // Assert
      expect(find.byType(CreationAwareListItem), findsOneWidget);
      expect(find.text("Sample list item"), findsOneWidget);
    });
  });
}

import "package:esim_open_source/presentation/widgets/warning_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("WarningWidget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    testWidgets("renders with warning content", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const WarningWidget(
            warningTextContent: "Please be careful",
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Please be careful"), findsOneWidget);
    });

    testWidgets("renders as Card widget", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const WarningWidget(
            warningTextContent: "Warning",
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets("contains info icon", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const WarningWidget(
            warningTextContent: "Test warning",
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    test("handles content property", () {
      // Arrange & Act
      const WarningWidget widget = WarningWidget(
        warningTextContent: "Test content",
      );

      // Assert
      expect(widget.warningTextContent, equals("Test content"));
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("warning-key");
      final WarningWidget widget = WarningWidget(
        key: k,
        warningTextContent: "Keyed warning",
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const WarningWidget widget = WarningWidget(
        warningTextContent: "Debug warning",
      );
      final DiagnosticPropertiesBuilder builder =
          DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      expect(
        props.any((DiagnosticsNode p) => p.name == "warningTextContent"),
        isTrue,
      );
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}

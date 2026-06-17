import "package:esim_open_source/presentation/widgets/text_link.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("TextLink Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    testWidgets("renders with text", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const TextLink("Click me"),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Click me"), findsOneWidget);
    });

    testWidgets("renders with empty string when text is null",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const TextLink(null),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text(""), findsOneWidget);
    });

    testWidgets("contains gesture detector", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const TextLink("Link"),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets("calls onPressed when tapped", (WidgetTester tester) async {
      // Arrange
      bool pressed = false;
      await tester.pumpWidget(
        createTestableWidget(
          TextLink(
            "Tap me",
            onPressed: () => pressed = true,
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.text("Tap me"));
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });

    testWidgets("does not call onPressed when null and tapped",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const TextLink("No callback"),
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.text("No callback"));
      await tester.pump();

      // Assert - should not throw
      expect(find.text("No callback"), findsOneWidget);
    });

    testWidgets("text widget has correct styling", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const TextLink("Styled"),
        ),
      );
      await tester.pump();

      // Assert
      final Text textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontWeight, equals(FontWeight.w700));
      expect(textWidget.style?.fontSize, equals(14));
    });

    test("handles text property", () {
      // Arrange & Act
      const TextLink widget = TextLink("Test link");

      // Assert
      expect(widget.text, equals("Test link"));
    });

    test("handles null text property", () {
      // Arrange & Act
      const TextLink widget = TextLink(null);

      // Assert
      expect(widget.text, isNull);
    });

    test("handles onPressed property", () {
      // Arrange
      bool called = false;
      void callback() => called = true;

      // Act
      final TextLink widget = TextLink(
        "Link",
        onPressed: callback,
      );

      // Assert
      expect(widget.onPressed, isNotNull);
    });

    test("has default values", () {
      // Arrange & Act
      const TextLink widget = TextLink("Default");

      // Assert
      expect(widget.text, equals("Default"));
      expect(widget.onPressed, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("link-key");
      final TextLink widget = TextLink(
        "Keyed link",
        key: k,
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final TextLink widget = TextLink(
        "Debug link",
        onPressed: () {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      expect(
        props.any((DiagnosticsNode p) => p.name == "text"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "onPressed"),
        isTrue,
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestableWidget(textLinkPreview()));
      await tester.pump();

      // Assert
      expect(find.byType(TextLink), findsOneWidget);
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}

import "package:esim_open_source/presentation/widgets/animated_circular_progress_indicator.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("AnimatedCircularProgressIndicator Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    testWidgets("renders with basic properties", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.5,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(AnimatedCircularProgressIndicator), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets("renders with custom background color",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.75,
            valueColor: Colors.green,
            backgroundColor: Colors.grey,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets("renders with custom stroke width",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.8,
            valueColor: Colors.red,
            strokeWidth: 50,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      final CircularProgressIndicator indicator =
          tester.widget<CircularProgressIndicator>(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
      );

      expect(indicator.strokeWidth, equals(50));
    });

    testWidgets("renders with custom stroke cap", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.6,
            valueColor: Colors.orange,
            strokeCap: StrokeCap.square,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      final CircularProgressIndicator indicator =
          tester.widget<CircularProgressIndicator>(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
      );

      expect(indicator.strokeCap, equals(StrokeCap.square));
    });

    testWidgets("renders with custom duration", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.9,
            valueColor: Colors.purple,
            duration: Duration(milliseconds: 500),
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(AnimatedBuilder),
        ),
        findsOneWidget,
      );
    });

    testWidgets("animates progress value", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 1,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets("updates when target value changes",
        (WidgetTester tester) async {
      // Arrange & Act - Initial render with 0.3
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.3,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      await tester.pump();

      // Update target value to 0.7
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.7,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets("handles zero target value", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets("handles full progress (1.0)", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 1,
            valueColor: Colors.green,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets("handles loading state", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.5,
            valueColor: Colors.blue,
            isLoading: true,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    testWidgets("circular progress indicator has correct value color",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.5,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      final CircularProgressIndicator indicator =
          tester.widget<CircularProgressIndicator>(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
      );

      expect(indicator.valueColor, isA<AlwaysStoppedAnimation<Color>>());
    });

    test("handles property values", () {
      // Arrange & Act
      const AnimatedCircularProgressIndicator widget =
          AnimatedCircularProgressIndicator(
        targetValue: 0.5,
        valueColor: Colors.blue,
        isLoading: false,
      );

      // Assert
      expect(widget.targetValue, equals(0.5));
      expect(widget.valueColor, equals(Colors.blue));
      expect(widget.isLoading, equals(false));
      expect(widget.duration, equals(const Duration(milliseconds: 1000)));
      expect(widget.strokeWidth, equals(35));
      expect(widget.strokeCap, equals(StrokeCap.round));
    });

    test("handles custom property values", () {
      // Arrange & Act
      const AnimatedCircularProgressIndicator widget =
          AnimatedCircularProgressIndicator(
        targetValue: 0.75,
        valueColor: Colors.red,
        backgroundColor: Colors.grey,
        duration: Duration(milliseconds: 500),
        strokeWidth: 50,
        strokeCap: StrokeCap.square,
        isLoading: true,
      );

      // Assert
      expect(widget.targetValue, equals(0.75));
      expect(widget.valueColor, equals(Colors.red));
      expect(widget.backgroundColor, equals(Colors.grey));
      expect(widget.duration, equals(const Duration(milliseconds: 500)));
      expect(widget.strokeWidth, equals(50));
      expect(widget.strokeCap, equals(StrokeCap.square));
      expect(widget.isLoading, equals(true));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const AnimatedCircularProgressIndicator widget =
          AnimatedCircularProgressIndicator(
        targetValue: 0.85,
        valueColor: Colors.purple,
        backgroundColor: Colors.yellow,
        duration: Duration(milliseconds: 750),
        strokeWidth: 40,
        strokeCap: StrokeCap.butt,
        isLoading: true,
      );

      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);

      expect(
        props.any((DiagnosticsNode prop) => prop.name == "targetValue"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode prop) => prop.name == "duration"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode prop) => prop.name == "backgroundColor"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode prop) => prop.name == "valueColor"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode prop) => prop.name == "strokeWidth"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode prop) => prop.name == "strokeCap"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode prop) => prop.name == "isLoading"),
        isTrue,
      );
    });

    test("can be instantiated with a key", () {
      // Arrange
      const Key k = ValueKey<String>("test-key");

      // Act
      final AnimatedCircularProgressIndicator widget =
          AnimatedCircularProgressIndicator(
        key: k,
        targetValue: 0.5,
        valueColor: Colors.blue,
        isLoading: false,
      );

      // Assert
      expect(widget.key, equals(k));
    });

    testWidgets("default backgroundColor is used when not provided",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.5,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      final CircularProgressIndicator indicator =
          tester.widget<CircularProgressIndicator>(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
      );

      expect(indicator.backgroundColor, isNotNull);
    });

    testWidgets("handles rapid target value changes",
        (WidgetTester tester) async {
      // Arrange & Act - Initial render
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.2,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      await tester.pump();

      // Rapid update 1
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.5,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      await tester.pump();

      // Rapid update 2
      await tester.pumpWidget(
        createTestableWidget(
          const AnimatedCircularProgressIndicator(
            targetValue: 0.8,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      );

      // Assert
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(AnimatedCircularProgressIndicator),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}

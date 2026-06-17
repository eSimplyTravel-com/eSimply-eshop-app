import "package:esim_open_source/presentation/widgets/animations/count_down.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("Countdown Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders countdown text", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Countdown(
              numberOfSeconds: 60,
              onCounterCompleted: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(Countdown), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets("calls onCounterCompleted when finished",
        (WidgetTester tester) async {
      // Arrange
      bool completed = false;
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Countdown(
              numberOfSeconds: 1,
              onCounterCompleted: () => completed = true,
            ),
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(completed, isTrue);
    });

    test("handles property values", () {
      // Arrange & Act
      final Countdown widget = Countdown(
        numberOfSeconds: 30,
        onCounterCompleted: () {},
      );

      // Assert
      expect(widget.numberOfSeconds, equals(30));
      expect(widget.onCounterCompleted, isNotNull);
      expect(widget.build, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("countdown-key");
      final Countdown widget = Countdown(
        key: k,
        numberOfSeconds: 10,
        onCounterCompleted: () {},
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final Countdown widget = Countdown(
        numberOfSeconds: 15,
        onCounterCompleted: () {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "numberOfSeconds",
        "onCounterCompleted",
        "build",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "expected '$name'",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestableWidget(countdownPreview()));
      await tester.pump();

      // Assert
      expect(find.byType(Countdown), findsOneWidget);
    });
  });
}

import "package:esim_open_source/presentation/widgets/animations/shake_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("ShakeWidget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders child without animation", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const ShakeWidget(
            startAnimation: false,
            child: Text("Steady"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(ShakeWidget), findsOneWidget);
      expect(find.text("Steady"), findsOneWidget);
      expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
    });

    testWidgets("animates when startAnimation is true",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const ShakeWidget(
            startAnimation: true,
            child: Text("Shake"),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text("Shake"), findsOneWidget);
    });

    test("handles default property values", () {
      // Arrange & Act
      const ShakeWidget widget = ShakeWidget(
        startAnimation: false,
        child: SizedBox(),
      );

      // Assert
      expect(widget.duration, equals(const Duration(milliseconds: 500)));
      expect(widget.deltaX, equals(20));
      expect(widget.curve, equals(Curves.easeInCubic));
      expect(widget.startAnimation, isFalse);
    });

    test("handles custom property values", () {
      // Arrange & Act
      const ShakeWidget widget = ShakeWidget(
        startAnimation: true,
        duration: Duration(milliseconds: 800),
        deltaX: 40,
        curve: Curves.bounceIn,
        child: SizedBox(),
      );

      // Assert
      expect(widget.duration, equals(const Duration(milliseconds: 800)));
      expect(widget.deltaX, equals(40));
      expect(widget.curve, equals(Curves.bounceIn));
      expect(widget.startAnimation, isTrue);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("shake-key");
      const ShakeWidget widget = ShakeWidget(
        key: k,
        startAnimation: false,
        child: SizedBox(),
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const ShakeWidget widget = ShakeWidget(
        startAnimation: true,
        child: SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "duration",
        "deltaX",
        "curve",
        "startAnimation",
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
      await tester.pumpWidget(createTestableWidget(shakeWidgetPreview()));
      await tester.pump();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ShakeWidget), findsOneWidget);
    });
  });
}

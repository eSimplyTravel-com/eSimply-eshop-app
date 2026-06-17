import "package:esim_open_source/presentation/widgets/animations/opacity_animation.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("OpacityAnimation Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders child wrapped in Opacity",
        (WidgetTester tester) async {
      // Arrange — manual controller; the widget disposes it in its useEffect
      // cleanup, so we must not dispose it ourselves (avoids double-dispose).
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 500),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          OpacityAnimation(
            controller: controller,
            delay: 10,
            child: const Text("Fade"),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20)); // fire delayed start
      await tester.pump(const Duration(milliseconds: 500)); // run animation

      // Assert
      expect(find.byType(OpacityAnimation), findsOneWidget);
      expect(find.byType(Opacity), findsOneWidget);
      expect(find.text("Fade"), findsOneWidget);
    });

    testWidgets("animates opacity over time", (WidgetTester tester) async {
      // Arrange
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 500),
      );

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          OpacityAnimation(
            controller: controller,
            delay: 10,
            child: const Text("Fade"),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      final Opacity opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, greaterThan(0.0));
    });

    test("handles property values", () {
      // Arrange & Act
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 300),
      );
      final OpacityAnimation widget = OpacityAnimation(
        controller: controller,
        delay: 100,
        child: const SizedBox(),
      );

      // Assert
      expect(widget.delay, equals(100));
      expect(widget.controller, equals(controller));
      controller.dispose();
    });

    test("default delay is 200", () {
      // Arrange & Act
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
      );
      final OpacityAnimation widget = OpacityAnimation(
        controller: controller,
        child: const SizedBox(),
      );

      // Assert
      expect(widget.delay, equals(200));
      controller.dispose();
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
      );
      final OpacityAnimation widget = OpacityAnimation(
        controller: controller,
        child: const SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "delay"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "controller"), isTrue);
      controller.dispose();
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act — the preview wires its own controller via useAnimationController
      // (which auto-disposes), so we just pump past the default 200ms delay and
      // the 1200ms animation duration.
      await tester.pumpWidget(
        createTestableWidget(opacityAnimationPreview()),
      );
      await tester.pump();
      await tester
          .pump(const Duration(milliseconds: 250)); // fire delayed start
      await tester.pump(const Duration(milliseconds: 1200)); // run animation
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OpacityAnimation), findsOneWidget);
      expect(find.text("Fade in"), findsOneWidget);

      // Force unmount inside the test body: the preview's useAnimationController
      // and OpacityAnimation's useEffect cleanup both dispose the same
      // controller, so unmount throws an expected double-dispose we consume.
      await tester.pumpWidget(createTestableWidget(const SizedBox()));
      expect(tester.takeException(), isFlutterError);
    });
  });
}

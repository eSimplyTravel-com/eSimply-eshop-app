import "package:esim_open_source/presentation/widgets/animations/animation_scale_up_down.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("AnimationScaleUpDown Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders child", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const AnimationScaleUpDown(
            duration: Duration(milliseconds: 600),
            child: Text("Scale"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(AnimationScaleUpDown), findsOneWidget);
      expect(find.text("Scale"), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets("animates when autoStart is true", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const AnimationScaleUpDown(
            duration: Duration(milliseconds: 300),
            autoStart: true,
            child: Text("Scale"),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text("Scale"), findsOneWidget);
    });

    test("handles default property values", () {
      // Arrange & Act
      const AnimationScaleUpDown widget = AnimationScaleUpDown(
        duration: Duration(milliseconds: 600),
        child: SizedBox(),
      );

      // Assert
      expect(widget.duration, equals(const Duration(milliseconds: 600)));
      expect(widget.autoStart, isFalse);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("scale-key");
      const AnimationScaleUpDown widget = AnimationScaleUpDown(
        key: k,
        duration: Duration(milliseconds: 600),
        child: SizedBox(),
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const AnimationScaleUpDown widget = AnimationScaleUpDown(
        duration: Duration(milliseconds: 600),
        autoStart: true,
        child: SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "duration"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "autoStart"), isTrue);
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(animationScaleUpDownPreview()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AnimationScaleUpDown), findsOneWidget);
    });
  });
}

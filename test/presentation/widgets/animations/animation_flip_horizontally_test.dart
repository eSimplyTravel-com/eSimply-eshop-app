import "package:esim_open_source/presentation/widgets/animations/animation_flip_horizontally.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("AnimationFlipHorizontally Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders front side by default", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const AnimationFlipHorizontally(
            front: Text("Front"),
            back: Text("Back"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(AnimationFlipHorizontally), findsOneWidget);
      expect(find.text("Front"), findsOneWidget);
    });

    testWidgets("renders back side when showFrontSide is false",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const AnimationFlipHorizontally(
            showFrontSide: false,
            front: Text("Front"),
            back: Text("Back"),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));

      // Assert
      expect(find.text("Back"), findsOneWidget);
    });

    testWidgets("invokes widgetPressed when tapped",
        (WidgetTester tester) async {
      // Arrange
      bool pressed = false;
      await tester.pumpWidget(
        createTestableWidget(
          AnimationFlipHorizontally(
            widgetPressed: () => pressed = true,
            front: const Text("Front"),
            back: const Text("Back"),
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.text("Front"));
      await tester.pump();

      // Assert
      expect(pressed, isTrue);
    });

    testWidgets("renders with flipXAxis false (Y rotation)",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const AnimationFlipHorizontally(
            flipXAxis: false,
            front: Text("Front"),
            back: Text("Back"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(AnimationFlipHorizontally), findsOneWidget);
    });

    test("handles default property values", () {
      // Arrange & Act
      const AnimationFlipHorizontally widget = AnimationFlipHorizontally(
        front: SizedBox(),
        back: SizedBox(),
      );

      // Assert
      expect(widget.flipXAxis, isTrue);
      expect(widget.showFrontSide, isTrue);
      expect(widget.widgetPressed, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("flip-key");
      const AnimationFlipHorizontally widget = AnimationFlipHorizontally(
        key: k,
        front: SizedBox(),
        back: SizedBox(),
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const AnimationFlipHorizontally widget = AnimationFlipHorizontally(
        front: SizedBox(),
        back: SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "flipXAxis",
        "showFrontSide",
        "widgetPressed",
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
      await tester.pumpWidget(
        createTestableWidget(animationFlipHorizontallyPreview()),
      );
      await tester.pump();

      // Assert
      expect(find.byType(AnimationFlipHorizontally), findsOneWidget);
    });
  });
}

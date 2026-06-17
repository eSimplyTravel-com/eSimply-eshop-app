import "package:esim_open_source/presentation/widgets/animations/animation_flip_vertically.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("AnimationFlipVertically Widget Tests", () {
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
          const AnimationFlipVertically(
            duration: Duration(milliseconds: 800),
            startAfter: 300,
            child: Text("Flip"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(AnimationFlipVertically), findsOneWidget);
      expect(find.text("Flip"), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets("animates when autoStart is true", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const AnimationFlipVertically(
            duration: Duration(milliseconds: 400),
            startAfter: 50,
            autoStart: true,
            child: Text("Flip"),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text("Flip"), findsOneWidget);
    });

    test("handles default property values", () {
      // Arrange & Act
      const AnimationFlipVertically widget = AnimationFlipVertically(
        duration: Duration(milliseconds: 500),
        startAfter: 100,
        child: SizedBox(),
      );

      // Assert
      expect(widget.duration, equals(const Duration(milliseconds: 500)));
      expect(widget.startAfter, equals(100));
      expect(widget.autoStart, isFalse);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("flipv-key");
      const AnimationFlipVertically widget = AnimationFlipVertically(
        key: k,
        duration: Duration(milliseconds: 500),
        startAfter: 100,
        child: SizedBox(),
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const AnimationFlipVertically widget = AnimationFlipVertically(
        duration: Duration(milliseconds: 500),
        startAfter: 100,
        autoStart: true,
        child: SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "duration",
        "autoStart",
        "startAfter",
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
        createTestableWidget(animationFlipVerticallyPreview()),
      );
      await tester.pump(); // first frame schedules post-frame callback
      await tester.pump(); // post-frame fires, schedules delayed start (300ms)
      await tester
          .pump(const Duration(milliseconds: 350)); // fire delayed start
      await tester.pump(const Duration(milliseconds: 800)); // run animation
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AnimationFlipVertically), findsOneWidget);
    });
  });
}

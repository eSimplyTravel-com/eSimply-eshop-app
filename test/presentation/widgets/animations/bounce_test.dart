import "package:esim_open_source/presentation/widgets/animations/bounce.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("Bounce Widget Tests", () {
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
          Bounce(
            duration: const Duration(milliseconds: 150),
            onPressed: () {},
            child: const Text("Tap me"),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(Bounce), findsOneWidget);
      expect(find.text("Tap me"), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets("invokes onPressed after tap and duration",
        (WidgetTester tester) async {
      // Arrange
      bool pressed = false;
      await tester.pumpWidget(
        createTestableWidget(
          Bounce(
            duration: const Duration(milliseconds: 100),
            onPressed: () => pressed = true,
            child: const Text("Tap"),
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.text("Tap"));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Assert
      expect(pressed, isTrue);
    });

    test("handles property values", () {
      // Arrange & Act
      const Duration d = Duration(milliseconds: 200);
      final Bounce widget = Bounce(
        duration: d,
        onPressed: () {},
        child: const SizedBox(),
      );

      // Assert
      expect(widget.duration, equals(d));
      expect(widget.onPressed, isNotNull);
      expect(widget.child, isA<SizedBox>());
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("bounce-key");
      final Bounce widget = Bounce(
        key: k,
        duration: const Duration(milliseconds: 100),
        onPressed: () {},
        child: const SizedBox(),
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage (widget)", () {
      // Arrange & Act
      final Bounce widget = Bounce(
        duration: const Duration(milliseconds: 100),
        onPressed: () {},
        child: const SizedBox(),
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "onPressed"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "duration"), isTrue);
    });

    testWidgets("state debug properties coverage", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          Bounce(
            duration: const Duration(milliseconds: 100),
            onPressed: () {},
            child: const Text("S"),
          ),
        ),
      );
      await tester.pump();

      // Act
      final BounceState state = tester.state<BounceState>(find.byType(Bounce));
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      state.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "onPressed"), isTrue);
      expect(
        props.any((DiagnosticsNode p) => p.name == "userDuration"),
        isTrue,
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestableWidget(bouncePreview()));
      await tester.pump();

      // Assert
      expect(find.byType(Bounce), findsOneWidget);
    });
  });
}

import "package:esim_open_source/presentation/widgets/my_card_wrap.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("MyCardWrap Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders child without onTap", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: MyCardWrap(child: Text("Plain")),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(MyCardWrap), findsOneWidget);
      expect(find.text("Plain"), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets("renders GestureDetector when onTap set and ripple disabled",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyCardWrap(
              onTap: () {},
              child: const Text("Tappable"),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets("renders InkWell when ripple enabled",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyCardWrap(
              enableRipple: true,
              onTap: () {},
              child: const Text("Ripple"),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets("invokes onTap via GestureDetector (no delay)",
        (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyCardWrap(
              onTap: () => tapped = true,
              child: const Text("Tap"),
            ),
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.text("Tap"));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets("invokes onTap via InkWell with delay",
        (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyCardWrap(
              enableRipple: true,
              withDelay: true,
              onTap: () => tapped = true,
              child: const Text("Tap"),
            ),
          ),
        ),
      );

      // Act
      await tester.pump();
      await tester.tap(find.text("Tap"));
      await tester.pump(const Duration(milliseconds: 400));

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets("renders without border when enableBorder is false",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: MyCardWrap(
              enableBorder: false,
              child: Text("No border"),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(MyCardWrap), findsOneWidget);
    });

    test("handles default property values", () {
      // Arrange & Act
      const MyCardWrap widget = MyCardWrap();

      // Assert
      expect(widget.borderRadius, equals(8));
      expect(widget.enableBorder, isTrue);
      expect(widget.enableRipple, isFalse);
      expect(widget.withDelay, isFalse);
      expect(widget.padding, equals(EdgeInsets.zero));
      expect(widget.margin, equals(EdgeInsets.zero));
      expect(widget.onTap, isNull);
    });

    test("handles custom property values", () {
      // Arrange & Act
      final MyCardWrap widget = MyCardWrap(
        width: 100,
        height: 200,
        borderRadius: 12,
        color: Colors.red,
        onTap: () {},
      );

      // Assert
      expect(widget.width, equals(100));
      expect(widget.height, equals(200));
      expect(widget.borderRadius, equals(12));
      expect(widget.color, equals(Colors.red));
      expect(widget.onTap, isNotNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("card-key");
      const MyCardWrap widget = MyCardWrap(key: k);

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final MyCardWrap widget = MyCardWrap(
        width: 50,
        height: 60,
        color: Colors.blue,
        onTap: () {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      for (final String name in <String>[
        "width",
        "height",
        "borderRadius",
        "enableBorder",
        "color",
        "enableRipple",
        "padding",
        "margin",
        "withDelay",
        "onTap",
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
      await tester.pumpWidget(createTestableWidget(myCardWrapPreview()));
      await tester.pump();

      // Assert
      expect(find.byType(MyCardWrap), findsOneWidget);
    });
  });
}

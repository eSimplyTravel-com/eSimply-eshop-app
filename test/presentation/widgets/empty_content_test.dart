import "package:esim_open_source/presentation/widgets/empty_content.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("EmptyContentUI Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders title and description", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: EmptyContentUI(
              title: "Empty",
              description: "Nothing here",
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Empty"), findsOneWidget);
      expect(find.text("Nothing here"), findsOneWidget);
    });

    testWidgets("does not render image when imagePath null",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: EmptyContentUI(
              title: "T",
              description: "D",
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(Image), findsNothing);
    });

    testWidgets("renders image when imagePath provided",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: EmptyContentUI(
              title: "T",
              description: "D",
              imagePath: "assets/test.png",
            ),
          ),
        ),
      );
      await tester.pump();
      tester.takeException(); // asset not in test bundle

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets("renders content widget when provided",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: EmptyContentUI(
              title: "T",
              description: "D",
              content: Text("Extra"),
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Extra"), findsOneWidget);
    });

    test("handles property values", () {
      // Arrange & Act
      const EmptyContentUI widget = EmptyContentUI(
        title: "Title",
        description: "Desc",
        imagePath: "assets/x.png",
      );

      // Assert
      expect(widget.title, equals("Title"));
      expect(widget.description, equals("Desc"));
      expect(widget.imagePath, equals("assets/x.png"));
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("empty-key");
      const EmptyContentUI widget = EmptyContentUI(
        key: k,
        title: "T",
        description: "D",
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const EmptyContentUI widget = EmptyContentUI(
        title: "T",
        description: "D",
        imagePath: "assets/x.png",
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      for (final String name in <String>[
        "title",
        "description",
        "imagePath",
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
      await tester.pumpWidget(createTestableWidget(emptyContentUIPreview()));
      await tester.pump();

      // Assert
      expect(find.byType(EmptyContentUI), findsOneWidget);
    });
  });

  group("EmptyCurrentPlansContent / EmptyExpiredPlansContent Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("EmptyCurrentPlansContent renders",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EmptyCurrentPlansContent(onCheckOurPlansClick: () {}),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(EmptyContentUI), findsOneWidget);
    });

    testWidgets("EmptyExpiredPlansContent renders",
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: EmptyExpiredPlansContent(onCheckOurPlansClick: () {}),
          ),
        ),
      );
      await tester.pump();
      tester.takeException();

      // Assert
      expect(find.byType(EmptyContentUI), findsOneWidget);
    });

    test("EmptyCurrentPlansContent debug properties", () {
      // Arrange & Act
      final EmptyCurrentPlansContent widget =
          EmptyCurrentPlansContent(onCheckOurPlansClick: () {});
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      expect(
        builder.properties
            .any((DiagnosticsNode p) => p.name == "onCheckOurPlansClick"),
        isTrue,
      );
    });

    test("EmptyExpiredPlansContent debug properties", () {
      // Arrange & Act
      final EmptyExpiredPlansContent widget =
          EmptyExpiredPlansContent(onCheckOurPlansClick: () {});
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      expect(
        builder.properties
            .any((DiagnosticsNode p) => p.name == "onCheckOurPlansClick"),
        isTrue,
      );
    });
  });
}

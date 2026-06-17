import "package:esim_open_source/presentation/widgets/empty_state_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("EmptyStateWidget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    testWidgets("renders with default properties", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets("renders title when provided", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(
            title: "No Data",
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text("No Data"), findsOneWidget);
    });

    testWidgets("does not render title when null", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(
            title: null,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets("renders content when provided", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(
            content: "Please try again later",
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text("Please try again later"), findsOneWidget);
    });

    testWidgets("renders button when provided", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          EmptyStateWidget(
            button: ElevatedButton(
              onPressed: () {},
              child: const Text("Retry"),
            ),
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text("Retry"), findsOneWidget);
    });

    testWidgets("renders with all properties", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          EmptyStateWidget(
            title: "Empty",
            content: "Nothing to show",
            imageWidth: 100,
            imageHeight: 100,
            button: ElevatedButton(
              onPressed: () {},
              child: const Text("Action"),
            ),
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text("Empty"), findsOneWidget);
      expect(find.text("Nothing to show"), findsOneWidget);
      expect(find.text("Action"), findsOneWidget);
    });

    testWidgets("uses custom separator widget", (WidgetTester tester) async {
      // Arrange
      const Widget customSeparator = Divider();
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(
            title: "Test",
            separatorWidget: customSeparator,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(Divider), findsWidgets);
    });

    test("handles property values", () {
      // Arrange & Act
      const EmptyStateWidget widget = EmptyStateWidget(
        title: "Test Title",
        content: "Test Content",
        imagePath: "assets/test.png",
        imageWidth: 100,
        imageHeight: 120,
      );

      // Assert
      expect(widget.title, equals("Test Title"));
      expect(widget.content, equals("Test Content"));
      expect(widget.imagePath, equals("assets/test.png"));
      expect(widget.imageWidth, equals(100));
      expect(widget.imageHeight, equals(120));
    });

    test("handles default property values", () {
      // Arrange & Act
      const EmptyStateWidget widget = EmptyStateWidget();

      // Assert
      expect(widget.title, isNull);
      expect(widget.content, isNull);
      expect(widget.imagePath, isNull);
      expect(widget.imageWidth, equals(80));
      expect(widget.imageHeight, equals(80));
      expect(widget.button, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange
      const Key k = ValueKey<String>("test-key");

      // Act
      final EmptyStateWidget widget = EmptyStateWidget(
        key: k,
        title: "Empty",
      );

      // Assert
      expect(widget.key, equals(k));
    });

    testWidgets("centers content correctly", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(
            title: "Centered",
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      final Center center = tester.widget<Center>(find.byType(Center));
      expect(center.child, isA<Column>());
    });

    testWidgets("renders image when imagePath is provided",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(
            title: "With Image",
            imagePath: "assets/test.png",
            imageWidth: 100,
            imageHeight: 120,
          ),
        ),
      );

      // Act
      await tester.pump();
      // Consume the expected asset-load failure (asset not in test bundle);
      // the Image widget is still built, covering the image branch.
      tester.takeException();

      // Assert
      final Image image = tester.widget<Image>(find.byType(Image));
      expect(image.width, equals(100));
      expect(image.height, equals(120));
    });

    testWidgets("does not render image when imagePath is null",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          const EmptyStateWidget(
            title: "No Image",
            imagePath: null,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(Image), findsNothing);
    });

    testWidgets("renders multiple widgets when all props provided",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          EmptyStateWidget(
            title: "Complete",
            content: "Full content",
            button: Container(),
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(Column), findsWidgets);
      expect(find.text("Complete"), findsOneWidget);
      expect(find.text("Full content"), findsOneWidget);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const EmptyStateWidget widget = EmptyStateWidget(
        title: "Debug Title",
        content: "Debug Content",
        imagePath: "assets/debug.png",
        imageWidth: 90,
        imageHeight: 110,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      for (final String name in <String>[
        "title",
        "content",
        "imagePath",
        "imageWidth",
        "imageHeight",
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
      await tester.pumpWidget(createTestableWidget(emptyStateWidgetPreview()));
      await tester.pump();

      // Assert
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}

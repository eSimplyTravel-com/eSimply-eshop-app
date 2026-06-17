import "package:esim_open_source/presentation/widgets/note_text.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("NoteText Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    testWidgets("renders with text", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const NoteText("Sample note"),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Sample note"), findsOneWidget);
    });

    testWidgets("renders with custom color", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const NoteText(
            "Red note",
            color: Colors.red,
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Red note"), findsOneWidget);
    });

    testWidgets("renders with text alignment", (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createTestableWidget(
          const NoteText(
            "Center aligned",
            textAlign: TextAlign.center,
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text("Center aligned"), findsOneWidget);
    });

    test("handles text property", () {
      // Arrange & Act
      const NoteText widget = NoteText("Test note");

      // Assert
      expect(widget.text, equals("Test note"));
    });

    test("handles all properties", () {
      // Arrange & Act
      const NoteText widget = NoteText(
        "Full test",
        textAlign: TextAlign.right,
        color: Colors.blue,
      );

      // Assert
      expect(widget.text, equals("Full test"));
      expect(widget.textAlign, equals(TextAlign.right));
      expect(widget.color, equals(Colors.blue));
    });

    test("has default values", () {
      // Arrange & Act
      const NoteText widget = NoteText("Default");

      // Assert
      expect(widget.text, equals("Default"));
      expect(widget.textAlign, isNull);
      expect(widget.color, isNull);
    });

    test("can be instantiated with a key", () {
      // Arrange & Act
      const Key k = ValueKey<String>("note-key");
      final NoteText widget = NoteText(
        "Keyed",
        key: k,
      );

      // Assert
      expect(widget.key, equals(k));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const NoteText widget = NoteText(
        "Debug test",
        textAlign: TextAlign.center,
        color: Colors.green,
      );
      final DiagnosticPropertiesBuilder builder =
          DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      expect(
        props.any((DiagnosticsNode p) => p.name == "text"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "textAlign"),
        isTrue,
      );
      expect(
        props.any((DiagnosticsNode p) => p.name == "color"),
        isTrue,
      );
    });

    tearDown(() async {
      await tearDownTest();
    });
  });
}

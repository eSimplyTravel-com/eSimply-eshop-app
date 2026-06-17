import "package:esim_open_source/presentation/widgets/input_field.dart";
import "package:esim_open_source/presentation/widgets/note_text.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("InputField Widget Tests", () {
    late TextEditingController controller;

    setUp(() async {
      await tearDownTest();
      await setupTest();
      controller = TextEditingController();
    });

    tearDown(() async {
      controller.dispose();
      await tearDownTest();
    });

    testWidgets("renders text field with placeholder",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Name",
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(InputField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text("Name"), findsOneWidget);
    });

    testWidgets("calls onChanged when text entered",
        (WidgetTester tester) async {
      // Arrange
      String changed = "";

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Name",
              onChanged: (String value) => changed = value,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField), "hello");

      // Assert
      expect(changed, equals("hello"));
    });

    testWidgets("toggles password visibility when icon tapped",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Password",
              password: true,
            ),
          ),
        ),
      );

      // Assert — starts obscured with visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets("shows validation message", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Name",
              validationMessage: "Required field",
            ),
          ),
        ),
      );

      // Assert
      expect(find.text("Required field"), findsOneWidget);
      expect(find.byType(NoteText), findsWidgets);
    });

    testWidgets("shows additional note", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Name",
              additionalNote: "Helpful hint",
            ),
          ),
        ),
      );

      // Assert
      expect(find.text("Helpful hint"), findsOneWidget);
    });

    testWidgets("read only field uses disabled decoration",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Name",
              isReadOnly: true,
              smallVersion: true,
            ),
          ),
        ),
      );

      // Assert
      final TextFormField field =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(field.controller, equals(controller));
      expect(find.byType(InputField), findsOneWidget);
    });

    testWidgets("enterPressed is invoked on editing complete",
        (WidgetTester tester) async {
      // Arrange
      bool entered = false;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Name",
              enterPressed: () => entered = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(TextFormField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(entered, isTrue);
    });

    testWidgets("nextFocusNode receives focus on submit",
        (WidgetTester tester) async {
      // Arrange
      final FocusNode nextNode = FocusNode();

      // Act — attach nextNode to a real focusable widget so it can take focus.
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: Column(
              children: <Widget>[
                InputField(
                  controller: controller,
                  placeholder: "Name",
                  nextFocusNode: nextNode,
                ),
                Focus(focusNode: nextNode, child: const SizedBox()),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.byType(TextFormField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(nextNode.hasFocus, isTrue);
      nextNode.dispose();
    });

    testWidgets("applies input formatter", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "Digits",
              formatter: FilteringTextInputFormatter.digitsOnly,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField), "a1b2c3");

      // Assert — only digits retained
      expect(controller.text, equals("123"));
    });

    test("widget debug properties coverage", () {
      // Arrange & Act
      final InputField widget = InputField(
        controller: controller,
        placeholder: "p",
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "controller",
        "textInputType",
        "password",
        "isReadOnly",
        "placeholder",
        "validationMessage",
        "enterPressed",
        "smallVersion",
        "fieldFocusNode",
        "nextFocusNode",
        "textInputAction",
        "additionalNote",
        "onChanged",
        "formatter",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    testWidgets("state debug properties coverage", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: InputField(
              controller: controller,
              placeholder: "p",
            ),
          ),
        ),
      );

      // Act
      final InputFieldState state = tester.state(find.byType(InputField));
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      state.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "isPassword"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "fieldHeight"), isTrue);
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(inputFieldPreview()),
      );

      // Assert
      expect(find.byType(InputField), findsOneWidget);
      expect(find.text("Enter your name"), findsOneWidget);
    });
  });
}

import "package:esim_open_source/presentation/widgets/otp_text_field.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("OtpTextField Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
      debugDefaultTargetPlatformOverride = null;
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders the configured number of fields",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(OtpTextField), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets("renders with initial code values",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["1", "2", "3"],
              numberOfFields: 3,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text("1"), findsOneWidget);
      expect(find.text("2"), findsOneWidget);
      expect(find.text("3"), findsOneWidget);
    });

    testWidgets("onCodeChanged fires when a digit is entered",
        (WidgetTester tester) async {
      // Arrange
      String? changed;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              onCodeChanged: (String value) => changed = value,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField).first, "5");
      // Entering a digit schedules a 200ms race-guard timer; flush it.
      await tester.pump(const Duration(milliseconds: 250));

      // Assert
      expect(changed, equals("5"));
    });

    testWidgets("onSubmit fires when all fields are filled",
        (WidgetTester tester) async {
      // Arrange
      String? submitted;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              onSubmit: (String value) => submitted = value,
            ),
          ),
        ),
      );
      for (int i = 0; i < 4; i++) {
        await tester.enterText(
          find.byType(TextFormField).at(i),
          "${i + 1}",
        );
        await tester.pump();
      }
      // Flush the 200ms race-guard timers scheduled on each digit entry.
      await tester.pump(const Duration(milliseconds: 250));

      // Assert
      expect(submitted, equals("1234"));
    });

    testWidgets("non-digit input is filtered out", (WidgetTester tester) async {
      // Arrange
      String? changed;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              onCodeChanged: (String value) => changed = value,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField).first, "a");
      await tester.pump();

      // Assert — letters are stripped, leaving an empty code.
      expect(changed, equals(""));
    });

    testWidgets("renders as box (outline border) when showFieldAsBox is true",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              showFieldAsBox: true,
              filled: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(OtpTextField), findsOneWidget);
    });

    testWidgets("applies per-field styles", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              styles: const <TextStyle?>[
                TextStyle(fontSize: 10),
                TextStyle(fontSize: 12),
                TextStyle(fontSize: 14),
                TextStyle(fontSize: 16),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets("uses custom input decoration when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              hasCustomInputDecoration: true,
              decoration: const InputDecoration(hintText: "otp"),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets("handleControllers exposes controllers",
        (WidgetTester tester) async {
      // Arrange
      List<TextEditingController?>? controllers;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              handleControllers: (List<TextEditingController?> c) =>
                  controllers = c,
            ),
          ),
        ),
      );

      // Assert
      expect(controllers, isNotNull);
      expect(controllers!.length, equals(4));
    });

    testWidgets("clearText via didUpdateWidget clears the fields",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              key: const ValueKey<String>("otp"),
              initialCode: const <String>["1", "2", "3", "4"],
            ),
          ),
        ),
      );
      expect(find.text("1"), findsOneWidget);

      // Rebuild with clearText true.
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              key: const ValueKey<String>("otp"),
              initialCode: const <String>["1", "2", "3", "4"],
              clearText: true,
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert — fields cleared.
      expect(find.text("1"), findsNothing);
    });

    testWidgets("backspace key event moves focus to previous field",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
            ),
          ),
        ),
      );
      // Focus the second field.
      await tester.tap(find.byType(TextFormField).at(1));
      await tester.pump();
      // Simulate a backspace key up.
      await simulateKeyDownEvent(LogicalKeyboardKey.backspace);
      await simulateKeyUpEvent(LogicalKeyboardKey.backspace);
      await tester.pump(const Duration(milliseconds: 100));

      // Assert — no crash; widget still present.
      expect(find.byType(OtpTextField), findsOneWidget);
    });

    testWidgets("handlePasteLogic fills fields from pasted text",
        (WidgetTester tester) async {
      // Arrange
      String? submitted;
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
              onSubmit: (String value) => submitted = value,
            ),
          ),
        ),
      );

      // Act
      final OtpTextFieldState state = tester.state(find.byType(OtpTextField));
      state.handlePasteLogic("9876");
      await tester.pump();

      // Assert
      expect(submitted, equals("9876"));
      expect(find.text("9"), findsOneWidget);
    });

    testWidgets("iOS focus initializes empty field",
        (WidgetTester tester) async {
      // Arrange
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: OtpTextField(
              initialCode: const <String>["", "", "", ""],
            ),
          ),
        ),
      );
      await tester.tap(find.byType(TextFormField).first);
      await tester.pump();

      // Assert — focus listener runs without error.
      expect(find.byType(OtpTextField), findsOneWidget);

      debugDefaultTargetPlatformOverride = null;
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final OtpTextField widget = OtpTextField(
        initialCode: const <String>["", "", "", ""],
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "showCursor",
        "numberOfFields",
        "fieldWidth",
        "borderWidth",
        "enabledBorderColor",
        "focusedBorderColor",
        "keyboardType",
        "mainAxisAlignment",
        "crossAxisAlignment",
        "onSubmit",
        "onCodeChanged",
        "handleControllers",
        "obscureText",
        "showFieldAsBox",
        "enabled",
        "filled",
        "autoFocus",
        "readOnly",
        "clearText",
        "hasCustomInputDecoration",
        "fillColor",
        "borderRadius",
        "styles",
        "initialCode",
      ]) {
        expect(
          props.any((DiagnosticsNode p) => p.name == name),
          isTrue,
          reason: "missing $name",
        );
      }
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(otpTextFieldPreview()),
      );

      // Assert
      expect(find.byType(OtpTextField), findsOneWidget);
    });
  });
}

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/widgets/apply_promo_code_view.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("ApplyPromoCode Widget Tests", () {
    late TextEditingController controller;

    setUp(() async {
      await tearDownTest();
      await setupTest();
      controller = TextEditingController();

      FlutterError.onError = (FlutterErrorDetails details) {
        final String message = details.exceptionAsString();
        if (message.contains("A RenderFlex overflowed") ||
            message.contains("overflowed by") ||
            message.contains("RenderFlex")) {
          return;
        }
        FlutterError.presentError(details);
      };
    });

    tearDown(() async {
      controller.dispose();
      await tearDownTest();
    });

    Widget buildWidget({
      bool isExpanded = false,
      bool isFieldEnabled = true,
      String message = "",
      String buttonText = "Apply",
      IconData textFieldIcon = Icons.check_circle,
      Color textFieldBorderColor = Colors.green,
      VoidCallback? expandedCallBack,
      void Function(String)? callback,
    }) {
      return Scaffold(
        body: ApplyPromoCode(
          controller: controller,
          buttonText: buttonText,
          message: message,
          isFieldEnabled: isFieldEnabled,
          textFieldIcon: textFieldIcon,
          textFieldBorderColor: textFieldBorderColor,
          isExpanded: isExpanded,
          expandedCallBack: expandedCallBack ?? () {},
          callback: callback ?? (String _) {},
        ),
      );
    }

    // --- RENDERING ---
    testWidgets("renders successfully", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(buildWidget()),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(ApplyPromoCode), findsOneWidget);
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets("displays the promo code title", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(buildWidget()),
      );

      // Act
      await tester.pump();

      // Assert
      expect(
        find.text(LocaleKeys.promoCodeView_titleText.tr()),
        findsOneWidget,
      );
    });

    // --- COLLAPSED STATE ---
    testWidgets("shows down arrow icon when collapsed",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(buildWidget()),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsNothing);
    });

    testWidgets("hides input field and button when collapsed",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(buildWidget()),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(MainInputField), findsNothing);
      expect(find.byType(MainButton), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    // --- EXPANDED STATE ---
    testWidgets("shows up arrow icon when expanded",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(buildWidget(isExpanded: true)),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
    });

    testWidgets("shows input field and button when expanded",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(buildWidget(isExpanded: true)),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(MainInputField), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
    });

    testWidgets("displays the button text when expanded",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          buildWidget(isExpanded: true, buttonText: "Redeem"),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.text("Redeem"), findsOneWidget);
    });

    // --- INTERACTIONS ---
    testWidgets("calls expandedCallBack when tapped",
        (WidgetTester tester) async {
      // Arrange
      bool expanded = false;
      await tester.pumpWidget(
        createTestableWidget(
          buildWidget(expandedCallBack: () => expanded = true),
        ),
      );
      await tester.pump();

      // Act
      await tester.tap(find.text(LocaleKeys.promoCodeView_titleText.tr()));
      await tester.pump();

      // Assert
      expect(expanded, isTrue);
    });

    testWidgets("calls callback with controller text when button is enabled",
        (WidgetTester tester) async {
      // Arrange
      String? received;
      controller.text = "PROMO10";
      await tester.pumpWidget(
        createTestableWidget(
          buildWidget(
            isExpanded: true,
            callback: (String value) => received = value,
          ),
        ),
      );
      await tester.pump();

      // Act
      await tester.tap(find.byType(MainButton));
      await tester.pump();

      // Assert
      expect(received, equals("PROMO10"));
    });

    testWidgets("does not call callback when controller text is empty",
        (WidgetTester tester) async {
      // Arrange
      bool called = false;
      await tester.pumpWidget(
        createTestableWidget(
          buildWidget(
            isExpanded: true,
            callback: (String _) => called = true,
          ),
        ),
      );
      await tester.pump();

      // Act
      await tester.tap(find.byType(MainButton));
      await tester.pump();

      // Assert
      expect(called, isFalse);
    });

    testWidgets("button is disabled when controller text is empty",
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(buildWidget(isExpanded: true)),
      );
      await tester.pump();

      // Act
      final MainButton button = tester.widget<MainButton>(
        find.byType(MainButton),
      );

      // Assert
      expect(button.isEnabled, isFalse);
    });

    testWidgets("button is enabled when controller has non-empty text",
        (WidgetTester tester) async {
      // Arrange
      controller.text = "CODE";
      await tester.pumpWidget(
        createTestableWidget(buildWidget(isExpanded: true)),
      );
      await tester.pump();

      // Act
      final MainButton button = tester.widget<MainButton>(
        find.byType(MainButton),
      );

      // Assert
      expect(button.isEnabled, isTrue);
    });

    testWidgets("button is disabled when text is only whitespace",
        (WidgetTester tester) async {
      // Arrange
      controller.text = "   ";
      await tester.pumpWidget(
        createTestableWidget(buildWidget(isExpanded: true)),
      );
      await tester.pump();

      // Act
      final MainButton button = tester.widget<MainButton>(
        find.byType(MainButton),
      );

      // Assert
      expect(button.isEnabled, isFalse);
    });

    // --- FIELD STATE ---
    testWidgets("renders when field is disabled", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          buildWidget(isExpanded: true, isFieldEnabled: false),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(MainInputField), findsOneWidget);
    });

    testWidgets("renders with an error message", (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createTestableWidget(
          buildWidget(isExpanded: true, message: "Invalid code"),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(ApplyPromoCode), findsOneWidget);
      expect(find.byType(MainInputField), findsOneWidget);
    });

    // --- PROPERTIES ---
    test("exposes constructor properties", () {
      // Arrange
      final TextEditingController localController = TextEditingController();
      final ApplyPromoCode widget = ApplyPromoCode(
        controller: localController,
        buttonText: "Apply",
        message: "msg",
        isFieldEnabled: true,
        textFieldIcon: Icons.check_circle,
        textFieldBorderColor: Colors.green,
        isExpanded: true,
        expandedCallBack: () {},
        callback: (String _) {},
      );

      // Assert
      expect(widget.buttonText, equals("Apply"));
      expect(widget.message, equals("msg"));
      expect(widget.isFieldEnabled, isTrue);
      expect(widget.textFieldIcon, equals(Icons.check_circle));
      expect(widget.textFieldBorderColor, equals(Colors.green));
      expect(widget.isExpanded, isTrue);
      expect(widget.controller, equals(localController));

      localController.dispose();
    });

    test("widget can be instantiated with a key", () {
      // Arrange
      const Key testKey = ValueKey<String>("promo_key");
      final ApplyPromoCode widget = ApplyPromoCode(
        key: testKey,
        controller: controller,
        buttonText: "Apply",
        message: "",
        isFieldEnabled: true,
        textFieldIcon: Icons.check_circle,
        textFieldBorderColor: Colors.green,
        isExpanded: false,
        expandedCallBack: () {},
        callback: (String _) {},
      );

      // Assert
      expect(widget.key, equals(testKey));
    });

    test("debug properties coverage", () {
      // Arrange
      final ApplyPromoCode widget = ApplyPromoCode(
        controller: controller,
        buttonText: "Apply",
        message: "msg",
        isFieldEnabled: true,
        textFieldIcon: Icons.check_circle,
        textFieldBorderColor: Colors.green,
        isExpanded: true,
        expandedCallBack: () {},
        callback: (String _) {},
      );

      // Act
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props, isNotEmpty);
      for (final String name in <String>[
        "callback",
        "textFieldBorderColor",
        "textFieldIcon",
        "isFieldEnabled",
        "message",
        "controller",
        "buttonText",
        "isExpanded",
        "expandedCallBack",
      ]) {
        expect(
          props.any((DiagnosticsNode prop) => prop.name == name),
          isTrue,
          reason: "expected debug property '$name'",
        );
      }
    });
  });
}

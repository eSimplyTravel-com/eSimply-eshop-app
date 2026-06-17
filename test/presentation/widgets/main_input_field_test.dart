import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("MainInputField Widget Tests", () {
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

    testWidgets("renders with hint text", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          hintText: "Enter value",
        ),
      )));
      expect(find.byType(MainInputField), findsOneWidget);
      expect(find.text("Enter value"), findsOneWidget);
    });

    testWidgets("shows labelTitleText above the field",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          labelTitleText: "Title label",
        ),
      )));
      expect(find.text("Title label"), findsOneWidget);
    });

    testWidgets("sets initialValue on controller", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          initialValue: "preset",
        ),
      )));
      expect(controller.text, equals("preset"));
    });

    testWidgets("fires onChanged when text entered",
        (WidgetTester tester) async {
      String? changed;
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          onChanged: ({required String text}) => changed = text,
        ),
      )));
      await tester.enterText(find.byType(TextFormField), "hello");
      expect(changed, equals("hello"));
    });

    testWidgets("password field shows toggle icon",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          password: true,
        ),
      )));
      // password=true, isObscure=null → getPasswordToggleIcon() = (null ?? !true) = false → visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      // after toggle: isPassword flipped to false → icon = (null ?? !false) = true → visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets("isObscure externally controlled shows toggle",
        (WidgetTester tester) async {
      bool obscureChanged = false;
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          isObscure: true,
          onObscureChange: ({required bool value}) => obscureChanged = true,
        ),
      )));
      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(obscureChanged, isTrue);
    });

    testWidgets("hideInternalObfuscator hides password toggle",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          password: true,
          hideInternalObfuscator: true,
        ),
      )));
      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets("shows error message and icon", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          errorMessage: "Required",
        ),
      )));
      expect(find.text("Required"), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets("shows custom error icon", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          errorMessage: "Oops",
          errorIcon: Icons.warning,
        ),
      )));
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets("empty errorMessage shows reserved height",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          errorMessage: "",
        ),
      )));
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets("clear button appears when clearSearchEnabled and has text",
        (WidgetTester tester) async {
      controller.text = "existing";
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          clearSearchEnabled: true,
        ),
      )));
      await tester.pump();
      expect(find.byIcon(Icons.clear), findsOneWidget);
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();
      expect(controller.text, isEmpty);
    });

    testWidgets("shows suffixIcon when no special overrides",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          suffixIcon: const Icon(Icons.star, key: Key("suffix")),
        ),
      )));
      expect(find.byKey(const Key("suffix")), findsOneWidget);
    });

    testWidgets("shows prefixIcon", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          prefixIcon: const Icon(Icons.search, key: Key("prefix")),
        ),
      )));
      expect(find.byKey(const Key("prefix")), findsOneWidget);
    });

    testWidgets("enterPressed invoked on editing complete",
        (WidgetTester tester) async {
      bool entered = false;
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          enterPressed: () => entered = true,
        ),
      )));
      await tester.tap(find.byType(TextFormField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(entered, isTrue);
    });

    testWidgets("nextFocusNode receives focus on submit",
        (WidgetTester tester) async {
      final FocusNode nextNode = FocusNode();
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: Column(children: <Widget>[
          MainInputField(
            controller: controller,
            themeColor: Colors.blue,
            nextFocusNode: nextNode,
          ),
          Focus(focusNode: nextNode, child: const SizedBox()),
        ]),
      )));
      await tester.tap(find.byType(TextFormField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(nextNode.hasFocus, isTrue);
      nextNode.dispose();
    });

    testWidgets("applies input formatter", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          formatter: FilteringTextInputFormatter.digitsOnly,
        ),
      )));
      await tester.enterText(find.byType(TextFormField), "a1b2");
      expect(controller.text, equals("12"));
    });

    testWidgets("multiline renders without height constraint",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          maxLines: 4,
        ),
      )));
      expect(find.byType(MainInputField), findsOneWidget);
    });

    testWidgets("onTap invoked when tapped", (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          onTap: () => tapped = true,
        ),
      )));
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      expect(tapped, isTrue);
    });

    group("factory constructors", () {
      testWidgets("securedPassword builds correctly",
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.securedPassword(
            controller: controller,
            themeColor: Colors.blue,
          ),
        )));
        expect(find.byType(MainInputField), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets("text factory builds correctly", (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.text(
            controller: controller,
            themeColor: Colors.blue,
            textConfig:
                const MainInputFieldTextConfig(hintText: "Text factory"),
          ),
        )));
        expect(find.text("Text factory"), findsOneWidget);
      });

      testWidgets("multiline factory builds correctly",
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.multiline(
            controller: controller,
            themeColor: Colors.blue,
          ),
        )));
        expect(find.byType(MainInputField), findsOneWidget);
      });

      testWidgets("formField factory builds correctly",
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.formField(
            controller: controller,
            themeColor: Colors.blue,
            textConfig: const MainInputFieldTextConfig(hintText: "Form"),
          ),
        )));
        expect(find.text("Form"), findsOneWidget);
      });

      testWidgets("promoCode factory builds correctly",
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.promoCode(
            controller: controller,
            themeColor: Colors.blue,
            textConfig: const MainInputFieldTextConfig(hintText: "Promo"),
          ),
        )));
        expect(find.text("Promo"), findsOneWidget);
      });

      testWidgets("searchField factory builds correctly",
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.searchField(
            controller: controller,
            themeColor: Colors.blue,
          ),
        )));
        tester.takeException(); // search icon asset
        expect(find.byType(MainInputField), findsOneWidget);
      });

      testWidgets("securedPassword respects behavior/interaction configs",
          (WidgetTester tester) async {
        bool obscureChanged = false;
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.securedPassword(
            controller: controller,
            themeColor: Colors.blue,
            behaviorConfig: const MainInputFieldBehaviorConfig(
              isObscure: true,
              hideInternalObfuscator: false,
            ),
            interactionConfig: MainInputFieldInteractionConfig(
              onObscureChange: ({required bool value}) => obscureChanged = true,
            ),
          ),
        )));
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        expect(obscureChanged, isTrue);
      });

      testWidgets("text factory with full config", (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.text(
            controller: controller,
            themeColor: Colors.blue,
            textConfig: const MainInputFieldTextConfig(
              hintText: "Full config",
              labelText: "Label",
              initialValue: "init",
            ),
            appearanceConfig: const MainInputFieldAppearanceConfig(
              inputTextStyle: TextStyle(fontSize: 14),
            ),
            behaviorConfig:
                const MainInputFieldBehaviorConfig(removeBorder: true),
            inputConfig: const MainInputFieldInputConfig(
              textInputType: TextInputType.emailAddress,
              maxLines: 1,
            ),
            interactionConfig: MainInputFieldInteractionConfig(
              enterPressed: () {},
            ),
          ),
        )));
        expect(find.text("Full config"), findsOneWidget);
        expect(controller.text, equals("init"));
      });

      testWidgets("multiline with full config", (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.multiline(
            controller: controller,
            themeColor: Colors.blue,
            textConfig: const MainInputFieldTextConfig(hintText: "Multi"),
            behaviorConfig: const MainInputFieldBehaviorConfig(
              isReadOnly: true,
              removeBorder: true,
            ),
            inputConfig: const MainInputFieldInputConfig(maxLines: 5),
          ),
        )));
        expect(find.text("Multi"), findsOneWidget);
      });

      testWidgets("formField with appearance config",
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.formField(
            controller: controller,
            themeColor: Colors.blue,
            textConfig: const MainInputFieldTextConfig(
              labelTitleText: "Form title",
              errorMessage: "Error",
            ),
            appearanceConfig: const MainInputFieldAppearanceConfig(
              backgroundColor: Colors.white,
              textFieldHeight: 60,
            ),
            inputConfig: const MainInputFieldInputConfig(
              maxLines: 2,
            ),
          ),
        )));
        expect(find.text("Form title"), findsOneWidget);
        expect(find.text("Error"), findsOneWidget);
      });

      testWidgets("promoCode with error config", (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.promoCode(
            controller: controller,
            themeColor: Colors.blue,
            textConfig: const MainInputFieldTextConfig(
              hintText: "CODE",
              errorMessage: "Invalid",
            ),
            appearanceConfig: const MainInputFieldAppearanceConfig(
              errorColor: Colors.red,
              errorIcon: Icons.error,
            ),
            behaviorConfig:
                const MainInputFieldBehaviorConfig(isReadOnly: true),
          ),
        )));
        expect(find.text("Invalid"), findsOneWidget);
      });

      testWidgets("searchField with clearSearch and onChanged",
          (WidgetTester tester) async {
        String? changed;
        controller.text = "search";
        await tester.pumpWidget(createTestableWidget(Scaffold(
          body: MainInputField.searchField(
            controller: controller,
            themeColor: Colors.blue,
            textConfig: const MainInputFieldTextConfig(hintText: "Search"),
            behaviorConfig:
                const MainInputFieldBehaviorConfig(clearSearchEnabled: true),
            interactionConfig: MainInputFieldInteractionConfig(
              onChanged: ({required String text}) => changed = text,
              onTap: () {},
            ),
          ),
        )));
        tester.takeException();
        await tester.pump();
        expect(find.byIcon(Icons.clear), findsOneWidget);
        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();
        expect(changed, equals(""));
      });
    });

    testWidgets("forceSuffixDirection in LTR shows password toggle as suffix",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
          password: true,
          forceSuffixDirection: true,
          prefixIcon: const Icon(Icons.lock, key: Key("pfx")),
        ),
      )));
      // LTR: getPrefixIcon returns prefixIcon; getSuffixIcon returns
      // forceSuffix path → password toggle
      expect(find.byKey(const Key("pfx")), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets("forceSuffixDirection in RTL swaps prefix/suffix",
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: MainInputField(
              controller: controller,
              themeColor: Colors.blue,
              password: true,
              forceSuffixDirection: true,
              prefixIcon: const Icon(Icons.lock, key: Key("pfx_rtl")),
            ),
          ),
        ),
      ));
      // RTL: getPrefixIcon returns toggle; getSuffixIcon returns prefixIcon
      expect(find.byType(IconButton), findsWidgets);
    });

    group("config data classes", () {
      test("MainInputFieldTextConfig holds values", () {
        const MainInputFieldTextConfig c = MainInputFieldTextConfig(
          hintText: "h",
          labelText: "l",
          labelTitleText: "lt",
          initialValue: "iv",
          errorMessage: "err",
        );
        expect(c.hintText, equals("h"));
        expect(c.errorMessage, equals("err"));
      });

      test("MainInputFieldAppearanceConfig holds values", () {
        const MainInputFieldAppearanceConfig c = MainInputFieldAppearanceConfig(
          backgroundColor: Colors.red,
          textFieldHeight: 60,
          errorColor: Colors.orange,
          errorIcon: Icons.warning,
        );
        expect(c.backgroundColor, equals(Colors.red));
        expect(c.textFieldHeight, equals(60));
      });

      test("MainInputFieldBehaviorConfig holds values", () {
        const MainInputFieldBehaviorConfig c = MainInputFieldBehaviorConfig(
          isReadOnly: true,
          autofocus: true,
          isObscure: false,
          hideInternalObfuscator: true,
          removeBorder: true,
          clearSearchEnabled: true,
        );
        expect(c.isReadOnly, isTrue);
        expect(c.clearSearchEnabled, isTrue);
      });

      test("MainInputFieldInputConfig holds values", () {
        final MainInputFieldInputConfig c = MainInputFieldInputConfig(
          textInputType: TextInputType.emailAddress,
          formatter: FilteringTextInputFormatter.digitsOnly,
          autofillHints: const <String>["email"],
          textAlign: TextAlign.center,
          maxLines: 3,
        );
        expect(c.maxLines, equals(3));
        expect(c.textInputType, equals(TextInputType.emailAddress));
      });

      test("MainInputFieldInteractionConfig holds values", () {
        bool tapped = false;
        final MainInputFieldInteractionConfig c =
            MainInputFieldInteractionConfig(
          onTap: () => tapped = true,
          enterPressed: () {},
          onChanged: ({required String text}) {},
          onObscureChange: ({required bool value}) {},
        );
        c.onTap?.call();
        expect(tapped, isTrue);
      });
    });

    test("widget debug properties coverage", () {
      final MainInputField widget = MainInputField(
        controller: controller,
        themeColor: Colors.blue,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "controller",
        "password",
        "isReadOnly",
        "themeColor",
        "hintText",
        "clearSearchEnabled",
      ]) {
        expect(props.any((DiagnosticsNode p) => p.name == name), isTrue,
            reason: "missing $name");
      }
    });

    testWidgets("state debug properties coverage", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(Scaffold(
        body: MainInputField(
          controller: controller,
          themeColor: Colors.blue,
        ),
      )));
      final State<MainInputField> state =
          tester.state(find.byType(MainInputField));
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      state.debugFillProperties(builder);
      expect(
        builder.properties.any((DiagnosticsNode p) => p.name == "isPassword"),
        isTrue,
      );
      expect(
        builder.properties.any((DiagnosticsNode p) => p.name == "hasText"),
        isTrue,
      );
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(mainInputFieldPreview()));
      tester.takeException();
      expect(find.byType(MainInputField), findsOneWidget);
    });
  });
}

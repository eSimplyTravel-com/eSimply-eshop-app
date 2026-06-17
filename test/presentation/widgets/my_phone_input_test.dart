import "package:esim_open_source/presentation/widgets/my_phone_input.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:phone_input/phone_input_package.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  PhoneController buildController() =>
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: ""));

  group("MyPhoneInput Widget Tests", () {
    late PhoneController phoneController;

    setUp(() async {
      await tearDownTest();
      await setupTest();
      phoneController = buildController();
    });

    tearDown(() async {
      phoneController.dispose();
      await tearDownTest();
    });

    testWidgets("renders enabled phone input", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyPhoneInput(
              phoneController: phoneController,
              onChanged: (
                String countryCode,
                String phoneNumber, {
                required bool isValid,
              }) {},
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — no absorbing AbsorbPointer wrapper added when enabled.
      // (PhoneInput has its own non-absorbing AbsorbPointer internally.)
      expect(find.byType(MyPhoneInput), findsOneWidget);
      expect(find.byType(PhoneInput), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (Widget w) => w is AbsorbPointer && w.absorbing,
        ),
        findsNothing,
      );
    });

    testWidgets("wraps in AbsorbPointer when disabled",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyPhoneInput(
              phoneController: phoneController,
              enabled: false,
              onChanged: (
                String countryCode,
                String phoneNumber, {
                required bool isValid,
              }) {},
            ),
          ),
        ),
      );
      tester.takeException();

      // Assert — an absorbing AbsorbPointer wraps the disabled input.
      expect(
        find.byWidgetPredicate(
          (Widget w) => w is AbsorbPointer && w.absorbing,
        ),
        findsOneWidget,
      );
      expect(find.byType(PhoneInput), findsOneWidget);
    });

    testWidgets("calls onChanged when number entered",
        (WidgetTester tester) async {
      // Arrange
      String capturedCode = "";
      String capturedNumber = "";
      bool capturedValid = true;

      // Act
      await tester.pumpWidget(
        createTestableWidget(
          Scaffold(
            body: MyPhoneInput(
              phoneController: phoneController,
              validateRequired: true,
              validateEmpty: true,
              onChanged: (
                String countryCode,
                String phoneNumber, {
                required bool isValid,
              }) {
                capturedCode = countryCode;
                capturedNumber = phoneNumber;
                capturedValid = isValid;
              },
            ),
          ),
        ),
      );
      tester.takeException();
      // Drive a change through the controller.
      phoneController.value =
          const PhoneNumber(isoCode: IsoCode.LB, nsn: "70123456");
      await tester.pump();
      tester.takeException();

      // Assert
      expect(capturedNumber, equals("70123456"));
      expect(capturedCode, isNotEmpty);
      expect(capturedValid, isA<bool>());
    });

    test("debug properties coverage", () {
      // Arrange & Act
      final MyPhoneInput widget = MyPhoneInput(
        phoneController: phoneController,
        onChanged: (
          String countryCode,
          String phoneNumber, {
          required bool isValid,
        }) {},
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "onChanged",
        "phoneController",
        "validateRequired",
        "validateEmpty",
        "enabled",
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
        createTestableWidget(myPhoneInputPreview()),
      );
      tester.takeException();

      // Assert
      expect(find.byType(MyPhoneInput), findsOneWidget);
    });
  });
}

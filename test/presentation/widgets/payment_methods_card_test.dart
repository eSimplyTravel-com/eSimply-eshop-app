import "package:esim_open_source/presentation/widgets/payment_methods_card.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  group("PaymentMethodCard Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders icon and text", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: PaymentMethodCard(
              backgroundColor: Color(0xFFF5F5F5),
              icon: Icons.credit_card,
              text: "Credit Card",
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(PaymentMethodCard), findsOneWidget);
      expect(find.byIcon(Icons.credit_card), findsOneWidget);
      expect(find.text("Credit Card"), findsOneWidget);
    });

    testWidgets("applies custom textStyle when provided",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: PaymentMethodCard(
              backgroundColor: Color(0xFFF5F5F5),
              icon: Icons.credit_card,
              text: "Styled",
              textStyle: TextStyle(fontSize: 22, color: Color(0xFF112233)),
            ),
          ),
        ),
      );

      // Assert
      final Text textWidget = tester.widget<Text>(find.text("Styled"));
      expect(textWidget.style?.fontSize, equals(22));
    });

    testWidgets("uses custom circle and icon sizes",
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: PaymentMethodCard(
              backgroundColor: Color(0xFFF5F5F5),
              icon: Icons.account_balance_wallet,
              text: "Wallet",
              iconSize: 30,
              circleSize: 50,
              circleColor: Color(0xFF00FF00),
              iconColor: Color(0xFFFF0000),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(PaymentMethodCard), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const PaymentMethodCard widget = PaymentMethodCard(
        backgroundColor: Color(0xFFF5F5F5),
        icon: Icons.credit_card,
        text: "t",
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      for (final String name in <String>[
        "backgroundColor",
        "circleColor",
        "icon",
        "iconColor",
        "text",
        "textStyle",
        "iconSize",
        "circleSize",
        "padding",
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
        createTestableWidget(paymentMethodCardPreview()),
      );

      // Assert
      expect(find.byType(PaymentMethodCard), findsOneWidget);
      expect(find.text("Credit / Debit Card"), findsOneWidget);
    });
  });
}

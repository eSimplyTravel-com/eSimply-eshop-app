import "package:esim_open_source/presentation/widgets/payment_methods_card.dart";
import "package:esim_open_source/presentation/widgets/payment_methods_list.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../../helpers/view_helper.dart";

Future<void> main() async {
  await prepareTest();

  const List<PaymentCardData> sampleItems = <PaymentCardData>[
    PaymentCardData(
      backgroundColor: Color(0xFFF5F5F5),
      icon: Icons.credit_card,
      text: "Card",
    ),
    PaymentCardData(
      backgroundColor: Color(0xFFF5F5F5),
      icon: Icons.account_balance_wallet,
      text: "Wallet",
    ),
  ];

  group("PaymentMethodsList Widget Tests", () {
    setUp(() async {
      await tearDownTest();
      await setupTest();
    });

    tearDown(() async {
      await tearDownTest();
    });

    testWidgets("renders title and all items", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: PaymentMethodsList(
              title: "Payments",
              items: sampleItems,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text("Payments"), findsOneWidget);
      expect(find.byType(PaymentMethodCard), findsNWidgets(2));
      expect(find.text("Card"), findsOneWidget);
      expect(find.text("Wallet"), findsOneWidget);
    });

    testWidgets("renders with empty item list", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: PaymentMethodsList(
              title: "Empty",
              items: <PaymentCardData>[],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text("Empty"), findsOneWidget);
      expect(find.byType(PaymentMethodCard), findsNothing);
    });

    testWidgets("applies custom titleStyle", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(
          const Scaffold(
            body: PaymentMethodsList(
              title: "Styled",
              items: <PaymentCardData>[],
              titleStyle: TextStyle(fontSize: 28),
            ),
          ),
        ),
      );

      // Assert
      final Text titleWidget = tester.widget<Text>(find.text("Styled"));
      expect(titleWidget.style?.fontSize, equals(28));
    });

    test("debug properties coverage", () {
      // Arrange & Act
      const PaymentMethodsList widget = PaymentMethodsList(
        title: "t",
        items: sampleItems,
      );
      final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
      widget.debugFillProperties(builder);

      // Assert
      final List<DiagnosticsNode> props = builder.properties;
      expect(props.any((DiagnosticsNode p) => p.name == "title"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "items"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "titleStyle"), isTrue);
      expect(props.any((DiagnosticsNode p) => p.name == "padding"), isTrue);
    });

    test("PaymentCardData holds provided values", () {
      // Arrange & Act
      const PaymentCardData data = PaymentCardData(
        backgroundColor: Color(0xFF111111),
        icon: Icons.star,
        text: "Data",
        circleColor: Color(0xFF222222),
        iconColor: Color(0xFF333333),
        iconSize: 18,
        circleSize: 36,
      );

      // Assert
      expect(data.text, equals("Data"));
      expect(data.icon, equals(Icons.star));
      expect(data.iconSize, equals(18));
      expect(data.circleSize, equals(36));
    });

    testWidgets("preview renders", (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        createTestableWidget(paymentMethodsListPreview()),
      );

      // Assert
      expect(find.byType(PaymentMethodsList), findsOneWidget);
      expect(find.text("Payment methods"), findsOneWidget);
      expect(find.byType(PaymentMethodCard), findsNWidgets(2));
    });
  });
}

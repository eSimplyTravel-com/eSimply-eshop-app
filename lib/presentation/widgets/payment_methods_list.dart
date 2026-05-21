import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/payment_methods_card.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class PaymentMethodsList extends StatelessWidget {
  const PaymentMethodsList({
    required this.title,
    required this.items,
    this.titleStyle,
    this.padding = const EdgeInsets.only(left: 16, right: 16, bottom: 16),
    super.key,
  });
  final String title;
  final List<PaymentCardData> items;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: titleStyle ??
                headerThreeMediumTextStyle(
                  context: context,
                  fontColor: context.appColors.secondary_600,
                ),
          ),
          const SizedBox(
            height: 16,
            width: double.infinity,
          ),
          ...List<Widget>.generate(
            items.length,
            (int index) => Padding(
              padding: EdgeInsets.only(
                bottom: index < items.length - 1 ? 12 : 0,
              ),
              child: PaymentMethodCard(
                backgroundColor: items[index].backgroundColor,
                circleColor: items[index].circleColor,
                icon: items[index].icon,
                iconColor: items[index].iconColor,
                text: items[index].text,
                textStyle: items[index].textStyle,
                iconSize: items[index].iconSize,
                circleSize: items[index].circleSize,
                padding: items[index].padding,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("title", title))
      ..add(IterableProperty<PaymentCardData>("items", items))
      ..add(DiagnosticsProperty<TextStyle?>("titleStyle", titleStyle))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>("padding", padding));
  }
}

class PaymentCardData {
  const PaymentCardData({
    required this.backgroundColor,
    required this.icon,
    required this.text,
    this.circleColor = Colors.white,
    this.iconColor = Colors.black,
    this.textStyle,
    this.iconSize = 24.0,
    this.circleSize = 40.0,
    this.padding = const EdgeInsets.all(16),
  });
  final Color backgroundColor;
  final Color circleColor;
  final IconData icon;
  final Color iconColor;
  final String text;
  final TextStyle? textStyle;
  final double iconSize;
  final double circleSize;
  final EdgeInsetsGeometry padding;
}

@AppPreview(name: "Payment Methods List")
Widget paymentMethodsListPreview() {
  return const Scaffold(
    body: PaymentMethodsList(
      title: "Payment methods",
      items: <PaymentCardData>[
        PaymentCardData(
          backgroundColor: Color(0xFFF5F5F5),
          icon: Icons.credit_card,
          text: "Credit / Debit Card",
        ),
        PaymentCardData(
          backgroundColor: Color(0xFFF5F5F5),
          icon: Icons.account_balance_wallet,
          text: "Apple Pay",
        ),
      ],
    ),
  );
}

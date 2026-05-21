import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    required this.backgroundColor,
    required this.icon,
    required this.text,
    super.key,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // Circle background
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Icon
                  Icon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Text
              Flexible(
                child: Text(
                  text,
                  style: textStyle ??
                      bodyNormalTextStyle(
                        context: context,
                        fontColor: context.appColors.grey_900,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("circleColor", circleColor))
      ..add(DiagnosticsProperty<IconData>("icon", icon))
      ..add(ColorProperty("iconColor", iconColor))
      ..add(StringProperty("text", text))
      ..add(DiagnosticsProperty<TextStyle?>("textStyle", textStyle))
      ..add(DoubleProperty("iconSize", iconSize))
      ..add(DoubleProperty("circleSize", circleSize))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>("padding", padding));
  }
}

@AppPreview(name: "Payment Method Card")
Widget paymentMethodCardPreview() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: PaymentMethodCard(
        backgroundColor: Color(0xFFF5F5F5),
        icon: Icons.credit_card,
        text: "Credit / Debit Card",
      ),
    ),
  );
}

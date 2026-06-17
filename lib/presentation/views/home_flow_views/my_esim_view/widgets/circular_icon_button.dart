import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.size = 40,
    this.borderRadius = 40,
    this.iconSize = 24,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.grey[300]!,
        ),
        color: backgroundColor ?? Colors.transparent,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        color: iconColor,
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Factory methods for common use cases
  static CircularIconButton chart({
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return CircularIconButton(
      icon: Icons.bar_chart,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  static CircularIconButton qrCode({
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return CircularIconButton(
      icon: Icons.qr_code,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  static CircularIconButton share({
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return CircularIconButton(
      icon: Icons.share,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>("icon", icon))
      ..add(
        ObjectFlagProperty<VoidCallback>.has("onPressed", onPressed),
      )
      ..add(
        ColorProperty("backgroundColor", backgroundColor),
      )
      ..add(
        ColorProperty("iconColor", iconColor),
      )
      ..add(
        DoubleProperty("size", size),
      )
      ..add(
        DoubleProperty("iconSize", iconSize),
      )
      ..add(ColorProperty("borderColor", borderColor))
      ..add(DoubleProperty("borderRadius", borderRadius));
  }
}

@AppPreview(name: "Circular Icon Button")
Widget circularIconButtonPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: CircularIconButton(
        icon: Icons.share,
        onPressed: () {},
      ),
    ),
  );
}

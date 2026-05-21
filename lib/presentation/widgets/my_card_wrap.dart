import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MyCardWrap extends StatelessWidget {
  const MyCardWrap({
    super.key,
    this.child,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.color,
    this.withDelay = false,
    this.enableBorder = true,
    this.enableRipple = false,
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  });

  final Widget? child;

  final double? width;

  final double? height;

  final double borderRadius;

  final bool enableBorder;

  final Color? color;

  final bool enableRipple;

  final EdgeInsets padding;

  final EdgeInsets margin;

  final bool withDelay;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: width,
        height: height,
        decoration: enableBorder
            ? BoxDecoration(
                color: color ??
                    Theme.of(context).colorScheme.cCardBackground(context),
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .cForeground(context)
                        .withAlpha(100),

                    spreadRadius: 0.6,

                    blurRadius: 0.6,

                    // offset: const Offset(0, 2)
                  ),
                ],
              )
            : BoxDecoration(
                color: color ??
                    Theme.of(context).colorScheme.cCardBackground(context),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
        child: getWrappedWidget(),
      ),
    );
  }

  Widget? getWrappedWidget() {
    if (enableRipple) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () async {
            if (onTap != null) {
              await Future<void>.delayed(
                Duration(milliseconds: withDelay ? 300 : 0),
              );

              onTap!();
            }
          },
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      );
    } else if (onTap != null) {
      return GestureDetector(
        onTap: () async {
          await Future<void>.delayed(
            Duration(milliseconds: withDelay ? 300 : 0),
          );

          onTap!();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: padding,
          child: child,
        ),
      );
    } else {
      return Padding(
        padding: padding,
        child: child,
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties
      ..add(DoubleProperty("width", width))
      ..add(DoubleProperty("height", height))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(DiagnosticsProperty<bool>("enableBorder", enableBorder))
      ..add(ColorProperty("color", color))
      ..add(DiagnosticsProperty<bool>("enableRipple", enableRipple))
      ..add(DiagnosticsProperty<EdgeInsets>("padding", padding))
      ..add(DiagnosticsProperty<EdgeInsets>("margin", margin))
      ..add(DiagnosticsProperty<bool>("withDelay", withDelay))
      ..add(ObjectFlagProperty<void Function()?>.has("onTap", onTap));
  }
}

@AppPreview(name: "My Card Wrap")
Widget myCardWrapPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: MyCardWrap(
        padding: const EdgeInsets.all(16),
        child: const Text("Card content"),
      ),
    ),
  );
}

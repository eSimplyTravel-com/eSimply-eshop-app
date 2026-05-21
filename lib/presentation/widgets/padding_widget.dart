import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class PaddingWidget extends StatelessWidget {
  factory PaddingWidget.applySymmetricPadding({
    required Widget child,
    double vertical = 0.0,
    double horizontal = 0.0,
  }) {
    return PaddingWidget._(
      vertical: vertical,
      horizontal: horizontal,
      child: child,
    );
  }

  factory PaddingWidget.applyPadding({
    required Widget child,
    double top = 0.0,
    double end = 0.0,
    double start = 0.0,
    double bottom = 0.0,
    bool isRtlSupported = true,
  }) {
    return PaddingWidget._(
      top: top,
      bottom: bottom,
      end: end,
      start: start,
      isRtlSupported: isRtlSupported,
      child: child,
    );
  }

  const PaddingWidget._({
    required this.child,
    this.top = 0.0,
    this.end = 0.0,
    this.start = 0.0,
    this.bottom = 0.0,
    this.vertical = 0.0,
    this.horizontal = 0.0,
    this.isRtlSupported = true,
  });
  final double top;
  final double end;
  final double start;
  final double bottom;
  final double vertical;
  final double horizontal;
  final bool isRtlSupported;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (vertical != 0 || horizontal != 0) {
      return Padding(
        padding:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        child: child,
      );
    } else if (isRtlSupported) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: start,
          top: top,
          end: end,
          bottom: bottom,
        ),
        child: child,
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        left: start,
        top: top,
        right: end,
        bottom: bottom,
      ),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("end", end))
      ..add(DoubleProperty("bottom", bottom))
      ..add(DoubleProperty("top", top))
      ..add(DoubleProperty("start", start))
      ..add(DoubleProperty("vertical", vertical))
      ..add(DoubleProperty("horizontal", horizontal))
      ..add(DiagnosticsProperty<bool>("isRtlSupported", isRtlSupported));
  }
}

@AppPreview(name: "Padding Widget")
Widget paddingWidgetPreview() {
  return Scaffold(
    body: PaddingWidget.applySymmetricPadding(
      vertical: 16,
      horizontal: 16,
      child: const Text("Padded content"),
    ),
  );
}

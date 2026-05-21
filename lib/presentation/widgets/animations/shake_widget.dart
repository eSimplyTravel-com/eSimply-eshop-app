import "dart:math";

import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

@immutable
class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    required this.child,
    required this.startAnimation,
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.easeInCubic,
  });
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;
  final bool startAnimation;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration>("duration", duration))
      ..add(DoubleProperty("deltaX", deltaX))
      ..add(DiagnosticsProperty<Curve>("curve", curve))
      ..add(DiagnosticsProperty<bool>("startAnimation", startAnimation));
  }
}

class _ShakeWidgetState extends State<ShakeWidget> {
  /// convert 0-1 to 0-1-0
  double shake(double animation) => sin(animation * pi * 4);

  double tweenEndValue = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.startAnimation) {
      tweenEndValue = 1.0;
    }

    return TweenAnimationBuilder<double>(
      key: widget.key,
      curve: widget.curve,
      tween: Tween<double>(begin: 0, end: tweenEndValue),
      duration: widget.duration,
      builder: (BuildContext context, double animation, Widget? child) =>
          Transform.translate(
        offset: Offset(widget.deltaX * shake(animation), 0),
        child: child,
      ),
      child: widget.child,
      onEnd: () {
        setState(() {
          tweenEndValue = 0.0;
        });
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty("tweenEndValue", tweenEndValue));
  }
}

@AppPreview(name: "Shake Widget")
Widget shakeWidgetPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ShakeWidget(
          startAnimation: true,
          child: Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Shake",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    ),
  );
}

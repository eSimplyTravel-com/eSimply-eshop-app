import "dart:math";

import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class AnimationFlipHorizontally extends StatefulWidget {
  const AnimationFlipHorizontally({
    required this.front,
    required this.back,
    super.key,
    this.flipXAxis = true,
    this.showFrontSide = true,
    this.widgetPressed,
  });

  final Widget front;
  final Widget back;
  final bool flipXAxis;
  final bool showFrontSide;
  final void Function()? widgetPressed;

  @override
  AnimationFlipHorizontallyState createState() =>
      AnimationFlipHorizontallyState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("flipXAxis", flipXAxis))
      ..add(DiagnosticsProperty<bool>("showFrontSide", showFrontSide))
      ..add(
        ObjectFlagProperty<void Function()?>.has(
          "widgetPressed",
          widgetPressed,
        ),
      );
  }
}

class AnimationFlipHorizontallyState extends State<AnimationFlipHorizontally> {
  // late bool _showFrontSide;
  late bool _flipXAxis;

  @override
  void initState() {
    super.initState();
    // _showFrontSide = true;
    _flipXAxis = widget.flipXAxis;
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation();
  }

  Widget _buildFlipAnimation() {
    return GestureDetector(
      onTap: () => widget.widgetPressed?.call(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (Widget? widget, List<Widget> list) =>
            Stack(children: <Widget>[widget!, ...list]),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: widget.showFrontSide
            ? _buildFront(widget.front)
            : _buildRear(widget.back),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget2, Animation<double> animation) {
    final Animation<double> rotateAnim =
        Tween<double>(begin: pi, end: 0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget2,
      builder: (BuildContext context, Widget? widget3) {
        final bool isUnder =
            (ValueKey<bool>(widget.showFrontSide) != widget3?.key);
        double tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final double value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          alignment: Alignment.center,
          child: widget3,
        );
      },
    );
  }

  Widget _buildFront(Widget front) {
    return Container(key: const ValueKey<bool>(true), child: front);
  }

  Widget _buildRear(Widget back) {
    return Container(key: const ValueKey<bool>(false), child: back);
  }
}

@AppPreview(name: "Animation Flip Horizontally")
Widget animationFlipHorizontallyPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: AnimationFlipHorizontally(
          front: Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            color: Colors.blue,
            child: const Text(
              "Front",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          back: Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            color: Colors.deepPurple,
            child: const Text(
              "Back",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    ),
  );
}

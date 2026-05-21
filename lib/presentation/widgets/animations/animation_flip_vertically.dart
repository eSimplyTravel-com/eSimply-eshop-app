library flutter_bounce;

import "dart:async";
import "dart:math" as math;

import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class AnimationFlipVertically extends StatefulWidget {
  // This will get the data from the pages
  // Makes sure child won't be passed as null
  const AnimationFlipVertically({
    required this.child,
    required this.duration,
    required this.startAfter,
    super.key,
    /*required this.onPressed,*/ this.autoStart = false,
  });
  // final VoidCallback onPressed;
  final Widget child;
  final Duration duration;
  final bool autoStart;
  final int startAfter;

  @override
  AnimationFlipVerticallyState createState() => AnimationFlipVerticallyState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration>("duration", duration))
      ..add(DiagnosticsProperty<bool>("autoStart", autoStart))
      ..add(IntProperty("startAfter", startAfter));
  }
}

class AnimationFlipVerticallyState extends State<AnimationFlipVertically>
    with SingleTickerProviderStateMixin {
  late double _scale;

  // This controller is responsible for the animation
  late AnimationController _animate;

  //Getting the VoidCallack onPressed passed by the user
  // VoidCallback get onPressed => widget.onPressed;

  // This is a user defined duration, which will be responsible for
  // what kind of bounce he/she wants
  Duration get userDuration => widget.duration;

  @override
  void initState() {
    //defining the controller

    super.initState();
    _animate = AnimationController(
      vsync: this,
      duration: userDuration, //This is an inital controller duration
      lowerBound: -math.pi,
      upperBound: 0,
    )..addListener(() {
        setState(() {});
      }); // Can do something in the listener, but not required
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async => loopOnce(context),
      ); //i add this to access the context safely.
    }
  }

  Future<void> loopOnce(BuildContext context) async {
    //Firing the animation right away
    Future<void>.delayed(Duration(milliseconds: widget.startAfter), () {
      unawaited(_animate.forward());
    });

    //Now reversing the animation after the user defined duration
    // Future.delayed(userDuration, () {
    //   _animate.reverse();
    // });
  }

  @override
  void dispose() {
    // To dispose the controller when not required
    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = _animate.value;
    // return GestureDetector(
    //     onTap: _onTap,
    //     child:
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(_scale),
      child: widget.child,
      // )
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>("userDuration", userDuration));
  }
}

@AppPreview(name: "Animation Flip Vertically")
Widget animationFlipVerticallyPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: AnimationFlipVertically(
          duration: const Duration(milliseconds: 800),
          startAfter: 300,
          autoStart: true,
          child: Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            color: Colors.teal,
            child: const Text(
              "Flip",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    ),
  );
}

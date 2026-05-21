library flutter_bounce;

import "dart:async";

import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class AnimationScaleUpDown extends StatefulWidget {
  // This will get the data from the pages
  // Makes sure child won't be passed as null
  const AnimationScaleUpDown({
    required this.child,
    required this.duration,
    super.key,
    /*required this.onPressed,*/ this.autoStart = false,
  });
  // final VoidCallback onPressed;
  final Widget child;
  final Duration duration;
  final bool autoStart;

  @override
  AnimationScaleUpDownState createState() => AnimationScaleUpDownState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration>("duration", duration))
      ..add(DiagnosticsProperty<bool>("autoStart", autoStart));
  }
}

class AnimationScaleUpDownState extends State<AnimationScaleUpDown>
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
      upperBound: 0.4,
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
    unawaited(_animate.forward());

    //Now reversing the animation after the user defined duration
    Future<void>.delayed(userDuration, () {
      unawaited(_animate.reverse());
    });
  }

  @override
  void dispose() {
    // To dispose the controller when not required
    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 + _animate.value;
    // return GestureDetector(
    //     onTap: _onTap,
    //     child:
    return Transform.scale(
      scale: _scale,
      child: widget.child,
      // ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>("userDuration", userDuration));
  }
}

@AppPreview(name: "Animation Scale Up Down")
Widget animationScaleUpDownPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: AnimationScaleUpDown(
          duration: const Duration(milliseconds: 600),
          autoStart: true,
          child: Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            color: Colors.orange,
            child: const Text(
              "Scale",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    ),
  );
}

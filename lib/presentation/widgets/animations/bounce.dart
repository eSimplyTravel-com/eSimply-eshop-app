library flutter_bounce;

import "dart:async";

import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class Bounce extends StatefulWidget {
  // This will get the data from the pages
  // Makes sure child won't be passed as null
  const Bounce({
    required this.child,
    required this.duration,
    required this.onPressed,
    super.key,
  });
  final VoidCallback onPressed;
  final Widget child;
  final Duration duration;

  @override
  BounceState createState() => BounceState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback>.has("onPressed", onPressed))
      ..add(DiagnosticsProperty<Duration>("duration", duration));
  }
}

class BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  late double _scale;

  // This controller is responsible for the animation
  late AnimationController _animate;

  //Getting the VoidCallack onPressed passed by the user
  VoidCallback get onPressed => widget.onPressed;

  // This is a user defined duration, which will be responsible for
  // what kind of bounce he/she wants
  Duration get userDuration => widget.duration;

  @override
  void initState() {
    super.initState();
    //defining the controller
    _animate = AnimationController(
      vsync: this,
      duration: userDuration, //This is an inital controller duration
      upperBound: 0.15,
    )..addListener(() {
        setState(() {});
      }); // Can do something in the listener, but not required
  }

  @override
  void dispose() {
    // To dispose the contorller when not required
    _animate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animate.value;
    return GestureDetector(
      onTap: _onTap,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  //This is where the animation works out for us
  // Both the animation happens in the same method,
  // but in a duration of time, and our callback is called here as well
  void _onTap() {
    //Firing the animation right away
    unawaited(_animate.forward());

    //Now reversing the animation after the user defined duration
    Future<void>.delayed(userDuration, () {
      unawaited(_animate.reverse());

      //Calling the callback
      onPressed();
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<VoidCallback>.has("onPressed", onPressed))
      ..add(DiagnosticsProperty<Duration>("userDuration", userDuration));
  }
}

@AppPreview(name: "Bounce")
Widget bouncePreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Bounce(
          duration: const Duration(milliseconds: 150),
          onPressed: () {},
          child: Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Tap me",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    ),
  );
}

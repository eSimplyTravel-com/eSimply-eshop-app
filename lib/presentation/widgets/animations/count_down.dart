import "dart:developer";

import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class Countdown extends StatefulWidget {
  const Countdown({
    required this.numberOfSeconds,
    required this.onCounterCompleted,
    super.key,
    this.build,
  });
  final double numberOfSeconds;
  final void Function() onCounterCompleted;
  final Widget? Function(BuildContext, Duration, String)? build;

  @override
  State<StatefulWidget> createState() {
    return _CountdownState();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("numberOfSeconds", numberOfSeconds))
      ..add(
        ObjectFlagProperty<void Function()>.has(
          "onCounterCompleted",
          onCounterCompleted,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Widget? Function(
              BuildContext p1,
              Duration p2,
              String p3,
            )?>.has("build", build),
      );
  }
}

class _CountdownState extends State<Countdown>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.numberOfSeconds.toInt()),
    )
      ..forward()
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          log("completed");
          widget.onCounterCompleted();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return _Countdown(
      animation: StepTween(
        begin: widget.numberOfSeconds.toInt(),
        end: 0,
      ).animate(_controller!),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class _Countdown extends AnimatedWidget {
  const _Countdown({required this.animation}) : super(listenable: animation);
  final Animation<int> animation;

  @override
  Text build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inHours.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';

    return Text(
      timerText,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.cForeground(context),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Animation<int>>("animation", animation));
  }
}

@AppPreview(name: "Countdown")
Widget countdownPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Countdown(
          numberOfSeconds: 60,
          onCounterCompleted: () {},
        ),
      ),
    ),
  );
}

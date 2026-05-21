import "dart:async";

import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class AnimatedCircularProgressIndicator extends StatefulWidget {
  const AnimatedCircularProgressIndicator({
    required this.targetValue,
    required this.valueColor,
    required this.isLoading,
    this.backgroundColor,
    super.key,
    this.duration = const Duration(milliseconds: 1000),
    this.strokeWidth = 35,
    this.strokeCap = StrokeCap.round,
  });
  final double targetValue;
  final Duration duration;
  final Color? backgroundColor;
  final Color valueColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final bool isLoading;

  @override
  State<AnimatedCircularProgressIndicator> createState() =>
      _AnimatedCircularProgressIndicatorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("targetValue", targetValue))
      ..add(DiagnosticsProperty<Duration>("duration", duration))
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("valueColor", valueColor))
      ..add(DoubleProperty("strokeWidth", strokeWidth))
      ..add(EnumProperty<StrokeCap>("strokeCap", strokeCap))
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading));
  }
}

class _AnimatedCircularProgressIndicatorState
    extends State<AnimatedCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.targetValue,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    unawaited(_controller.forward());
  }

  @override
  void didUpdateWidget(AnimatedCircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue) {
      // Update the animation if the target value changes
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.targetValue,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );

      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return CircularProgressIndicator(
          value: _animation.value,
          backgroundColor: widget.backgroundColor ??
              context.appColors.primary_50 ??
              Colors.grey.shade50,
          valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
          strokeWidth: widget.strokeWidth,
          strokeCap: widget.strokeCap,
        );
      },
    );
  }
}

@AppPreview(name: "Animated Circular Progress Indicator")
Widget animatedCircularProgressIndicatorPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: AnimatedCircularProgressIndicator(
            targetValue: 0.65,
            valueColor: Colors.blue,
            isLoading: false,
          ),
        ),
      ),
    ),
  );
}

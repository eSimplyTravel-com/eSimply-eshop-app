import "dart:async";
import "dart:math" as math;

import "package:esim_open_source/presentation/previews/app_preview.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class AnimatedHalfCircularProgressIndicator extends StatefulWidget {
  const AnimatedHalfCircularProgressIndicator({
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
  State<AnimatedHalfCircularProgressIndicator> createState() =>
      _AnimatedHalfCircularProgressIndicatorState();

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

class _AnimatedHalfCircularProgressIndicatorState
    extends State<AnimatedHalfCircularProgressIndicator>
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
  void didUpdateWidget(AnimatedHalfCircularProgressIndicator oldWidget) {
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
        return CustomPaint(
          painter: HalfCircleProgressPainter(
            backgroundColor: widget.backgroundColor ??
                consumptionBackgroundColor(context: context),
            valueColor: widget.valueColor,
            value: _animation.value,
            strokeWidth: widget.strokeWidth,
            strokeCap: widget.strokeCap,
          ),
          // Size the custom painter to make it a proper semicircle
          size: Size(widget.strokeWidth * 6, widget.strokeWidth * 3),
        );
      },
    );
  }
}

class HalfCircleProgressPainter extends CustomPainter {
  HalfCircleProgressPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.value,
    required this.strokeWidth,
    required this.strokeCap,
  });
  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final double strokeWidth;
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 1.1);
    final double radius = size.width / 2;

    // Background track
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    // Draw background half-circle (the bottom half, starting from top-left going to top-right)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      math.pi, // Start from the left side at top (180 degrees)
      math.pi, // Go counter-clockwise to the right side at top (180 degrees)
      false,
      backgroundPaint,
    );

    // Progress paint
    final Paint progressPaint = Paint()
      ..color = valueColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    // Draw progress arc
    final double progressAngle = math.pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      math.pi, // Start from the left side at top (180 degrees)
      progressAngle, // Go counter-clockwise based on progress (0 to 180 degrees)
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(HalfCircleProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.valueColor != valueColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeCap != strokeCap;
  }
}

@AppPreview(name: "Animated Half Circular Progress Indicator")
Widget animatedHalfCircularProgressIndicatorPreview() {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: AnimatedHalfCircularProgressIndicator(
          targetValue: 0.6,
          valueColor: Colors.blue,
          isLoading: false,
        ),
      ),
    ),
  );
}

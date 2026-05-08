import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Paints a thin gold circular progress arc that animates smoothly.
/// The arc sweeps around with a trailing gradient effect.
class LoadingArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0, controls the rotation angle
  final double arcLength; // how much of the circle to draw (in radians)

  LoadingArcPainter({
    required this.progress,
    this.arcLength = pi * 0.75,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startAngle = 2 * pi * progress - pi / 2;

    // Background track (very subtle)
    final trackPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Main arc with gradient
    final arcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + arcLength,
        colors: [
          AppColors.accent.withValues(alpha: 0.0),
          AppColors.accent.withValues(alpha: 0.3),
          AppColors.accent.withValues(alpha: 0.7),
          AppColors.accent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
        transform: GradientRotation(startAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, arcLength, false, arcPaint);

    // Bright tip dot at the end of the arc
    final tipAngle = startAngle + arcLength;
    final tipX = center.dx + radius * cos(tipAngle);
    final tipY = center.dy + radius * sin(tipAngle);

    final tipGlow = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(tipX, tipY), 2.5, tipGlow);

    final tipPaint = Paint()..color = AppColors.accent;
    canvas.drawCircle(Offset(tipX, tipY), 1.5, tipPaint);
  }

  @override
  bool shouldRepaint(covariant LoadingArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

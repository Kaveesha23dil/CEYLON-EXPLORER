import 'dart:math';
import 'package:flutter/material.dart';

/// Paints a subtle topographic / wave pattern overlay at very low opacity.
/// Creates organic contour lines reminiscent of ocean waves and terrain maps.
class TopoPatternPainter extends CustomPainter {
  final double opacity;

  TopoPatternPainter({this.opacity = 0.06});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final w = size.width;
    final h = size.height;

    // Draw organic wave/topo contour lines
    for (int i = 0; i < 18; i++) {
      final path = Path();
      final yBase = (h / 18) * i - h * 0.1;
      final amplitude = 18.0 + (i % 3) * 8.0;
      final frequency = 0.003 + (i % 4) * 0.001;
      final phaseShift = i * 0.7;

      path.moveTo(-20, yBase);
      for (double x = -20; x <= w + 20; x += 4) {
        final y = yBase +
            sin(x * frequency + phaseShift) * amplitude +
            cos(x * frequency * 1.5 + phaseShift * 0.5) * (amplitude * 0.4);
        if (x == -20) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    // Add concentric circular topo rings (like a terrain elevation map)
    final centerX = w * 0.65;
    final centerY = h * 0.35;
    for (int r = 1; r <= 6; r++) {
      final radius = r * 35.0;
      final ringPath = Path();
      for (double angle = 0; angle <= 2 * pi; angle += 0.05) {
        final distortion = sin(angle * 3 + r) * 8.0 + cos(angle * 5) * 4.0;
        final px = centerX + (radius + distortion) * cos(angle);
        final py = centerY + (radius + distortion) * sin(angle);
        if (angle == 0) {
          ringPath.moveTo(px, py);
        } else {
          ringPath.lineTo(px, py);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, paint);
    }

    // Second cluster bottom-left
    final cx2 = w * 0.25;
    final cy2 = h * 0.72;
    for (int r = 1; r <= 4; r++) {
      final radius = r * 40.0;
      final ringPath = Path();
      for (double angle = 0; angle <= 2 * pi; angle += 0.05) {
        final distortion = sin(angle * 4 + r * 0.8) * 10.0;
        final px = cx2 + (radius + distortion) * cos(angle);
        final py = cy2 + (radius + distortion) * sin(angle);
        if (angle == 0) {
          ringPath.moveTo(px, py);
        } else {
          ringPath.lineTo(px, py);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TopoPatternPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

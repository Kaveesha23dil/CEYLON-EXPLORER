import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Paints a stylised Sri Lanka island silhouette with a golden lotus flower overlay.
/// The silhouette has a soft golden glow, and the lotus is layered on top.
class SriLankaLogoPainter extends CustomPainter {
  final double glowIntensity;

  SriLankaLogoPainter({this.glowIntensity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // ── Sri Lanka Island Silhouette ──
    _drawIsland(canvas, size, cx);

    // ── Golden Glow behind lotus ──
    _drawGlow(canvas, w, h, cx);

    // ── Lotus Flower ──
    _drawLotus(canvas, w, h, cx);
  }

  void _drawIsland(Canvas canvas, Size size, double cx) {
    final w = size.width;
    final h = size.height;

    final islandPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accent.withValues(alpha: 0.25),
          AppColors.islandSilhouette.withValues(alpha: 0.9),
          AppColors.accent.withValues(alpha: 0.15),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Stylized Sri Lanka shape — a teardrop/leaf pointing south
    final island = Path();
    
    // Start from top (Jaffna peninsula area)
    island.moveTo(cx - w * 0.04, h * 0.12);
    // Jaffna peninsula bump
    island.cubicTo(
      cx - w * 0.08, h * 0.08,
      cx + w * 0.06, h * 0.06,
      cx + w * 0.04, h * 0.13,
    );
    // Northeast coast (Trincomalee area)
    island.cubicTo(
      cx + w * 0.12, h * 0.15,
      cx + w * 0.20, h * 0.22,
      cx + w * 0.22, h * 0.30,
    );
    // East coast (Batticaloa)
    island.cubicTo(
      cx + w * 0.24, h * 0.38,
      cx + w * 0.22, h * 0.46,
      cx + w * 0.18, h * 0.54,
    );
    // Southeast (Arugam Bay to Yala)
    island.cubicTo(
      cx + w * 0.15, h * 0.60,
      cx + w * 0.12, h * 0.66,
      cx + w * 0.06, h * 0.72,
    );
    // Southern tip (Matara / Dondra Head)
    island.cubicTo(
      cx + w * 0.02, h * 0.78,
      cx - w * 0.02, h * 0.80,
      cx - w * 0.06, h * 0.76,
    );
    // Southwest coast (Galle)
    island.cubicTo(
      cx - w * 0.12, h * 0.70,
      cx - w * 0.18, h * 0.60,
      cx - w * 0.22, h * 0.50,
    );
    // West coast (Colombo area)
    island.cubicTo(
      cx - w * 0.24, h * 0.40,
      cx - w * 0.22, h * 0.30,
      cx - w * 0.16, h * 0.22,
    );
    // Northwest (Negombo / Puttalam)
    island.cubicTo(
      cx - w * 0.12, h * 0.17,
      cx - w * 0.08, h * 0.14,
      cx - w * 0.04, h * 0.12,
    );
    island.close();

    canvas.drawPath(island, islandPaint);

    // Island outline glow
    final outlinePaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6);
    canvas.drawPath(island, outlinePaint);

    // Subtle inner detail line (central highlands)
    final detailPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final highlands = Path();
    highlands.moveTo(cx - w * 0.06, h * 0.35);
    highlands.cubicTo(
      cx - w * 0.02, h * 0.30,
      cx + w * 0.04, h * 0.32,
      cx + w * 0.06, h * 0.38,
    );
    highlands.cubicTo(
      cx + w * 0.05, h * 0.44,
      cx - w * 0.01, h * 0.48,
      cx - w * 0.06, h * 0.45,
    );
    highlands.close();
    canvas.drawPath(highlands, detailPaint);
  }

  void _drawGlow(Canvas canvas, double w, double h, double cx) {
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(0, -0.1),
        radius: 0.5,
        colors: [
          AppColors.accent.withValues(alpha: 0.18 * glowIntensity),
          AppColors.accent.withValues(alpha: 0.06 * glowIntensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawCircle(Offset(cx, h * 0.42), w * 0.35, glowPaint);
  }

  void _drawLotus(Canvas canvas, double w, double h, double cx) {
    final lotusCenter = Offset(cx, h * 0.42);
    final petalLength = w * 0.14;
    final petalWidth = w * 0.055;

    // Outer glow for lotus
    final lotusGlow = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.15 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(lotusCenter, petalLength * 0.7, lotusGlow);

    // Draw petals in two layers
    _drawPetalRing(canvas, lotusCenter, petalLength, petalWidth, 8, 0,
        AppColors.accent.withValues(alpha: 0.7));
    _drawPetalRing(canvas, lotusCenter, petalLength * 0.65, petalWidth * 0.8, 6,
        pi / 8, AppColors.accent.withValues(alpha: 0.85));

    // Center circle
    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accent,
          AppColors.accent.withValues(alpha: 0.6),
        ],
      ).createShader(
        Rect.fromCircle(center: lotusCenter, radius: petalWidth * 0.6),
      );
    canvas.drawCircle(lotusCenter, petalWidth * 0.55, centerPaint);

    // Center highlight dot
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4);
    canvas.drawCircle(
      lotusCenter + Offset(-petalWidth * 0.1, -petalWidth * 0.1),
      petalWidth * 0.18,
      dotPaint,
    );
  }

  void _drawPetalRing(Canvas canvas, Offset center, double length,
      double width, int count, double startAngle, Color color) {
    for (int i = 0; i < count; i++) {
      final angle = startAngle + (2 * pi / count) * i;
      _drawPetal(canvas, center, length, width, angle, color);
    }
  }

  void _drawPetal(Canvas canvas, Offset center, double length, double width,
      double angle, Color color) {
    final petalPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color.withValues(alpha: color.a * 0.4),
        ],
      ).createShader(
        Rect.fromCenter(center: center, width: length * 2, height: length * 2),
      )
      ..style = PaintingStyle.fill;

    final path = Path();
    final tipX = center.dx + length * cos(angle);
    final tipY = center.dy + length * sin(angle);
    final perpAngle = angle + pi / 2;

    final leftX = center.dx + width * cos(perpAngle);
    final leftY = center.dy + width * sin(perpAngle);
    final rightX = center.dx - width * cos(perpAngle);
    final rightY = center.dy - width * sin(perpAngle);

    // Control points for curved petal
    final ctrl1X = center.dx + length * 0.5 * cos(angle) + width * 1.2 * cos(perpAngle);
    final ctrl1Y = center.dy + length * 0.5 * sin(angle) + width * 1.2 * sin(perpAngle);
    final ctrl2X = center.dx + length * 0.5 * cos(angle) - width * 1.2 * cos(perpAngle);
    final ctrl2Y = center.dy + length * 0.5 * sin(angle) - width * 1.2 * sin(perpAngle);

    path.moveTo(center.dx, center.dy);
    path.cubicTo(ctrl1X, ctrl1Y, tipX + width * 0.3 * cos(perpAngle),
        tipY + width * 0.3 * sin(perpAngle), tipX, tipY);
    path.cubicTo(tipX - width * 0.3 * cos(perpAngle),
        tipY - width * 0.3 * sin(perpAngle), ctrl2X, ctrl2Y, center.dx, center.dy);
    path.close();

    canvas.drawPath(path, petalPaint);

    // Subtle petal edge
    final edgePaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawPath(path, edgePaint);
  }

  @override
  bool shouldRepaint(covariant SriLankaLogoPainter oldDelegate) {
    return oldDelegate.glowIntensity != glowIntensity;
  }
}

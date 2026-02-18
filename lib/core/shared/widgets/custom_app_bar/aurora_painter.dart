import 'dart:math';

import 'package:flutter/material.dart';

class AuroraPainter extends CustomPainter {
  final Color a;
  final Color b;
  final Color c;

  AuroraPainter({required this.a, required this.b, required this.c});

  @override
  void paint(Canvas canvas, Size size) {
    _paintRibbon(
      canvas,
      size,
      a.withValues(alpha: 0.22),
      0.14,
      0.42,
      0.78,
      0.9,
    );
    _paintRibbon(
      canvas,
      size,
      b.withValues(alpha: 0.18),
      0.02,
      0.30,
      0.64,
      1.25,
    );
    _paintRibbon(
      canvas,
      size,
      c.withValues(alpha: 0.14),
      0.22,
      0.52,
      0.90,
      1.6,
    );

    _paintHighlightStreak(canvas, size);
    _paintParticles(canvas, size);
  }

  void _paintRibbon(
    Canvas canvas,
    Size size,
    Color color,
    double yTop,
    double yMid,
    double yBot,
    double phase,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final w = size.width;
    final h = size.height;

    final p = Path()..moveTo(-w * 0.20, h * yMid);

    // curva superior
    p.quadraticBezierTo(
      w * 0.18,
      h * (yTop + 0.10 * sin(phase)),
      w * 0.52,
      h * yMid,
    );

    // curva inferior
    p.quadraticBezierTo(
      w * 0.78,
      h * (yBot + 0.08 * cos(phase * 1.1)),
      w * 1.18,
      h * (yMid - 0.03),
    );

    // fecha com "espessura"
    p.lineTo(w * 1.18, h * (yMid + 0.22));
    p.quadraticBezierTo(
      w * 0.82,
      h * (yBot + 0.18),
      w * 0.40,
      h * (yMid + 0.16),
    );
    p.quadraticBezierTo(
      w * 0.06,
      h * (yTop + 0.22),
      -w * 0.20,
      h * (yMid + 0.18),
    );
    p.close();

    canvas.drawPath(p, paint);
  }

  void _paintHighlightStreak(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.00),
          Colors.white.withValues(alpha: 0.10),
          Colors.white.withValues(alpha: 0.00),
        ],
        stops: const [0.34, 0.52, 0.72],
      ).createShader(rect);

    final p = Path()
      ..moveTo(size.width * 0.08, 0)
      ..lineTo(size.width * 0.28, 0)
      ..lineTo(size.width * 0.88, size.height)
      ..lineTo(size.width * 0.68, size.height)
      ..close();

    canvas.drawPath(p, paint);
  }

  void _paintParticles(Canvas canvas, Size size) {
    final rnd = Random(42);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * (size.height * 0.55);
      final r = 0.6 + rnd.nextDouble() * 1.7;

      final alpha = 0.08 + rnd.nextDouble() * 0.16;
      paint.color = Colors.white.withValues(alpha: alpha);

      canvas.drawCircle(Offset(x, y), r, paint);

      // algumas estrelinhas em cruz
      if (i % 11 == 0) {
        final s = 2.0 + rnd.nextDouble() * 2.4;
        paint.color = Colors.white.withValues(alpha: alpha * 0.9);
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s * 1.7, height: 0.8),
          paint,
        );
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: 0.8, height: s * 1.7),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AuroraPainter oldDelegate) {
    return oldDelegate.a != a || oldDelegate.b != b || oldDelegate.c != c;
  }
}
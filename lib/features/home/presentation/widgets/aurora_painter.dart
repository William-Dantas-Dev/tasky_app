import 'dart:math';
import 'package:flutter/material.dart';

class AuroraPainter extends CustomPainter {
  final Color a;
  final Color b;
  final Color c;

  AuroraPainter({required this.a, required this.b, required this.c});

  @override
  void paint(Canvas canvas, Size size) {
    // Fundo: você já tem gradiente no Container, então aqui é só “efeito”
    _paintRibbon(canvas, size, a.withValues(alpha:0.28), 0.18, 0.55, 0.85, 0.8);
    _paintRibbon(canvas, size, b.withValues(alpha:0.22), 0.05, 0.35, 0.70, 1.1);
    _paintRibbon(canvas, size, c.withValues(alpha:0.18), 0.28, 0.62, 0.95, 1.4);

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

    final p = Path()..moveTo(-w * 0.2, h * yMid);

    // Curva orgânica
    p.quadraticBezierTo(
      w * 0.15,
      h * (yTop + 0.10 * sin(phase)),
      w * 0.45,
      h * yMid,
    );
    p.quadraticBezierTo(
      w * 0.70,
      h * (yBot + 0.08 * cos(phase * 1.3)),
      w * 1.15,
      h * (yMid - 0.04),
    );

    // Fecha ribbon com “espessura”
    p.lineTo(w * 1.15, h * (yMid + 0.22));
    p.quadraticBezierTo(
      w * 0.75,
      h * (yBot + 0.18),
      w * 0.35,
      h * (yMid + 0.18),
    );
    p.quadraticBezierTo(
      w * 0.05,
      h * (yTop + 0.22),
      -w * 0.2,
      h * (yMid + 0.20),
    );
    p.close();

    canvas.drawPath(p, paint);
  }

  void _paintHighlightStreak(Canvas canvas, Size size) {
    // Brilho diagonal sutil (tipo "glass")
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha:0.00),
          Colors.white.withValues(alpha:0.10),
          Colors.white.withValues(alpha:0.00),
        ],
        stops: const [0.35, 0.52, 0.70],
      ).createShader(rect);

    // Faixa diagonal “recortada”
    final p = Path()
      ..moveTo(size.width * 0.10, 0)
      ..lineTo(size.width * 0.30, 0)
      ..lineTo(size.width * 0.90, size.height)
      ..lineTo(size.width * 0.70, size.height)
      ..close();

    canvas.drawPath(p, paint);
  }

  void _paintParticles(Canvas canvas, Size size) {
    // Partículas fixas, mas com distribuição pseudo-aleatória determinística
    final rnd = Random(42);

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 42; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * (size.height * 0.55);
      final r = 0.6 + rnd.nextDouble() * 1.8;

      // brilho variado
      final alpha = 0.08 + rnd.nextDouble() * 0.18;
      paint.color = Colors.white.withValues(alpha:alpha);

      canvas.drawCircle(Offset(x, y), r, paint);

      // algumas “estrelas” com cross
      if (i % 10 == 0) {
        final s = 2.2 + rnd.nextDouble() * 2.5;
        paint.color = Colors.white.withValues(alpha:alpha * 0.9);
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: s * 1.6, height: 0.8),
          paint,
        );
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: 0.8, height: s * 1.6),
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

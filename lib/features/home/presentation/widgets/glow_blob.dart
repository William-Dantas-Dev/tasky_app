import 'dart:ui';
import 'package:flutter/material.dart';

class GlowBlob extends StatelessWidget {
  final double size;
  final Color color;

  const GlowBlob({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha:0.6),
        ),
      ),
    );
  }
}

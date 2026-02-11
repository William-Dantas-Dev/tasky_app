import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String tag;
  final bool muted;

  const Tag({super.key, required this.tag, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = muted
        ? Colors.black.withValues(alpha: 0.06)
        : cs.primary.withValues(alpha: 0.12);
    final fg = muted ? Colors.black54 : cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
          fontSize: 12,
        ),
      ),
    );
  }
}

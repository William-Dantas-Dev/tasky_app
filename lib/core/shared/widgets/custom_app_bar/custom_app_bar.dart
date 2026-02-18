import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tasky_app/core/shared/widgets/custom_app_bar/header_app_bar.dart';
import 'aurora_painter.dart';
import 'waver_painter.dart';

class CustomAppBar extends StatelessWidget {
  final String dateLabel;
  final int doneCount;
  final int totalCount;
  final double progress;
  final double expandedHeight;
  final bool pinned;

  const CustomAppBar({
    super.key,
    required this.dateLabel,
    required this.doneCount,
    required this.totalCount,
    required this.progress,
    this.expandedHeight = 200,
    this.pinned = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final pct = max(0, (progress * 100).round());

    return SliverAppBar(
      pinned: pinned,
      elevation: 0,
      expandedHeight: expandedHeight,
      backgroundColor: cs.primary,
      surfaceTintColor: Colors.transparent,
      title: const Text('Tasky', style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const SizedBox(width: 6),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.secondary.withValues(alpha: 0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: AuroraPainter(
                  a: Colors.white,
                  b: cs.tertiary,
                  c: cs.secondary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: CustomPaint(
                  painter: WavePainter(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
              ),
            ),
            HeaderAppBar(
              dateLabel: dateLabel,
              doneCount: doneCount,
              totalCount: totalCount,
              pct: pct,
            ),
          ],
        ),
      ),
    );
  }
}

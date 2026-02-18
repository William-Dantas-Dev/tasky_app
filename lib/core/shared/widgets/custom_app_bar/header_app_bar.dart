import 'package:flutter/material.dart';

import 'pill.dart';

class HeaderAppBar extends StatelessWidget {
  final String dateLabel;
  final int doneCount;
  final int totalCount;
  final int pct;
  const HeaderAppBar({
    super.key,
    required this.dateLabel,
    required this.doneCount,
    required this.totalCount,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 88, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bem-vindo 👋',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dateLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Pill(
                icon: Icons.check_circle_outline_rounded,
                text: '$doneCount/$totalCount concluídas',
              ),
              const SizedBox(width: 10),
              Pill(icon: Icons.bolt_rounded, text: 'Ritmo: $pct%'),
            ],
          ),
        ],
      ),
    );
  }
}

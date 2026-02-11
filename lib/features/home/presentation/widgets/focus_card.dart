import 'package:flutter/material.dart';
import './tag.dart';

class FocusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final bool done;
  final double progress;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const FocusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.done,
    required this.progress,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.10),
            cs.secondary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Progress ring vibe
          SizedBox(
            height: 56,
            width: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.white,
                ),
                Icon(
                  done ? Icons.check_rounded : Icons.play_arrow_rounded,
                  color: cs.primary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Tag(tag: tag),
                    const SizedBox(width: 8),
                    if (done)
                      const Tag(
                        tag: 'FEITO',
                        muted: true,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPrimary,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(done ? 'Rever' : 'Começar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      onPressed: onSecondary,
                      icon: const Icon(Icons.done_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

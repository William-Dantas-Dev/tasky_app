import 'package:flutter/material.dart';
import './tag.dart';

class FocusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final bool done;
  final double progress;

  final bool isActive;
  final String? primaryText;

  final int workMinutes;
  final int breakMinutes;

  /// aplica work/break de uma vez
  final void Function(int workMinutes, int breakMinutes) onPickDurations;

  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const FocusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.done,
    required this.progress,
    required this.isActive,
    this.primaryText,
    required this.workMinutes,
    required this.breakMinutes,
    required this.onPickDurations,
    required this.onPrimary,
    required this.onSecondary,
  });

  void _openConfig(BuildContext context) async {
    final result = await showModalBottomSheet<_Durations>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => _FocusConfigSheet(
        initialWork: workMinutes,
        initialBreak: breakMinutes,
      ),
    );

    if (result != null) {
      onPickDurations(result.workMinutes, result.breakMinutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final p = progress.clamp(0.0, 1.0);
    final ringIcon = done ? Icons.check_rounded : Icons.play_arrow_rounded;
    final primaryLabel = primaryText ?? (done ? 'Rever' : 'Começar');
    final canMarkDone = !done;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? cs.primary : Colors.grey.shade200,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.20),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ]
            : [],
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
          SizedBox(
            height: 56,
            width: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: p,
                  strokeWidth: 6,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    done ? cs.tertiary : cs.primary,
                  ),
                ),
                Icon(ringIcon, color: done ? cs.tertiary : cs.primary),
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

                    // Config integrado (work/break)
                    InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => _openConfig(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 16,
                              color: Colors.black.withValues(alpha: 0.70),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${workMinutes}m / ${breakMinutes}m',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.black.withValues(alpha: 0.75),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.expand_more_rounded,
                              size: 16,
                              color: Colors.black.withValues(alpha: 0.55),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (done) const Tag(tag: 'FEITO', muted: true),
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
                        child: Text(primaryLabel),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: canMarkDone
                          ? 'Marcar como feito'
                          : 'Já concluído',
                      child: IconButton.filledTonal(
                        onPressed: canMarkDone ? onSecondary : null,
                        icon: const Icon(Icons.done_rounded),
                      ),
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

@immutable
class _Durations {
  final int workMinutes;
  final int breakMinutes;
  const _Durations(this.workMinutes, this.breakMinutes);
}

class _FocusConfigSheet extends StatefulWidget {
  final int initialWork;
  final int initialBreak;

  const _FocusConfigSheet({
    required this.initialWork,
    required this.initialBreak,
  });

  @override
  State<_FocusConfigSheet> createState() => _FocusConfigSheetState();
}

class _FocusConfigSheetState extends State<_FocusConfigSheet> {
  late double _work;
  late double _break;

  @override
  void initState() {
    super.initState();
    _work = widget.initialWork.toDouble();
    _break = widget.initialBreak.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurar Pomodoro',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ajuste foco e pausa. Ao aplicar, o timer é resetado.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          _SliderRow(
            label: 'Foco',
            valueLabel: '${_work.round()} min',
            min: 1,
            max: 90,
            divisions: 80,
            value: _work,
            onChanged: (v) => setState(() => _work = v),
          ),

          const SizedBox(height: 8),

          _SliderRow(
            label: 'Pausa',
            valueLabel: '${_break.round()} min',
            min: 3,
            max: 30,
            divisions: 27,
            value: _break,
            onChanged: (v) => setState(() => _break = v),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      _Durations(_work.round(), _break.round()),
                    );
                  },
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double min;
  final double max;
  final int divisions;
  final double value;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.valueLabel,
    required this.min,
    required this.max,
    required this.divisions,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Text(
              valueLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

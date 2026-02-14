import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky_app/core/formatters/date_formatter.dart';
import 'package:tasky_app/core/utils/ui/app_snackbar.dart';
import 'package:tasky_app/core/utils/ui/gaps.dart';
import 'package:tasky_app/features/tasks/application/providers/tasks_providers.dart';
import 'package:tasky_app/features/tasks/data/models/task_model.dart';

DateTime _todayOnly() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

class CreateTaskSheet extends ConsumerStatefulWidget {
  const CreateTaskSheet({super.key});

  @override
  ConsumerState<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends ConsumerState<CreateTaskSheet> {
  final _titleCtrl = TextEditingController();
  DateTime? _dueDate = _todayOnly();

  String _categoryId = 'Geral';

  TaskPriority _priority = TaskPriority.medium;

  static const List<String> _categories = [
    'Geral',
    'Trabalho',
    'Pessoal',
    'Estudos',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  void _clearDate() => setState(() => _dueDate = null);

  String _priorityLabel(TaskPriority p) {
    switch (p) {
      case TaskPriority.low:
        return 'Baixa';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      AppSnackBar.show(context, 'Digite um título');
      return;
    }

    await ref
        .read(tasksProvider.notifier)
        .createTask(
          title: title,
          dueDate: _dueDate,
          categoryId: _categoryId,
          priority: _priority,
        );

    final dateLabel = _dueDate == null
        ? 'Sem data'
        : DateFormatter.shortPtBr(_dueDate!);

    AppSnackBar.show(
      context,
      'Tarefa criada: "$title" • $_categoryId • ${_priorityLabel(_priority)} • $dateLabel ✅',
    );

    if (mounted) Navigator.of(context).pop();
  }

  Widget _chip({
    required ThemeData theme,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Gaps.h12,

            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Nova tarefa',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Gaps.h8,

            // Título
            TextField(
              controller: _titleCtrl,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ex: Beber água, Estudar 30min...',
                border: OutlineInputBorder(),
              ),
            ),

            // ✅ Prioridade (enum)
            Gaps.h12,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Prioridade',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Gaps.h8,
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(
                    theme: theme,
                    label: 'Baixa',
                    selected: _priority == TaskPriority.low,
                    onTap: () => setState(() => _priority = TaskPriority.low),
                  ),
                  _chip(
                    theme: theme,
                    label: 'Média',
                    selected: _priority == TaskPriority.medium,
                    onTap: () =>
                        setState(() => _priority = TaskPriority.medium),
                  ),
                  _chip(
                    theme: theme,
                    label: 'Alta',
                    selected: _priority == TaskPriority.high,
                    onTap: () => setState(() => _priority = TaskPriority.high),
                  ),
                ],
              ),
            ),

            // ✅ Categoria
            Gaps.h12,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categoria',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Gaps.h8,
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories
                    .map(
                      (c) => _chip(
                        theme: theme,
                        label: c,
                        selected: _categoryId == c,
                        onTap: () => setState(() => _categoryId = c),
                      ),
                    )
                    .toList(),
              ),
            ),

            // Data + salvar
            Gaps.h12,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text(
                      _dueDate == null
                          ? 'Sem data'
                          : 'Data: ${DateFormatter.shortPtBr(_dueDate!)}',
                    ),
                  ),
                ),
                if (_dueDate != null) ...[
                  Gaps.w8,
                  IconButton(
                    onPressed: _clearDate,
                    tooltip: 'Remover data',
                    icon: const Icon(Icons.close),
                  ),
                ],
                Gaps.w12,
                ElevatedButton(onPressed: _save, child: const Text('Salvar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import './quick_tile.dart';

class QuickGrid extends StatelessWidget  {
  final VoidCallback onAddTask;
  final VoidCallback onAddHabit;
  final VoidCallback onCategories;
  final VoidCallback onInsights;

  const QuickGrid({
    super.key,
    required this.onAddTask,
    required this.onAddHabit,
    required this.onCategories,
    required this.onInsights,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              QuickTile(
                icon: Icons.add_task_rounded,
                title: 'Nova tarefa',
                subtitle: 'Crie rapidinho',
                onTap: onAddTask,
              ),
              const SizedBox(height: 10),
              QuickTile(
                icon: Icons.category_outlined,
                title: 'Categorias',
                subtitle: 'Organize tudo',
                onTap: onCategories,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              QuickTile(
                icon: Icons.repeat_rounded,
                title: 'Novo hábito',
                subtitle: 'Constância',
                onTap: onAddHabit,
              ),
              const SizedBox(height: 10),
              QuickTile(
                icon: Icons.insights_outlined,
                title: 'Insights',
                subtitle: 'Seu progresso',
                onTap: onInsights,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

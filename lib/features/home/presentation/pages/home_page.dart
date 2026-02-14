import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky_app/core/utils/ui/gaps.dart';
import 'package:tasky_app/features/home/presentation/providers/home_filtered_tasks_provider.dart';
import 'package:tasky_app/features/home/presentation/widgets/create_task_sheet.dart';
import 'package:tasky_app/features/home/presentation/widgets/empty_state.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_card.dart';
import 'package:tasky_app/features/tasks/application/providers/tasks_providers.dart';
import 'package:tasky_app/features/tasks/data/models/task_model.dart';

import '../../../../core/utils/ui/app_snackbar.dart';
import '../../../../core/formatters/date_formatter.dart';
import '../widgets/focus_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/quick_grid.dart';
import '../widgets/scope_chip.dart';
import '../providers/home_scope_provider.dart';
import '../../../tasks/domain/task_scope.dart';
import '../../../tasks/application/providers/task_focus_provider.dart';
import '../../../tasks/application/providers/task_summary_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _openCreateTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateTaskSheet(),
    );
  }

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final summary = ref.watch(taskSummaryProvider);
    final focus = ref.watch(taskFocusProvider);

    final scope = ref.watch(homeScopeProvider);
    final filtered = ref.watch(homeFilteredTasksProvider);

    final dateLabel = DateFormatter.shortPtBr(DateTime.now());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            dateLabel: dateLabel,
            doneCount: summary.doneCount,
            totalCount: summary.totalCount,
            progress: summary.progress,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FocusCard(
                      title: focus.title,
                      subtitle: focus.subtitle,
                      tag: focus.tag,
                      done: focus.done,
                      progress: summary.progress,
                      onPrimary: () =>
                          AppSnackBar.show(context, 'Iniciar foco (UI) ✅'),
                      onSecondary: () =>
                          AppSnackBar.show(context, 'Marcar como feita (UI) ✅'),
                    ),
                    Gaps.h14,
                    QuickGrid(
                      onAddTask: () => _openCreateTaskSheet(context),
                      onAddHabit: () =>
                          AppSnackBar.show(context, 'Adicionar hábito (UI) ✅'),
                      onCategories: () =>
                          AppSnackBar.show(context, 'Categorias (UI) ✅'),
                      onInsights: () =>
                          AppSnackBar.show(context, 'Insights (UI) ✅'),
                    ),
                    Gaps.h16,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sua lista',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Gaps.h12,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ScopeChip(
                                label: 'Todas',
                                selected: scope == TaskScope.all,
                                onTap: () => ref
                                    .read(homeScopeProvider.notifier)
                                    .setScope(TaskScope.all),
                              ),
                              Gaps.w12,
                              ScopeChip(
                                label: 'Hoje',
                                selected: scope == TaskScope.today,
                                onTap: () => ref
                                    .read(homeScopeProvider.notifier)
                                    .setScope(TaskScope.today),
                              ),
                              Gaps.w12,
                              ScopeChip(
                                label: 'Atrasadas',
                                selected: scope == TaskScope.overdue,
                                onTap: () => ref
                                    .read(homeScopeProvider.notifier)
                                    .setScope(TaskScope.overdue),
                              ),
                              Gaps.w12,
                              ScopeChip(
                                label: 'Próximas',
                                selected: scope == TaskScope.upcoming,
                                onTap: () => ref
                                    .read(homeScopeProvider.notifier)
                                    .setScope(TaskScope.upcoming),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Gaps.h16,
                    if (filtered.isEmpty)
                      EmptyState(
                        title: 'Tudo limpo por aqui ✨',
                        subtitle: 'Nenhuma tarefa para este filtro.',
                        onAction: () => _openCreateTaskSheet(context),
                      )
                    else
                      ...filtered.map((task) {
                        final dueLabel = task.dueDate == null
                            ? 'Sem data'
                            : DateFormatter.shortPtBr(task.dueDate!);

                        final category = task.categoryId ?? 'Geral';
                        final priority = _priorityLabel(task.priority);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TaskCard(
                            title: task.title,
                            subtitle: '$category • $priority • $dueLabel',
                            tag: category,
                            done: task.isDone,
                            onTap: () => AppSnackBar.show(
                              context,
                              'Abrir tarefa (UI) ✅',
                            ),
                            onToggle: () => ref
                                .read(tasksProvider.notifier)
                                .toggleDone(task.id),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

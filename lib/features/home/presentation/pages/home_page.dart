import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky_app/core/utils/ui/gaps.dart';
import 'package:tasky_app/features/home/presentation/providers/home_filtered_tasks_provider.dart';
import 'package:tasky_app/features/home/presentation/widgets/empty_state.dart';
import 'package:tasky_app/features/home/presentation/widgets/task_card.dart';
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
import '../../../tasks/application/presenters/task_presenter.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

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
                      onAddTask: () =>
                          AppSnackBar.show(context, 'Adicionar tarefa (UI) ✅'),
                      onAddHabit: () =>
                          AppSnackBar.show(context, 'Adicionar hábito (UI) ✅'),
                      onCategories: () =>
                          AppSnackBar.show(context, 'Categorias (UI) ✅'),
                      onInsights: () =>
                          AppSnackBar.show(context, 'Insights (UI) ✅'),
                    ),
                    Gaps.h16,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sua lista',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        ScopeChip(
                          label: 'Hoje',
                          selected: scope == TaskScope.today,
                          onTap: () => ref
                              .read(homeScopeProvider.notifier)
                              .setScope(TaskScope.today),
                        ),
                        Gaps.h16,
                        ScopeChip(
                          label: 'Atrasadas',
                          selected: scope == TaskScope.overdue,
                          onTap: () => ref
                              .read(homeScopeProvider.notifier)
                              .setScope(TaskScope.overdue),
                        ),
                        Gaps.h16,
                        ScopeChip(
                          label: 'Próximas',
                          selected: scope == TaskScope.upcoming,
                          onTap: () => ref
                              .read(homeScopeProvider.notifier)
                              .setScope(TaskScope.upcoming),
                        ),
                      ],
                    ),

                    Gaps.h16,
                    if (filtered.isEmpty)
                      EmptyState(
                        title: 'Tudo limpo por aqui ✨',
                        subtitle: 'Nenhuma tarefa para este filtro.',
                        onAction: () => AppSnackBar.show(context, 'Criar tarefa (UI) ✅'),
                      )
                    else
                      ...filtered.map((task) {
                        final p = presentTask(task);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TaskCard(
                            title: p.title,
                            subtitle: p.subtitle,
                            tag: p.tag,
                            done: p.done,
                            onTap: () => AppSnackBar.show(context, 'Abrir tarefa (UI) ✅'),
                            onToggle: () => AppSnackBar.show(context, 'Toggle (UI) ✅'),
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

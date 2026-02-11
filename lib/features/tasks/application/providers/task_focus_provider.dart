import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/task_model.dart';
import 'mock_tasks_provider.dart';

class TaskFocusPresentation {
  final String title;
  final String subtitle;
  final String tag;
  final bool done;

  const TaskFocusPresentation({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.done,
  });
}

final taskFocusProvider = Provider<TaskFocusPresentation>((ref) {
  final tasks = ref.watch(mockTasksProvider);

  // primeira não concluída como "foco"
  final focus = tasks.where((t) => !t.isDone).cast<TaskModel?>().firstWhere(
        (t) => t != null,
        orElse: () => null,
      );

  if (focus == null) {
    return const TaskFocusPresentation(
      title: 'Tudo certo por aqui ✅',
      subtitle: 'Sem tarefas pendentes agora',
      tag: 'OK',
      done: true,
    );
  }

  // apresentação simples (depois você pode enriquecer)
  final priorityTag = switch (focus.priority) {
    TaskPriority.high => 'ALTA',
    TaskPriority.medium => 'MÉDIA',
    TaskPriority.low => 'BAIXA',
  };

  return TaskFocusPresentation(
    title: focus.title,
    subtitle: focus.dueDate == null ? 'Sem prazo definido' : 'Tem prazo definido',
    tag: priorityTag,
    done: focus.isDone,
  );
});

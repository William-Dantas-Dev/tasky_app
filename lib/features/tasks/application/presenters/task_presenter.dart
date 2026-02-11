import '../../data/models/task_model.dart';

class TaskPresentation {
  final String title;
  final String subtitle;
  final String tag;
  final bool done;

  const TaskPresentation({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.done,
  });
}

TaskPresentation presentTask(TaskModel task) {
  final tag = switch (task.priority) {
    TaskPriority.high => 'ALTA',
    TaskPriority.medium => 'MÉDIA',
    TaskPriority.low => 'BAIXA',
  };

  final subtitle = task.dueDate == null
      ? 'Sem prazo'
      : 'Prazo: ${task.dueDate!.day.toString().padLeft(2, '0')}/${task.dueDate!.month.toString().padLeft(2, '0')}';

  return TaskPresentation(
    title: task.title,
    subtitle: subtitle,
    tag: tag,
    done: task.isDone,
  );
}

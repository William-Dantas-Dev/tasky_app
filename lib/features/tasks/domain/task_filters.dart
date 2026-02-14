import '../data/models/task_model.dart';
import '../../../core/utils/date_utils.dart';
import 'task_scope.dart';

List<TaskModel> filterTasksByScope(List<TaskModel> tasks, TaskScope scope) {
  final now = DateTime.now();
  final today = startOfDay(now);
  final tomorrow = today.add(const Duration(days: 1));

  bool isToday(DateTime? d) => d != null && !d.isBefore(today) && d.isBefore(tomorrow);
  bool isOverdue(DateTime? d) => d != null && d.isBefore(today);
  bool isUpcoming(DateTime? d) => d != null && !d.isBefore(tomorrow);

  switch (scope) {
    case TaskScope.all:
      return tasks.where((t) => !t.isDone).toList();
    case TaskScope.today:
      return tasks.where((t) => !t.isDone && isToday(t.dueDate)).toList();
    case TaskScope.overdue:
      return tasks.where((t) => !t.isDone && isOverdue(t.dueDate)).toList();
    case TaskScope.upcoming:
      return tasks.where((t) => !t.isDone && isUpcoming(t.dueDate)).toList();
  }
}

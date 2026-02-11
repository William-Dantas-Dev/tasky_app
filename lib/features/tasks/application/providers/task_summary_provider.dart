import 'package:flutter_riverpod/flutter_riverpod.dart';
import './mock_tasks_provider.dart';

class TaskSummary {
  final int doneCount;
  final int totalCount;
  final double progress; // 0..1

  const TaskSummary({
    required this.doneCount,
    required this.totalCount,
    required this.progress,
  });
}

final taskSummaryProvider = Provider<TaskSummary>((ref) {
  final tasks = ref.watch(mockTasksProvider);

  final doneCount = tasks.where((t) => t.isDone).length;
  final totalCount = tasks.length;
  final progress = totalCount == 0 ? 0.0 : doneCount / totalCount;

  return TaskSummary(
    doneCount: doneCount,
    totalCount: totalCount,
    progress: progress,
  );
});

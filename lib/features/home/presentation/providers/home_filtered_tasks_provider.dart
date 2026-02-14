import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/domain/task_filters.dart';
import '../../../tasks/application/providers/tasks_providers.dart';
import 'home_scope_provider.dart';

final homeFilteredTasksProvider = Provider<List<TaskModel>>((ref) {
  final raw = ref.watch(tasksProvider); // ✅ vem do Hive (List<Map<String, dynamic>>)
  final scope = ref.watch(homeScopeProvider);

  // Converte Map -> TaskModel
  final tasks = raw.map(TaskModel.fromMap).toList();

  // Reaproveita sua regra de filtro atual
  return filterTasksByScope(tasks, scope);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/domain/task_filters.dart';
import '../../../tasks/application/providers/mock_tasks_provider.dart';
import 'home_scope_provider.dart';

final homeFilteredTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(mockTasksProvider);
  final scope = ref.watch(homeScopeProvider);

  return filterTasksByScope(tasks, scope);
});

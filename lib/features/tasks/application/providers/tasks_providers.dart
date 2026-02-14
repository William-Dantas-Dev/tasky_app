import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';

final tasksBoxProvider = Provider<Box<Map>>((ref) {
  return Hive.box<Map>('tasksBox');
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final box = ref.watch(tasksBoxProvider);
  return TaskRepositoryImpl(box);
});

final tasksProvider =
    NotifierProvider<TasksController, List<Map<String, dynamic>>>(
  TasksController.new,
);

class TasksController extends Notifier<List<Map<String, dynamic>>> {
  late final TaskRepository repo;

  @override
  List<Map<String, dynamic>> build() {
    repo = ref.read(taskRepositoryProvider);
    return _sorted(repo.getAll());
  }

  void reload() {
    state = _sorted(repo.getAll());
  }

  List<Map<String, dynamic>> _sorted(List<Map<String, dynamic>> items) {
    // Ordenação simples: pendentes primeiro, depois por dueDate (se tiver), depois por createdAt
    items.sort((a, b) {
      final ad = (a['isDone'] as bool?) ?? false;
      final bd = (b['isDone'] as bool?) ?? false;
      if (ad != bd) return ad ? 1 : -1;

      final aDue = a['dueDate'] as String?;
      final bDue = b['dueDate'] as String?;
      final aDueDt = (aDue == null) ? null : DateTime.tryParse(aDue);
      final bDueDt = (bDue == null) ? null : DateTime.tryParse(bDue);

      if (aDueDt == null && bDueDt != null) return 1;
      if (aDueDt != null && bDueDt == null) return -1;
      if (aDueDt != null && bDueDt != null) {
        final cmp = aDueDt.compareTo(bDueDt);
        if (cmp != 0) return cmp;
      }

      final aCreated = DateTime.tryParse((a['createdAt'] as String?) ?? '');
      final bCreated = DateTime.tryParse((b['createdAt'] as String?) ?? '');
      if (aCreated != null && bCreated != null) {
        return aCreated.compareTo(bCreated);
      }

      return 0;
    });

    return items;
  }

  Future<void> createTask({
    required String title,
    DateTime? dueDate,
    String categoryId = 'Geral',
    TaskPriority priority = TaskPriority.medium,
    String userId = 'local',
    String? description,
  }) async {
    final now = DateTime.now();
    final id = const Uuid().v4();

    final task = TaskModel(
      id: id,
      userId: userId,
      title: title,
      description: description,
      isDone: false,
      priority: priority,
      categoryId: categoryId, // por enquanto: nome da categoria
      dueDate: dueDate,
      createdAt: now,
      updatedAt: now,
    );

    await repo.upsert(id, task.toMap());
    reload();
  }

  Future<void> toggleDone(String id) async {
    final raw = repo.getById(id);
    if (raw == null) return;

    final model = TaskModel.fromMap(raw);
    final updated = model.copyWith(
      isDone: !model.isDone,
      updatedAt: DateTime.now(),
    );

    await repo.upsert(id, updated.toMap());
    reload();
  }

  Future<void> deleteTask(String id) async {
    await repo.delete(id);
    reload();
  }
}

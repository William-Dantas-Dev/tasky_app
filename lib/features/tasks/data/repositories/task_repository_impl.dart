import 'package:hive/hive.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Box<Map> box;

  TaskRepositoryImpl(this.box);

  @override
  List<Map<String, dynamic>> getAll() {
    return box.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Map<String, dynamic>? getById(String id) {
    final data = box.get(id);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<void> upsert(String id, Map<String, dynamic> data) async {
    await box.put(id, data);
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }
}

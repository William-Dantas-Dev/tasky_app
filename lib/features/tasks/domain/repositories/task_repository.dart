abstract class TaskRepository {
  List<Map<String, dynamic>> getAll();

  Map<String, dynamic>? getById(String id);

  Future<void> upsert(String id, Map<String, dynamic> data);

  Future<void> delete(String id);
}

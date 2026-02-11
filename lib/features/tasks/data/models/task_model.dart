enum TaskPriority { low, medium, high }

TaskPriority taskPriorityFromString(String? value) {
  switch ((value ?? '').toLowerCase()) {
    case 'low':
      return TaskPriority.low;
    case 'high':
      return TaskPriority.high;
    case 'medium':
    default:
      return TaskPriority.medium;
  }
}

String taskPriorityToString(TaskPriority p) {
  switch (p) {
    case TaskPriority.low:
      return 'low';
    case TaskPriority.medium:
      return 'medium';
    case TaskPriority.high:
      return 'high';
  }
}

DateTime? _dateFromIso(dynamic value) {
  if (value == null) return null;
  if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
  return null;
}

String? _dateToIso(DateTime? value) => value?.toIso8601String();

class TaskModel {
  final String id;
  final String userId;

  final String title;
  final String? description;

  final bool isDone;
  final TaskPriority priority;

  final String? categoryId;
  final DateTime? dueDate;

  final DateTime createdAt;
  final DateTime updatedAt;

  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.isDone,
    required this.priority,
    this.categoryId,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  static const _unset = Object();

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    Object? description = _unset,
    bool? isDone,
    TaskPriority? priority,
    Object? categoryId = _unset,
    Object? dueDate = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: identical(description, _unset)
          ? this.description
          : description as String?,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      categoryId: identical(categoryId, _unset)
          ? this.categoryId
          : categoryId as String?,
      dueDate: identical(dueDate, _unset) ? this.dueDate : dueDate as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'isDone': isDone,
      'priority': taskPriorityToString(priority),
      'categoryId': categoryId,
      'dueDate': _dateToIso(dueDate),
      'createdAt': _dateToIso(createdAt),
      'updatedAt': _dateToIso(updatedAt),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final created = _dateFromIso(map['createdAt']) ?? DateTime.now();
    final updated = _dateFromIso(map['updatedAt']) ?? created;

    return TaskModel(
      id: (map['id'] ?? '') as String,
      userId: (map['userId'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      description: map['description'] as String?,
      isDone: (map['isDone'] ?? false) as bool,
      priority: taskPriorityFromString(map['priority'] as String?),
      categoryId: map['categoryId'] as String?,
      dueDate: _dateFromIso(map['dueDate']),
      createdAt: created,
      updatedAt: updated,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task_model.dart';

final mockTasksProvider = Provider<List<TaskModel>>((ref) {
  final now = DateTime.now();

  return [
    TaskModel(
      id: '1',
      userId: 'mock-user',
      title: 'Estudar Flutter 40min',
      description: null,
      isDone: false,
      priority: TaskPriority.high,
      categoryId: null,
      dueDate: now,
      createdAt: now,
      updatedAt: now,
    ),
    TaskModel(
      id: '2',
      userId: 'mock-user',
      title: 'Treino + cardio',
      description: null,
      isDone: true,
      priority: TaskPriority.medium,
      categoryId: null,
      dueDate: now,
      createdAt: now,
      updatedAt: now,
    ),
    TaskModel(
      id: '3',
      userId: 'mock-user',
      title: 'Pagar internet',
      description: null,
      isDone: false,
      priority: TaskPriority.high,
      categoryId: null,
      dueDate: now.subtract(const Duration(days: 1)),
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now,
    ),
    TaskModel(
      id: '4',
      userId: 'mock-user',
      title: 'Organizar categorias',
      description: null,
      isDone: false,
      priority: TaskPriority.low,
      categoryId: null,
      dueDate: now.add(const Duration(days: 1)),
      createdAt: now,
      updatedAt: now,
    ),
  ];
});

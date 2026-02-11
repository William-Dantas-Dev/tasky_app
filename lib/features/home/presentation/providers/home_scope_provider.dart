import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../tasks/domain/task_scope.dart';

class HomeScopeNotifier extends Notifier<TaskScope> {
  @override
  TaskScope build() => TaskScope.today;

  void setScope(TaskScope scope) => state = scope;
}

final homeScopeProvider =
    NotifierProvider<HomeScopeNotifier, TaskScope>(HomeScopeNotifier.new);

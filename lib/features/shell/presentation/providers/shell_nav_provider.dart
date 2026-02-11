import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellNavNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;

  void goHome() => state = 0;
  void goTasks() => state = 1;
  void goHabits() => state = 2;
  void goSettings() => state = 3;
}

final shellIndexProvider =
    NotifierProvider<ShellNavNotifier, int>(ShellNavNotifier.new);

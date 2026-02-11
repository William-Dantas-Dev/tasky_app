import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shell_nav_provider.dart';

class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key});

  static const List<Widget> _pages = [
    _ShellPlaceholderPage(title: 'Home'),
    _ShellPlaceholderPage(title: 'Tarefas'),
    _ShellPlaceholderPage(title: 'Hábitos'),
    _ShellPlaceholderPage(title: 'Config'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(shellIndexProvider);

    return Scaffold(
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => ref.read(shellIndexProvider.notifier).setIndex(i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.repeat_rounded),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Config',
          ),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Criar tarefa (UI) ✅'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _ShellPlaceholderPage extends StatelessWidget {
  final String title;

  const _ShellPlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const SizedBox.expand(child: ColoredBox(color: Colors.transparent)),
    );
  }
}

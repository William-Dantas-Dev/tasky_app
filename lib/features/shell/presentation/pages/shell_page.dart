import 'package:flutter/material.dart';

import '../../../../core/shared/widgets/custom_app_bar/custom_app_bar.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int currentIndex = 0;

  final pages = const [
    Center(child: Text('Home')),
    Center(child: Text('Tarefas')),
    Center(child: Text('Perfil')),
    Center(child: Text('Configurações')),
  ];

  final titles = const ['Início', 'Tarefas', 'Perfil', 'Configurações'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),

          // Melhor que SliverToBoxAdapter pra segurar layout/altura do conteúdo
          SliverFillRemaining(
            hasScrollBody: true,
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),
        ],
      ),

      // FAB central
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Criar/Adicionar!')),
          );
        },
        child: const Icon(Icons.add),
      ),

      // Bottom com notch
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _iconBtn(Icons.home_outlined, 0),
              _iconBtn(Icons.checklist_outlined, 1),
              const SizedBox(width: 48),
              _iconBtn(Icons.person_outline, 2),
              _iconBtn(Icons.settings_outlined, 3),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ AppBar global (varia por aba)
  Widget _buildAppBar() {
    switch (currentIndex) {
      case 0:
        // Home usa seu CustomAppBar
        return CustomAppBar(
          dateLabel: "Home Page",
          doneCount: 10,
          totalCount: 20,
          progress: 2,
        );

      case 1:
        // Tarefas com ações
        return SliverAppBar(
          pinned: true,
          title: Text(titles[currentIndex]),
          actions: [
            IconButton(
              tooltip: 'Buscar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buscar tarefas')),
                );
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              tooltip: 'Filtrar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filtro')),
                );
              },
              icon: const Icon(Icons.tune),
            ),
          ],
        );

      case 2:
        return SliverAppBar(
          pinned: true,
          title: Text(titles[currentIndex]),
        );

      case 3:
        return SliverAppBar(
          pinned: true,
          title: Text(titles[currentIndex]),
        );

      default:
        return const SliverAppBar(
          pinned: true,
          title: Text(''),
        );
    }
  }

  Widget _iconBtn(IconData icon, int index) {
    final selected = currentIndex == index;
    final color = selected ? Theme.of(context).colorScheme.primary : null;

    return IconButton(
      onPressed: () => setState(() => currentIndex = index),
      icon: Icon(icon),
      color: color,
      tooltip: titles[index],
    );
  }
}

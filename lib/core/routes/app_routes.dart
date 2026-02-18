import 'package:flutter/material.dart';
import '../../features/shell/presentation/pages/shell_page.dart';

class AppRoutes {
  static const String shell = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case shell:
        return MaterialPageRoute(builder: (_) => const ShellPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.shell,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

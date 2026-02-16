import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/app_theme.dart';
import 'package:elara/config/routes.dart';
import 'package:flutter/material.dart';

<<<<<<< Updated upstream
=======
import 'package:elara/config/dependency_injection.dart';

>>>>>>> Stashed changes
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  runApp(const Elara());
}

class Elara extends StatelessWidget {
  const Elara({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elara',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

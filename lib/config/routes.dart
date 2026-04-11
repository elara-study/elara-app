import 'package:elara/features/auth/presentation/views/sign_in_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_credentials_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_role_screen.dart';
import 'package:elara/features/auth/presentation/views/splash_screen.dart';
import 'package:elara/features/student/presentation/views/student_shell.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signUpRole = '/register/role';
  static const String signUpCredentials = '/register/credentials';

  /// Student dashboard — the temporary post-auth landing screen.
  /// TODO: Replace with a role-based router once Teacher/Parent dashboards exist.
  static const String studentDashboard = '/student';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case signUpRole:
        return MaterialPageRoute(builder: (_) => const SignUpRoleScreen());

      case signUpCredentials:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SignUpCredentialsScreen(),
        );

      case studentDashboard:
        return MaterialPageRoute(builder: (_) => const StudentShell());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:elara/features/student/group/presentation/views/student_group_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String studentGroup = '/student-group';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Splash Screen'))),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Home Screen'))),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Login Screen'))),
        );
      case studentGroup:
        final args = settings.arguments;
        final groupId = args is String ? args : 'demo-group';

        return MaterialPageRoute(
          builder: (_) => StudentGroupPage(groupId: groupId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

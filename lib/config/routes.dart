import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/presentation/views/sign_in_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_credentials_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_role_screen.dart';
import 'package:elara/features/auth/presentation/views/splash_screen.dart';
import 'package:elara/features/student/group/presentation/views/student_group_page.dart';
import 'package:elara/features/student/quiz/presentation/quiz_route_args.dart';
import 'package:elara/features/student/quiz/presentation/views/quiz_flow_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String studentGroup = '/student-group';
  static const String signUpRole = '/register/role';
  static const String signUpCredentials = '/register/credentials';

  /// Full quiz flow (MCQ → written → results) with [QuizCubit].
  static const String quiz = '/quiz';

  static const String demoGroupId = 'demo-group';

  static void navigateAfterAuth(BuildContext context, UserEntity user) {
    switch (user.role) {
      case UserRole.student:
        Navigator.of(context).pushNamedAndRemoveUntil(
          studentGroup,
          (_) => false,
          arguments: demoGroupId,
        );
      case UserRole.teacher:
      case UserRole.parent:
        Navigator.of(context).pushNamedAndRemoveUntil(home, (_) => false);
    }
  }

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

      case home:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Home Screen'))),
        );

      case studentGroup:
        final args = settings.arguments;
        final groupId = args is String ? args : demoGroupId;
        return MaterialPageRoute(
          builder: (_) => StudentGroupPage(groupId: groupId),
        );

      case quiz:
        final args = settings.arguments;
        final resolved = args is QuizRouteArgs
            ? args
            : const QuizRouteArgs(quizId: 'demo-quiz');
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QuizFlowPage.fromArgs(resolved),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/presentation/views/sign_in_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_credentials_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_role_screen.dart';
import 'package:elara/features/student/presentation/views/student_shell.dart';
import 'package:elara/features/student/group/presentation/views/student_group_page.dart';
import 'package:elara/features/student/quiz/presentation/quiz_route_args.dart';
import 'package:elara/features/student/homework/presentation/homework_route_args.dart';
import 'package:elara/features/student/homework/presentation/views/homework_screen.dart';
import 'package:elara/features/student/quiz/presentation/views/quiz_flow_page.dart';
import 'package:elara/features/teacher/presentation/views/teacher_shell.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String studentGroup = '/student-group';
  static const String signUpRole = '/register/role';
  static const String signUpCredentials = '/register/credentials';

  /// Student dashboard — the temporary post-auth landing screen.
  ///  : Replace with a role-based router once Teacher/Parent dashboards exist.
  static const String studentDashboard = '/student';

  /// Full quiz flow (MCQ → written → results) with [QuizCubit].
  static const String quiz = '/quiz';

  /// Homework assignment screen (navigated from module sheet).
  static const String homework = '/homework';

  static const String demoGroupId = 'demo-group';

  static const String home = '/home';

  /// Teacher dashboard shell.
  static const String teacherDashboard = '/teacher';

  /// Placeholder until Parent dashboard exists.
  static const String comingSoonDashboard = '/coming-soon-dashboard';

  static void navigateAfterAuth(BuildContext context, UserEntity user) {
    switch (user.role) {
      case UserRole.student:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(studentDashboard, (_) => false);
      case UserRole.teacher:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(teacherDashboard, (_) => false);
      case UserRole.parent:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(comingSoonDashboard, (_) => false);
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        // Temporarily bypassing splash/auth for testing
        return MaterialPageRoute(builder: (_) => const TeacherShell());
        // return MaterialPageRoute(builder: (_) => const SplashScreen());

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
      case home:
        return MaterialPageRoute(builder: (_) => const StudentShell());

      case teacherDashboard:
        return MaterialPageRoute(builder: (_) => const TeacherShell());

      case comingSoonDashboard:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Dashboard coming soon')),
          ),
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

      case homework:
        final hwArgs = settings.arguments;
        final resolvedHw = hwArgs is HomeworkRouteArgs
            ? hwArgs
            : const HomeworkRouteArgs(homeworkId: 'demo-homework');
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomeworkScreen.fromArgs(resolvedHw),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

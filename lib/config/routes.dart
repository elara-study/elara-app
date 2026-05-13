import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/views/sign_in_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_credentials_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_role_screen.dart';
import 'package:elara/features/auth/presentation/views/splash_screen.dart';
import 'package:elara/features/parent/presentation/home/views/parent_shell.dart';
import 'package:elara/features/student/presentation/dashboard/views/student_shell.dart';
import 'package:elara/features/student/presentation/group/views/student_group_page.dart';
import 'package:elara/features/student/presentation/quiz/quiz_route_args.dart';
import 'package:elara/features/student/presentation/homework/homework_route_args.dart';
import 'package:elara/features/student/presentation/homework/views/homework_screen.dart';
import 'package:elara/features/student/presentation/quiz/views/quiz_flow_page.dart';
import 'package:elara/features/teacher/presentation/views/teacher_shell.dart';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/student/presentation/chatbot/chatbot_route_args.dart';
import 'package:elara/features/student/presentation/chatbot/cubits/chatbot_cubit.dart';
import 'package:elara/features/student/presentation/chatbot/cubits/sessions_cubit.dart';
import 'package:elara/features/student/presentation/chatbot/views/chatbot_screen.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_settings_cubit.dart';
import 'package:elara/features/student/presentation/profile/views/student_settings_screen.dart';
import 'package:elara/features/settings/presentation/cubits/notifications_settings_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/password_security_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/profile_account_cubit.dart';
import 'package:elara/features/settings/presentation/views/notifications_settings_screen.dart';
import 'package:elara/features/settings/presentation/views/password_security_screen.dart';
import 'package:elara/features/settings/presentation/views/profile_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  /// Chatbot — conversation thread.
  static const String chatbot = '/chatbot';

  /// Student — settings (shared UI shell; content varies by role later).
  static const String studentSettings = '/student/settings';

  /// Shared settings detail screens (student / teacher / parent).
  static const String profileAccount = '/settings/profile-account';
  static const String passwordSecurity = '/settings/password-security';
  static const String notificationsSettings = '/settings/notifications';

  static const String demoGroupId = 'demo-group';

  static const String home = '/home';

  /// Teacher dashboard shell.
  static const String teacherDashboard = '/teacher';

  /// Parent dashboard shell (Home tab matches Figma parent Home).
  static const String parentDashboard = '/parent';

  /// Placeholder for roles without a full dashboard yet.
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
        ).pushNamedAndRemoveUntil(parentDashboard, (_) => false);
    }
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        // TEST BYPASS — revert before p
        return MaterialPageRoute(builder: (_) => const ParentShell());

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
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const StudentShell(),
        );

      case teacherDashboard:
        return MaterialPageRoute(builder: (_) => const TeacherShell());

      case parentDashboard:
        return MaterialPageRoute(builder: (_) => const ParentShell());

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

      case studentSettings:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                StudentSettingsCubit(authCubit: context.read<AuthCubit>()),
            child: const StudentSettingsScreen(),
          ),
        );

      case profileAccount:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileAccountCubit>()..loadProfile(),
            child: const ProfileAccountScreen(),
          ),
        );

      case passwordSecurity:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PasswordSecurityCubit(),
            child: const PasswordSecurityScreen(),
          ),
        );

      case notificationsSettings:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => NotificationsSettingsCubit(),
            child: const NotificationsSettingsScreen(),
          ),
        );

      case chatbot:
        final aiArgs = settings.arguments;
        final resolvedAi = aiArgs is ChatbotRouteArgs
            ? aiArgs
            : const ChatbotRouteArgs();
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ChatbotCubit>(create: (_) => getIt<ChatbotCubit>()),
              BlocProvider<SessionsCubit>(
                create: (_) => getIt<SessionsCubit>(),
              ),
            ],
            child: ChatbotScreen(routeArgs: resolvedAi),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

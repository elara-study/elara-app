import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/views/sign_in_screen.dart';
import 'package:elara/features/auth/presentation/views/splash_screen.dart';
import 'package:elara/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:elara/features/auth/presentation/views/forgot_password_screen.dart';
import 'package:elara/features/auth/presentation/views/otp_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_credentials_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_role_screen.dart';
import 'package:elara/features/parent/presentation/home/views/parent_shell.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_profile_page.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_homework_page.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_insights_page.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_homework_route_args.dart';
import 'package:elara/features/parent/presentation/profile/views/parent_settings_screen.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/notifications_settings_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/password_security_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/profile_account_cubit.dart';
import 'package:elara/features/settings/presentation/views/notifications_settings_screen.dart';
import 'package:elara/features/settings/presentation/views/password_security_screen.dart';
import 'package:elara/features/settings/presentation/views/profile_account_screen.dart';
import 'package:elara/features/student/presentation/chatbot/chatbot_route_args.dart';
import 'package:elara/features/student/presentation/chatbot/cubits/chatbot_cubit.dart';
import 'package:elara/features/student/presentation/chatbot/cubits/sessions_cubit.dart';
import 'package:elara/features/student/presentation/chatbot/views/chatbot_screen.dart';
import 'package:elara/features/student/presentation/dashboard/views/student_shell.dart';
import 'package:elara/features/student/presentation/group/views/student_group_page.dart';
import 'package:elara/features/student/presentation/homework/homework_route_args.dart';
import 'package:elara/features/student/presentation/homework/views/homework_screen.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_settings_cubit.dart';
import 'package:elara/features/student/presentation/profile/views/student_settings_screen.dart';
import 'package:elara/features/student/presentation/quiz/quiz_route_args.dart';
import 'package:elara/features/student/presentation/quiz/views/quiz_flow_page.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/group/presentation/views/teacher_group_page.dart';
import 'package:elara/features/teacher/homework/presentation/route_args/teacher_module_route_args.dart';
import 'package:elara/features/teacher/homework/presentation/views/teacher_homework_screen.dart';
import 'package:elara/features/teacher/homework/presentation/views/teacher_resources_screen.dart';
import 'package:elara/features/teacher/group/presentation/views/teacher_student_profile_page.dart';
import 'package:elara/features/teacher/group/presentation/views/teacher_student_profile_route_args.dart';
import 'package:elara/features/teacher/group/presentation/views/attendance_history_screen.dart';
import 'package:elara/features/teacher/group/presentation/views/attendance_history_route_args.dart';
import 'package:elara/features/teacher/presentation/views/teacher_shell.dart';
import 'package:elara/config/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String studentGroup = '/student-group';
  static const String signUpRole = '/register/role';
  static const String signUpSocialRole = '/register/social-role';
  static const String signUpCredentials = '/register/credentials';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';

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
  static const String parentSettings = '/parent/settings';

  /// Shared settings detail screens (student / teacher / parent).
  static const String profileAccount = '/settings/profile-account';
  static const String passwordSecurity = '/settings/password-security';
  static const String notificationsSettings = '/settings/notifications';

  static const String demoGroupId = 'demo-group';

  static const String home = '/home';

  /// Teacher dashboard shell.
  static const String teacherDashboard = '/teacher';

  /// Teacher group detail screen.
  static const String teacherGroup = '/teacher-group';

  /// Teacher's view of student profile.
  static const String teacherStudentProfile = '/teacher/student-profile';

  /// Teacher's group attendance history.
  static const String attendanceHistory = '/teacher/attendance-history';

  /// Teacher homework management for a specific module.
  static const String teacherModuleHomework = '/teacher/module-homework';

  /// Teacher resources management for a specific module.
  static const String teacherModuleResources = '/teacher/module-resources';

  /// Parent dashboard shell (Home tab matches Figma parent Home).
  static const String parentDashboard = '/parent';

  /// Detailed parent child profile screen.
  static const String parentChildProfile = '/parent/child-profile';

  /// Parent child homework "See All" screen.
  static const String parentChildHomework = '/parent/child-homework';
  static const String parentChildInsights = '/parent/child-insights';

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
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());

      case login:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case otp:
        final otpArgs = settings.arguments;
        if (otpArgs is OtpRouteArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => OtpScreen(args: otpArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('OTP arguments not provided')),
          ),
        );

      case signUpRole:
        return MaterialPageRoute(builder: (_) => const SignUpRoleScreen());

      case signUpSocialRole:
        return MaterialPageRoute(
          builder: (_) => const SignUpRoleScreen.social(),
        );

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

      case parentChildProfile:
        final childArgs = settings.arguments;
        if (childArgs is ParentChildProgressEntity) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ParentChildProfilePage(child: childArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Child profile data not found')),
          ),
        );

      case parentChildHomework:
        final hwArgs = settings.arguments;
        if (hwArgs is ParentChildHomeworkRouteArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ParentChildHomeworkPage.fromArgs(hwArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Homework data not found')),
          ),
        );

      case parentChildInsights:
        final insightsArgs = settings.arguments;
        if (insightsArgs is ParentChildInsightsRouteArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ParentChildInsightsPage(args: insightsArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Insights data not found')),
          ),
        );

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

      case teacherGroup:
        final teacherGroupArgs = settings.arguments;
        if (teacherGroupArgs is TeacherGroupEntity) {
          return MaterialPageRoute(
            builder: (_) => TeacherGroupPage(group: teacherGroupArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Group not found'))),
        );

      case teacherStudentProfile:
        final profileArgs = settings.arguments;
        if (profileArgs is TeacherStudentProfileRouteArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TeacherStudentProfilePage.fromArgs(profileArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Student profile data not found')),
          ),
        );

      case attendanceHistory:
        final attendanceArgs = settings.arguments;
        if (attendanceArgs is AttendanceHistoryRouteArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => AttendanceHistoryScreen.fromArgs(attendanceArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Attendance history data not found')),
          ),
        );

      case teacherModuleHomework:
        final hwModuleArgs = settings.arguments;
        if (hwModuleArgs is TeacherModuleRouteArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TeacherHomeworkScreen.fromArgs(hwModuleArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Module data not found')),
          ),
        );

      case teacherModuleResources:
        final resModuleArgs = settings.arguments;
        if (resModuleArgs is TeacherModuleRouteArgs) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => TeacherResourcesScreen.fromArgs(resModuleArgs),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Module data not found')),
          ),
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

      case parentSettings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ParentProfileCubit>(),
            child: const ParentSettingsScreen(),
          ),
        );

      case profileAccount:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => getIt<ProfileAccountCubit>()..loadProfile(),
            child: const ProfileAccountScreen(),
          ),
        );

      case passwordSecurity:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => PasswordSecurityCubit(),
            child: const PasswordSecurityScreen(),
          ),
        );

      case notificationsSettings:
        return MaterialPageRoute(
          settings: settings,
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

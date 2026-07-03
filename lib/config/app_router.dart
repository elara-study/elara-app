import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/di/core_di.dart' show navigatorKey;
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/navigation/go_router_refresh_stream.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/auth/presentation/views/forgot_password_screen.dart';
import 'package:elara/features/auth/presentation/views/otp_screen.dart';
import 'package:elara/features/auth/presentation/views/reset_password_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_in_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_credentials_screen.dart';
import 'package:elara/features/auth/presentation/views/sign_up_role_screen.dart';
import 'package:elara/features/auth/presentation/views/splash_screen.dart';
import 'package:elara/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_homework_page.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_homework_route_args.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_insights_page.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_profile_page.dart';
import 'package:elara/features/parent/presentation/home/views/parent_shell.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_cubit.dart';
import 'package:elara/features/parent/presentation/profile/views/parent_settings_screen.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_cubit.dart';
import 'package:elara/features/teacher/presentation/profile/views/teacher_settings_screen.dart';
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
import 'package:elara/features/student/presentation/voice/voice_screen.dart';
import 'package:elara/features/student/presentation/dashboard/views/student_shell.dart';
import 'package:elara/features/student/presentation/group/views/student_group_page.dart';
import 'package:elara/features/student/domain/dashboard/entities/student_group_entity.dart';
import 'package:elara/features/student/presentation/homework/homework_route_args.dart';
import 'package:elara/features/student/presentation/homework/views/homework_screen.dart';
import 'package:elara/features/student/presentation/resources/views/resources_screen.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_settings_cubit.dart';
import 'package:elara/features/student/presentation/profile/views/student_settings_screen.dart';
import 'package:elara/features/student/presentation/quiz/quiz_route_args.dart';
import 'package:elara/features/student/presentation/quiz/views/quiz_flow_page.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/presentation/group/views/attendance_history_route_args.dart';
import 'package:elara/features/teacher/presentation/group/views/attendance_history_screen.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_group_page.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_student_profile_page.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_student_profile_route_args.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_module_route_args.dart';
import 'package:elara/features/teacher/presentation/homework/views/teacher_homework_screen.dart';
import 'package:elara/features/teacher/presentation/homework/views/teacher_resources_screen.dart';
import 'package:elara/features/teacher/presentation/homework/views/teacher_student_submission_screen.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_student_submission_route_args.dart';
import 'package:elara/features/teacher/presentation/dashboard/views/teacher_shell.dart';
import 'package:elara/features/teacher/presentation/roadmap/views/teacher_roadmap_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Named route paths — shared across navigation helpers and [GoRouter].
abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String studentGroup = '/student-group';
  static const String signUpRole = '/register/role';
  static const String signUpSocialRole = '/register/social-role';
  static const String signUpCredentials = '/register/credentials';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otp = '/otp';
  static const String studentDashboard = '/student';
  static const String quiz = '/quiz';
  static const String homework = '/homework';
  static const String chatbot = '/chatbot';
  static const String voice = '/voice';
  static const String studentSettings = '/student/settings';
  static const String teacherSettings = '/teacher/settings';
  static const String parentSettings = '/parent/settings';
  static const String profileAccount = '/settings/profile-account';
  static const String passwordSecurity = '/settings/password-security';
  static const String notificationsSettings = '/settings/notifications';
  static const String demoGroupId = '13ea6162-9513-4b83-9101-467227184b43';
  static const String home = '/home';
  static const String teacherDashboard = '/teacher';
  static const String teacherGroup = '/teacher-group';
  static const String teacherRoadmap = '/teacher/roadmap';
  static const String teacherStudentProfile = '/teacher/student-profile';
  static const String attendanceHistory = '/teacher/attendance-history';
  static const String teacherModuleHomework = '/teacher/module-homework';
  static const String teacherModuleResources = '/teacher/module-resources';
  static const String studentModuleResources = '/student/module-resources';
  static const String teacherStudentSubmission = '/teacher/student-submission';
  static const String parentDashboard = '/parent';
  static const String parentChildProfile = '/parent/child-profile';
  static const String parentChildHomework = '/parent/child-homework';
  static const String parentChildInsights = '/parent/child-insights';
  static const String comingSoonDashboard = '/coming-soon-dashboard';

  static String homeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.student:
        return studentDashboard;
      case UserRole.teacher:
        return teacherDashboard;
      case UserRole.parent:
        return parentDashboard;
    }
  }

  static void navigateAfterAuth(BuildContext context, UserEntity user) {
    GoRouter.of(context).go(homeRouteForRole(user.role));
  }

  static bool isPublicRoute(String location) {
    return location == splash ||
        location == onboarding ||
        location == login ||
        location == forgotPassword ||
        location == resetPassword ||
        location == otp ||
        location.startsWith('/register');
  }

  static bool isProtectedRoute(String location) {
    return !isPublicRoute(location);
  }
}

GoRouter createAppRouter(AuthCubit authCubit) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) => _authRedirect(authCubit.state, state),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingView(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const SignInScreen()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (context, state) {
          final args = state.extra;
          if (args is OtpRouteArgs) {
            return OtpScreen(args: args);
          }
          return const Scaffold(
            body: Center(child: Text('OTP arguments not provided')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final args = state.extra;
          if (args is ResetPasswordRouteArgs) {
            return const ResetPasswordScreen();
          }
          return const Scaffold(
            body: Center(child: Text('Reset password arguments not provided')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signUpRole,
        builder: (_, _) => const SignUpRoleScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUpSocialRole,
        builder: (_, _) => const SignUpRoleScreen.social(),
      ),
      GoRoute(
        path: AppRoutes.signUpCredentials,
        builder: (_, _) => const SignUpCredentialsScreen(),
      ),
      GoRoute(
        path: AppRoutes.studentDashboard,
        builder: (_, _) => const StudentShell(),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const StudentShell()),
      GoRoute(
        path: AppRoutes.teacherDashboard,
        builder: (_, _) => const TeacherShell(),
      ),
      GoRoute(
        path: AppRoutes.parentDashboard,
        builder: (_, _) => const ParentShell(),
      ),
      GoRoute(
        path: AppRoutes.parentChildProfile,
        builder: (context, state) {
          final args = state.extra;
          if (args is ParentChildProgressEntity) {
            return ParentChildProfilePage(child: args);
          }
          return const Scaffold(
            body: Center(child: Text('Child profile data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.parentChildHomework,
        builder: (context, state) {
          final args = state.extra;
          if (args is ParentChildHomeworkRouteArgs) {
            return ParentChildHomeworkPage.fromArgs(args);
          }
          return const Scaffold(
            body: Center(child: Text('Homework data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.parentChildInsights,
        builder: (context, state) {
          final args = state.extra;
          if (args is ParentChildInsightsRouteArgs) {
            return ParentChildInsightsPage(args: args);
          }
          return const Scaffold(
            body: Center(child: Text('Insights data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.comingSoonDashboard,
        builder: (_, _) =>
            const Scaffold(body: Center(child: Text('Dashboard coming soon'))),
      ),
      GoRoute(
        path: AppRoutes.studentGroup,
        builder: (context, state) {
          final args = state.extra;
          final String groupId;
          if (args is StudentGroupEntity) {
            groupId = args.id;
          } else if (args is String) {
            groupId = args;
          } else {
            groupId = AppRoutes.demoGroupId;
          }
          return StudentGroupPage(groupId: groupId);
        },
      ),
      GoRoute(
        path: AppRoutes.teacherGroup,
        builder: (context, state) {
          final args = state.extra;
          if (args is TeacherGroupEntity) {
            return TeacherGroupPage(group: args);
          }
          return const Scaffold(body: Center(child: Text('Group not found')));
        },
      ),
      GoRoute(
        path: AppRoutes.teacherRoadmap,
        builder: (context, state) {
          final args = state.extra;
          if (args is TeacherGroupEntity) {
            return TeacherRoadmapDetailPage(roadmap: args);
          }
          return const Scaffold(
            body: Center(child: Text('Roadmap not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherStudentProfile,
        builder: (context, state) {
          final args = state.extra;
          if (args is TeacherStudentProfileRouteArgs) {
            return TeacherStudentProfilePage.fromArgs(args);
          }
          return const Scaffold(
            body: Center(child: Text('Student profile data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.attendanceHistory,
        builder: (context, state) {
          final args = state.extra;
          if (args is AttendanceHistoryRouteArgs) {
            return AttendanceHistoryScreen.fromArgs(args);
          }
          return const Scaffold(
            body: Center(child: Text('Attendance history data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherModuleHomework,
        builder: (context, state) {
          final args = state.extra;
          if (args is TeacherModuleRouteArgs) {
            return TeacherHomeworkScreen.fromArgs(args);
          }
          return const Scaffold(
            body: Center(child: Text('Module data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherModuleResources,
        builder: (context, state) {
          final args = state.extra;
          if (args is TeacherModuleRouteArgs) {
            return TeacherResourcesScreen.fromArgs(args);
          }
          return const Scaffold(
            body: Center(child: Text('Module data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.studentModuleResources,
        builder: (context, state) {
          final args = state.extra;
          if (args is TeacherModuleRouteArgs) {
            return StudentResourcesScreen.fromArgs(args);
          }
          return const Scaffold(
            body: Center(child: Text('Module data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.teacherStudentSubmission,
        builder: (context, state) {
          final args = state.extra;
          if (args is TeacherStudentSubmissionRouteArgs) {
            return TeacherStudentSubmissionScreen.fromArgs(args);
          }
          return const Scaffold(
            body: Center(child: Text('Submission data not found')),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.quiz,
        builder: (context, state) {
          final args = state.extra;
          final resolved = args is QuizRouteArgs
              ? args
              : const QuizRouteArgs(quizId: 'demo-quiz');
          return QuizFlowPage.fromArgs(resolved);
        },
      ),
      GoRoute(
        path: AppRoutes.homework,
        builder: (context, state) {
          final args = state.extra;
          final resolved = args is HomeworkRouteArgs
              ? args
              : const HomeworkRouteArgs(homeworkId: 'demo-homework');
          return HomeworkScreen.fromArgs(resolved);
        },
      ),
      GoRoute(
        path: AppRoutes.studentSettings,
        builder: (context, _) => BlocProvider(
          create: (_) =>
              StudentSettingsCubit(authCubit: context.read<AuthCubit>()),
          child: const StudentSettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.parentSettings,
        builder: (_, _) => BlocProvider(
          create: (_) => getIt<ParentProfileCubit>(),
          child: const ParentSettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.teacherSettings,
        builder: (_, _) => BlocProvider(
          create: (_) => getIt<TeacherProfileCubit>(),
          child: const TeacherSettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profileAccount,
        builder: (_, _) => BlocProvider(
          create: (_) => getIt<ProfileAccountCubit>()..loadProfile(),
          child: const ProfileAccountScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.passwordSecurity,
        builder: (_, _) => BlocProvider(
          create: (_) => PasswordSecurityCubit(),
          child: const PasswordSecurityScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notificationsSettings,
        builder: (_, _) => BlocProvider(
          create: (_) => NotificationsSettingsCubit(),
          child: const NotificationsSettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.voice,
        builder: (_, _) => const VoiceScreen(),
      ),
      GoRoute(
        path: AppRoutes.chatbot,
        builder: (context, state) {
          final args = state.extra;
          final resolved = args is ChatbotRouteArgs
              ? args
              : const ChatbotRouteArgs();
          return MultiBlocProvider(
            providers: [
              BlocProvider<ChatbotCubit>(create: (_) => getIt<ChatbotCubit>()),
              BlocProvider<SessionsCubit>(
                create: (_) => getIt<SessionsCubit>(),
              ),
            ],
            child: ChatbotScreen(routeArgs: resolved),
          );
        },
      ),
    ],
    errorBuilder: (_, _) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
  );
}

String? _authRedirect(AuthState authState, GoRouterState state) {
  final location = state.matchedLocation;

  if (authState is AuthAuthenticated) {
    if (AppRoutes.isPublicRoute(location) || location == AppRoutes.splash) {
      return AppRoutes.homeRouteForRole(authState.user.role);
    }
    return null;
  }

  if (authState is AuthUnauthenticated) {
    if (AppRoutes.isProtectedRoute(location) && location != AppRoutes.splash) {
      return AppRoutes.login;
    }
    if (location == AppRoutes.splash) {
      return AppRoutes.login;
    }
    return null;
  }

  return null;
}

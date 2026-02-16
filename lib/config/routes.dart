import 'package:elara/presentation/auth/screens/login_screen.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/auth/screens/role_selector_screen.dart';
import 'package:elara/presentation/auth/screens/sign_up_credentials_screen.dart';
import 'package:elara/presentation/auth/screens/sign_up_role_screen.dart';
import 'package:elara/presentation/auth/screens/splash_screen.dart';
import 'package:elara/presentation/parent/screens/parent_dashboard_screen.dart';
import 'package:elara/presentation/parent/screens/parent_home_screen.dart';
import 'package:elara/presentation/student/screens/class_detail_screen.dart';
import 'package:elara/presentation/student/screens/join_class_screen.dart';
import 'package:elara/presentation/student/screens/quiz_attempt_screen.dart';
import 'package:elara/presentation/student/screens/quiz_list_screen.dart';
import 'package:elara/presentation/student/screens/quiz_results_screen.dart';
import 'package:elara/presentation/student/screens/student_main_screen.dart';
import 'package:elara/presentation/teacher/screens/add_student_screen.dart';
import 'package:elara/presentation/teacher/screens/create_class_screen.dart';
import 'package:elara/presentation/teacher/screens/create_quiz_screen.dart';
import 'package:elara/presentation/teacher/screens/essay_grading_screen.dart';
import 'package:elara/presentation/teacher/screens/quiz_criteria_screen.dart';
import 'package:elara/presentation/teacher/screens/rubric_builder_screen.dart';
import 'package:elara/presentation/teacher/screens/teacher_class_detail_screen.dart';
import 'package:elara/presentation/teacher/screens/teacher_main_screen.dart';
import 'package:elara/presentation/teacher/screens/quiz_editor_screen.dart';
import 'package:elara/presentation/teacher/screens/student_detail_screen.dart';
import 'package:elara/domain/models/quiz.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUpCredentials = '/sign-up-credentials';
  static const String signUpRole = '/sign-up-role';
  static const String roleSelector = '/role-selector';
  static const String teacher = '/teacher';
  static const String teacherClasses = '/teacher/classes';
  static const String teacherClassDetail = '/teacher/class-detail';
  static const String teacherAddStudent = '/teacher/add-student';
  static const String teacherCreateClass = '/teacher/create-class';
  static const String teacherCreateQuiz = '/teacher/create-quiz';
  static const String teacherQuizEditor = '/teacher/quiz-editor';
  static const String teacherRubricBuilder = '/teacher/rubric-builder';
  static const String teacherEssayGrading = '/teacher/essay-grading';
  static const String teacherQuizCriteria = '/teacher/quiz-criteria';
  static const String teacherStudentDetail = '/teacher/student-detail';
  static const String student = '/student';
  static const String studentClasses = '/student/classes';
  static const String studentJoinClass = '/student/join-class';
  static const String studentClassDetail = '/student/class-detail';
  static const String studentQuizList = '/student/quiz-list';
  static const String studentQuizAttempt = '/student/quiz-attempt';
  static const String studentQuizResults = '/student/quiz-results';
  static const String parent = '/parent';
  static const String parentDashboard = '/parent/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    switch (name) {
      case '':
      case '/':
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case signUpCredentials:
        return MaterialPageRoute(
          builder: (_) => const SignUpCredentialsScreen(),
        );
      case signUpRole:
        return MaterialPageRoute(
          builder: (_) => const SignUpRoleScreen(),
        );
      case roleSelector:
        return MaterialPageRoute(
          builder: (_) => const RoleSelectorScreen(),
        );
      case teacher:
        return MaterialPageRoute(
          builder: (_) => const TeacherMainScreen(),
        );
      case teacherClasses:
        return MaterialPageRoute(
          builder: (_) => const TeacherMainScreen(),
        );
      case teacherClassDetail:
        return MaterialPageRoute(
          builder: (_) => const TeacherClassDetailScreen(),
        );
      case teacherAddStudent:
        return MaterialPageRoute(
          builder: (_) => const AddStudentScreen(),
        );
      case teacherCreateClass:
        return MaterialPageRoute(
          builder: (_) => const CreateClassScreen(),
        );
      case teacherCreateQuiz:
        return MaterialPageRoute(
          builder: (_) => const CreateQuizScreen(),
        );
      case teacherQuizEditor:
        if (settings.arguments is! Quiz) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text('Error: No quiz provided'))),
          );
        }
        return MaterialPageRoute(
          builder: (_) => QuizEditorScreen(quiz: settings.arguments as Quiz),
        );
      case teacherRubricBuilder:
        return MaterialPageRoute(
          builder: (_) => const RubricBuilderScreen(),
        );
      case teacherEssayGrading:
        return MaterialPageRoute(
          builder: (_) => const EssayGradingScreen(),
        );
      case teacherQuizCriteria:
        return MaterialPageRoute(
          builder: (_) => const QuizCriteriaScreen(),
        );
      case teacherStudentDetail:
        if (settings.arguments is! String) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text('Error: No student ID provided'))),
          );
        }
        return MaterialPageRoute(
          builder: (_) => StudentDetailScreen(studentId: settings.arguments as String),
        );
      case student:
        return MaterialPageRoute(
          builder: (_) => const StudentMainScreen(),
        );
      case studentClasses:
        return MaterialPageRoute(
          builder: (_) => const StudentMainScreen(),
        );
      case studentJoinClass:
        return MaterialPageRoute(
          builder: (_) => const JoinClassScreen(),
        );
      case studentClassDetail:
        return MaterialPageRoute(
          builder: (_) => const ClassDetailScreen(),
        );
      case studentQuizList:
        return MaterialPageRoute(
          builder: (_) => const QuizListScreen(),
        );
      case studentQuizAttempt:
        return MaterialPageRoute(
          builder: (_) => const QuizAttemptScreen(),
        );
      case studentQuizResults:
        return MaterialPageRoute(
          builder: (_) => const QuizResultsScreen(),
        );
      case parent:
        return MaterialPageRoute(
          builder: (_) => const ParentHomeScreen(),
        );
      case parentDashboard:
        return MaterialPageRoute(
          builder: (_) => const ParentDashboardScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppAppBar.detail(title: 'Page not found'),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Unknown route: ${settings.name}'),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(roleSelector, (_) => false),
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}

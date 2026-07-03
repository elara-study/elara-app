import 'package:get_it/get_it.dart';
import 'di/core_di.dart';
import 'di/auth_di.dart';
import 'di/student_di.dart';
import 'di/teacher_di.dart';
import 'di/parent_di.dart';
import 'di/chatbot_di.dart';
import 'di/settings_di.dart';
import 'di/voice_di.dart';
import 'di/alerts_di.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core Services (External, network client, local storage setup, theme, etc.)
  await setupCoreDI();

  // Feature Registrations
  setupAuthDI();
  setupStudentDI();
  setupTeacherDI();
  setupParentDI();
  setupChatbotDI();
  setupSettingsDI();
  setupVoiceDI();
  setupAlertsDI();
}

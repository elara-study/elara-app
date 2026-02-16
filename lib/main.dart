import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/app_theme.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/localization/app_translations.dart';
import 'package:elara/core/localization/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  Get.put(LocaleController());
  runApp(const Elara());
}

class Elara extends StatelessWidget {
  const Elara({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Elara',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      translations: AppTranslations(),
      locale: Get.find<LocaleController>().locale,
      fallbackLocale: const Locale('en'),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

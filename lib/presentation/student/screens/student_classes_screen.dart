import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentClassesScreen extends StatelessWidget {
  const StudentClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('student.myClasses'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'student.enrolledClassesHint'.tr,
                  style: AppTypography.bodyLarge(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.studentClassDetail),
                  child: Text('student.viewSampleClass'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

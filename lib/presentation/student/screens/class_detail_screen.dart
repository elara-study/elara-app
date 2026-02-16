import 'package:elara/config/routes.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassDetailScreen extends StatelessWidget {
  const ClassDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'student.classDetail'.tr, showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('student.mathematics101'.tr, style: AppTypography.h4()),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(
                'student.assignedQuizzesHint'.tr,
                style: AppTypography.bodyMedium(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              AppPrimaryButton(
                text: 'student.viewQuizzes'.tr,
                icon: Icons.quiz,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.studentQuizList),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elara/config/routes.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'student.assignedQuizzes'.tr, showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'student.assignedQuizzes'.tr,
                style: AppTypography.h5(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              AppPrimaryButton(
                text: 'student.startQuizSample'.tr,
                icon: Icons.play_arrow,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.studentQuizAttempt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

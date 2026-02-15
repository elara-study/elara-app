import 'package:elara/config/routes.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch role',
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelector),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Welcome, Teacher', style: AppTypography.h4()),
              const SizedBox(height: AppSpacing.spacing2xl),
              AppPrimaryButton(
                text: 'My Classes',
                icon: Icons.class_,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.teacherClasses),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              AppSecondaryButton(
                text: 'Create New Class',
                icon: Icons.add_circle,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.teacherCreateClass),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              AppOutlineButton(
                text: 'Create Quiz',
                icon: Icons.quiz,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.teacherCreateQuiz),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

/// Create quiz with AI + options for number, type, difficulty (per Figma).
class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'Create Quiz'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Quiz title',
                  hintText: 'e.g. Chapter 5 Quiz',
                ),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Topic / Subject',
                  hintText: 'What should the quiz cover?',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              Text('Generate with AI', style: AppTypography.h6()),
              const SizedBox(height: AppSpacing.spacingMd),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Number of Questions'),
                value: 10,
                items: [5, 10, 15, 20].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Question Type'),
                value: 'Mixed',
                items: ['MCQ only', 'Written only', 'Mixed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Difficulty'),
                value: 'Medium',
                items: ['Easy', 'Medium', 'Hard'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              AppPrimaryButton(
                text: 'Generate Questions with AI',
                icon: Icons.auto_awesome,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.teacherQuizCriteria);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

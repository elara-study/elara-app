import 'package:elara/config/routes.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
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
              Text(
                'Welcome, Student',
                style: AppTypography.h4(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              AppPrimaryButton(
                text: 'My Classes',
                icon: Icons.class_,
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.studentClasses),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              AppSecondaryButton(
                text: 'Join Class',
                icon: Icons.add_circle_outline,
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.studentJoinClass),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

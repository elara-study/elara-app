import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Home'),
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
                'Welcome, Parent',
                style: AppTypography.h4(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              Text(
                'View your linked students\' progress, class enrollments and quiz results.',
                style: AppTypography.bodyLarge(),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.parentDashboard),
                child: const Text('View Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Classes list content for Teacher - used in bottom nav tab.
class TeacherClassesScreenContent extends StatelessWidget {
  const TeacherClassesScreenContent({super.key});

  static const _sampleClasses = [
    _ClassItem(name: 'English Class', description: 'Literature & Writing', studentCount: 24),
    _ClassItem(name: 'Mathematics Class', description: 'Algebra & Geometry', studentCount: 18),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'My Groups',
        actions: AppAppBar.addAction(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.teacherCreateClass),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.spacing2xl),
        itemCount: _sampleClasses.length,
        itemBuilder: (context, i) {
          final c = _sampleClasses[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spacingLg),
            child: Card(
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.teacherClassDetail),
                borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spacingLg),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary100,
                          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
                        ),
                        child: const Icon(Icons.menu_book, color: AppColors.brandPrimary600),
                      ),
                      const SizedBox(width: AppSpacing.spacingLg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name, style: AppTypography.h6()),
                            Text(c.description, style: AppTypography.bodySmall()),
                            Text('${c.studentCount} students', style: AppTypography.caption()),
                          ],
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ClassItem {
  const _ClassItem({
    required this.name,
    required this.description,
    required this.studentCount,
  });
  final String name;
  final String description;
  final int studentCount;
}

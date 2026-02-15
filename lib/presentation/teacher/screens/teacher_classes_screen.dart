import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:flutter/material.dart';

/// Groups list content for Teacher - used in bottom nav tab.
/// Design: Groups header with tab, My Groups + Create, group cards with
/// subject banner, grade pill, student/lesson counts.
class TeacherClassesScreenContent extends StatelessWidget {
  const TeacherClassesScreenContent({super.key});

  static const _sampleGroups = [
    _GroupItem(
      subject: 'MATHEMATICS',
      grade: 'Grade 7',
      name: 'Physics 101',
      studentCount: 28,
      lessonCount: 20,
    ),
    _GroupItem(
      subject: 'ENGLISH',
      grade: 'Grade 7',
      name: 'Advanced Math',
      studentCount: 30,
      lessonCount: 20,
    ),
    _GroupItem(
      subject: 'SCIENCE',
      grade: 'Grade 7',
      name: 'Science Explorers',
      studentCount: 25,
      lessonCount: 18,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppAppBar.withTabs(
          title: 'Groups',
          bottom: TabBar(
            indicatorColor: AppColors.brandPrimary500,
            labelColor: AppColors.brandPrimary500,
            unselectedLabelColor: AppColors.neutral600,
            tabs: const [
              Tab(text: 'Groups'),
            ],
          ),
          actions: AppAppBar.mainTabActions(context),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // My Groups header + Create button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Groups', style: AppTypography.h5()),
                  Material(
                    color: AppColors.neutral200,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                    child: InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.teacherCreateClass),
                      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingMd,
                          vertical: AppSpacing.spacingSm,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: 18,
                              color: AppColors.neutral700,
                            ),
                            const SizedBox(width: AppSpacing.spacingXs),
                            Text(
                              'Create',
                              style: AppTypography.labelMedium(
                                color: AppColors.neutral800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              // Group cards
              ..._sampleGroups.map(
                (g) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacingLg),
                  child: _GroupCardWidget(item: g),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupItem {
  const _GroupItem({
    required this.subject,
    required this.grade,
    required this.name,
    required this.studentCount,
    required this.lessonCount,
  });
  final String subject;
  final String grade;
  final String name;
  final int studentCount;
  final int lessonCount;
}

class _GroupCardWidget extends StatelessWidget {
  const _GroupCardWidget({required this.item});

  final _GroupItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.teacherClassDetail),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subject banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingLg,
                  vertical: AppSpacing.spacingMd,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary600,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.radiusLg),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.subject,
                      style: AppTypography.labelLarge(color: AppColors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingSm,
                        vertical: AppSpacing.spacing2xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neutral300,
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 14,
                            color: AppColors.neutral700,
                          ),
                          const SizedBox(width: AppSpacing.spacing2xs),
                          Text(
                            item.grade,
                            style: AppTypography.caption(
                              color: AppColors.neutral700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Group name + stats
              Padding(
                padding: const EdgeInsets.all(AppSpacing.spacingLg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTypography.h6(),
                          ),
                          const SizedBox(height: AppSpacing.spacingSm),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: AppColors.brandSecondary600,
                              ),
                              const SizedBox(width: AppSpacing.spacing2xs),
                              Text(
                                '${item.studentCount} students',
                                style: AppTypography.caption(
                                  color: AppColors.brandSecondary600,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.spacingMd),
                              Icon(
                                Icons.menu_book_outlined,
                                size: 16,
                                color: AppColors.brandSecondary600,
                              ),
                              const SizedBox(width: AppSpacing.spacing2xs),
                              Text(
                                '${item.lessonCount} lessons',
                                style: AppTypography.caption(
                                  color: AppColors.brandSecondary600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.neutral600,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

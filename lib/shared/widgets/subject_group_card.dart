import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/domain/entities/group_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

enum SubjectGroupCardVariant { student, teacher, roadmap }

class SubjectGroupCard extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onTap;
  final SubjectGroupCardVariant variant;
  final bool isDraft;

  const SubjectGroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.variant = SubjectGroupCardVariant.student,
    this.isDraft = false,
  });

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      SubjectGroupCardVariant.roadmap => _RoadmapCard(
        group: group,
        onTap: onTap,
        isDraft: isDraft,
      ),
      _ => _StandardCard(group: group, onTap: onTap, variant: variant),
    };
  }
}

// Standard card (student + teacher)

class _StandardCard extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onTap;
  final SubjectGroupCardVariant variant;

  const _StandardCard({required this.group, required this.variant, this.onTap});

  bool get _isStudent => variant == SubjectGroupCardVariant.student;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Colored banner (top) ──────────────────────────────
          Container(
            height: 86.w,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.brandPrimary400, AppColors.brandPrimary500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.radiusLg.r),
                topRight: Radius.circular(AppRadius.radiusLg.r),
              ),
            ),
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.subject.toUpperCase(),
                  style: AppTypography.labelLarge(color: AppColors.neutral50)
                      .copyWith(
                        fontWeight: AppTypography.semiBold,
                        fontSize: 16.sp,
                      ),
                ),
                const Spacer(),
                _GradeBadge(grade: group.grade),
              ],
            ),
          ),

          //     content area (bottom)
          Container(
            margin: EdgeInsets.only(top: AppSpacing.spacing7xl.w),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.radiusLg.r),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg.w,
              vertical: AppSpacing.spacing2xl.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teacher name — student variant only
                if (_isStudent) ...[
                  Text(
                    group.teacherName,
                    style: AppTypography.bodySmall(color: cs.onSurfaceVariant)
                        .copyWith(
                          fontWeight: AppTypography.regular,
                          fontSize: 12.sp,
                        ),
                  ),
                ],

                // Group name + arrow
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.name,
                        style: AppTypography.labelLarge(color: cs.onSurface)
                            .copyWith(
                              fontWeight: AppTypography.semiBold,
                              fontSize: 20.sp,
                            ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: SvgPicture.asset(
                        'assets/icons/right_arrow_ios.svg',
                        width: AppSpacing.spacing2xl.w,
                        height: AppSpacing.spacing2xl.w,
                        colorFilter: const ColorFilter.mode(
                          ButtonColors.ghostText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.spacing2xl.h),

                // Stats row
                _StatsRow(
                  studentCount: group.studentCount,
                  lessonLabel: group.lessonProgressLabel,
                ),

                // Progress — student variant only
                if (_isStudent) ...[
                  SizedBox(height: AppSpacing.spacingMd.h),
                  _ProgressRow(percent: group.progressPercent),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Roadmap card (flipped: content top, banner bottom)

class _RoadmapCard extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onTap;
  final bool isDraft;

  const _RoadmapCard({required this.group, this.onTap, this.isDraft = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,

        children: [
          // ── Colored banner (bottom) ───────────────────────────
          Container(
            margin: EdgeInsets.only(top: AppSpacing.spacing7xl.w),
            height: 86.w,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDraft
                    ? [AppColors.neutral200, AppColors.neutral300]
                    : [AppColors.brandPrimary400, AppColors.brandPrimary500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.radiusLg.r),
                bottomRight: Radius.circular(AppRadius.radiusLg.r),
              ),
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg.w,
              vertical: AppSpacing.spacingXl.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  group.subject.toUpperCase(),
                  style: AppTypography.labelLarge(color: AppColors.neutral50)
                      .copyWith(
                        fontWeight: AppTypography.semiBold,
                        fontSize: 16.sp,
                      ),
                ),
                // ACTIVE / DRAFT badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingMd.w,
                    vertical: AppSpacing.spacingXs.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                  ),
                  child: Text(
                    isDraft ? 'DRAFT' : 'ACTIVE',
                    style: AppTypography.labelSmall(color: AppColors.neutral50)
                        .copyWith(
                          fontWeight: AppTypography.semiBold,
                          fontSize: 12.sp,
                        ),
                  ),
                ),
              ],
            ),
          ),
          // ── White content area (top) ──────────────────────────
          Container(
            // margin: EdgeInsets.only(bottom: bannerHeight.h),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.radiusLg.r),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg.w,
              vertical: AppSpacing.spacing2xl.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group name + arrow
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.name,
                        style: AppTypography.labelLarge(color: cs.onSurface)
                            .copyWith(
                              fontWeight: AppTypography.semiBold,
                              fontSize: 20.sp,
                            ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: SvgPicture.asset(
                        'assets/icons/right_arrow_ios.svg',
                        width: AppSpacing.spacing2xl.w,
                        height: AppSpacing.spacing2xl.w,
                        colorFilter: const ColorFilter.mode(
                          ButtonColors.ghostText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.spacing2xl.h),

                // Stats: lessons + grade
                _StatsRow(
                  lessonLabel: group.lessonProgressLabel,
                  gradeLabel: group.grade,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────────────────

class _GradeBadge extends StatelessWidget {
  final String grade;
  const _GradeBadge({required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSm.w,
        vertical: AppSpacing.spacingXs.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral50.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/graduation_cap_icon.svg',
            width: 14.w,
            height: AppSpacing.spacingMd.w,
            colorFilter: const ColorFilter.mode(
              AppColors.neutral50,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: AppSpacing.spacing2xs.w),
          Text(
            grade,
            style: AppTypography.labelSmall(
              color: AppColors.neutral50,
            ).copyWith(fontWeight: AppTypography.semiBold, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

/// Flexible stats row — pass only the fields you need.
class _StatsRow extends StatelessWidget {
  final int? studentCount;
  final String? lessonLabel;
  final String? gradeLabel;

  const _StatsRow({this.studentCount, this.lessonLabel, this.gradeLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (studentCount != null) ...[
          SvgPicture.asset(
            'assets/icons/people_outline.svg',
            width: AppSpacing.spacingLg.w,
            height: AppSpacing.spacingLg.w,
            colorFilter: const ColorFilter.mode(
              AppColors.brandSecondary500,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            '$studentCount students',
            style: AppTypography.bodySmall(
              color: AppColors.brandSecondary500,
            ).copyWith(fontWeight: AppTypography.regular),
          ),
          SizedBox(width: 14.w),
        ],
        if (lessonLabel != null) ...[
          SvgPicture.asset(
            'assets/icons/book_icon.svg',
            width: AppSpacing.spacingLg.w,
            height: AppSpacing.spacingLg.w,
            colorFilter: const ColorFilter.mode(
              AppColors.brandSecondary500,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            lessonLabel!,
            style: AppTypography.bodySmall(
              color: AppColors.brandSecondary500,
            ).copyWith(fontWeight: AppTypography.regular),
          ),
          SizedBox(width: 14.w),
        ],
        if (gradeLabel != null) ...[
          SvgPicture.asset(
            'assets/icons/graduation_cap_icon.svg',
            width: AppSpacing.spacingLg.w,
            height: AppSpacing.spacingLg.w,
            colorFilter: const ColorFilter.mode(
              AppColors.brandSecondary500,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            gradeLabel!,
            style: AppTypography.bodySmall(
              color: AppColors.brandSecondary500,
            ).copyWith(fontWeight: AppTypography.regular),
          ),
        ],
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final double percent;
  const _ProgressRow({required this.percent});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your progress",
              style: AppTypography.bodyMedium(
                color: cs.onSurfaceVariant,
              ).copyWith(fontWeight: AppTypography.regular),
            ),
            Text(
              "${(percent * 100).round()}%",
              style: AppTypography.bodyMedium(
                color: cs.onSurface,
              ).copyWith(fontWeight: AppTypography.regular),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.spacingXs.h),
        LinearProgressIndicator(
          value: percent,
          minHeight: AppSpacing.spacingSm.h,
          backgroundColor: AppColors.brandPrimary100,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.brandPrimary700,
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
        ),
      ],
    );
  }
}

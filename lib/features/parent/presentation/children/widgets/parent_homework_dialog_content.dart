import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_status.dart';
import 'package:elara/features/student/domain/homework/entities/homework_problem_entity.dart';
import 'package:elara/features/teacher/homework/presentation/widgets/teacher_answer_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Content for the Parent Homework Dialog overlay.
/// Shows different content based on whether the homework is active, submitted, or graded.
class ParentHomeworkDialogContent extends StatelessWidget {
  final ParentHomeworkCardEntity homework;

  const ParentHomeworkDialogContent({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400.h),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (homework.status != ParentHomeworkStatus.active && homework.score != null) ...[
                Text(
                  homework.score!.replaceAll(' ', ''),
                  style: AppTypography.h5(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
              ],
              ...homework.problems
                  .map(
                    (p) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.spacingLg.h),
                      child: _buildProblemItem(context, p),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProblemItem(BuildContext context, HomeworkProblemEntity problem) {
    if (homework.status == ParentHomeworkStatus.active) {
      return _ParentProblemCard(problem: problem);
    }
    return _ParentAnswerSection(problem: problem, status: homework.status);
  }
}

// ── Active State Problem Card ────────────────────────────────────────────────

class _ParentProblemCard extends StatelessWidget {
  final HomeworkProblemEntity problem;

  const _ParentProblemCard({required this.problem});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.spacingLg.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingMd.w,
              vertical: AppSpacing.spacing2xs.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.brandSecondary500,
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
            ),
            child: Text(
              'PROBLEM ${problem.problemNumber}',
              style: AppTypography.labelSmall(color: AppColors.white),
            ),
          ),
          SizedBox(height: AppSpacing.spacingMd.h),
          Text(
            problem.questionText,
            style: AppTypography.bodyMedium(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

// ── Submitted / Graded State Answer Section ──────────────────────────────────

class _ParentAnswerSection extends StatelessWidget {
  final HomeworkProblemEntity problem;
  final ParentHomeworkStatus status;

  const _ParentAnswerSection({required this.problem, required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isGraded = status == ParentHomeworkStatus.graded;

    return Container(
      padding: EdgeInsets.all(AppSpacing.spacingLg.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        border: Border.all(color: AppColors.brandPrimary500, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingSm.w,
                  vertical: AppSpacing.spacing2xs.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandSecondary500Alpha20,
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isGraded) ...[
                      Icon(Icons.check_circle, color: AppColors.brandSecondary500, size: 12.sp),
                      SizedBox(width: AppSpacing.spacing2xs.w),
                    ],
                    Text(
                      'ANSWER ${problem.problemNumber}',
                      style: AppTypography.labelSmall(color: AppColors.brandSecondary500),
                    ),
                  ],
                ),
              ),
              if (isGraded)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success500,
                  size: 24.sp,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.spacingMd.h),
          Text(
            problem.questionText,
            style: AppTypography.labelRegular(color: cs.onSurface),
          ),
          SizedBox(height: AppSpacing.spacingMd.h),
          TeacherImagePlaceholder(borderColor: cs.outlineVariant),
        ],
      ),
    );
  }
}

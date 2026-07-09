import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_problem_entity.dart';
import 'package:elara/shared/widgets/app_overflow_menu.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Teacher-side card for a single homework problem.
class TeacherHomeworkProblemCard extends StatelessWidget {
  final TeacherHomeworkProblemEntity problem;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TeacherHomeworkProblemCard({
    super.key,
    required this.problem,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        // Figma: 1px brandPrimary500 stroke
        border: Border.all(color: AppColors.brandPrimary500),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacingLg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: badge + ⋮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ProblemBadge(number: problem.problemNumber),
                AppOverflowMenu(
                  iconSize: 16,
                  items: [
                    AppOverflowMenuItem(
                      label: context.l10n.commonEdit,
                      icon: Icons.mode_edit_outline_rounded,
                      backgroundColor: AppColors.brandPrimary500,
                      onTap: onEdit ?? () {},
                    ),
                    AppOverflowMenuItem(
                      label: context.l10n.commonDelete,
                      icon: Icons.delete_outline_rounded,
                      backgroundColor: AppColors.brandSecondary500,
                      onTap: onDelete ?? () {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingMd.h),

            // Question
            Text(
              problem.questionText,
              style: AppTypography.labelRegular(color: cs.onSurface),
            ),

            // Answer preview
            if (problem.hasImageSubmission) ...[
              SizedBox(height: AppSpacing.spacingMd.h),
              _ImageAnswerPreview(),
            ] else if (problem.sampleAnswerText != null) ...[
              SizedBox(height: AppSpacing.spacingMd.h),
              _TextAnswerPreview(text: problem.sampleAnswerText!),
            ],
          ],
        ),
      ),
    );
  }
}

//   _ProblemBadge

class _ProblemBadge extends StatelessWidget {
  final int number;
  const _ProblemBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSm.w,
        vertical: AppSpacing.spacing2xs.h,
      ),
      decoration: BoxDecoration(
        // Figma: #E86B42 = brandSecondary500
        color: AppColors.brandSecondary500,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      ),
      child: Text(
        context.l10n.teacherProblemBadge(number),
        style: AppTypography.labelSmall(color: AppColors.white),
      ),
    );
  }
}

//   _ImageAnswerPreview

/// Placeholder for a handwritten image answer (shown when a student submitted
/// a photo). In production this will be replaced with a real Image widget.
class _ImageAnswerPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 36.sp,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}

//   _TextAnswerPreview

class _TextAnswerPreview extends StatelessWidget {
  final String text;
  const _TextAnswerPreview({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.spacingMd.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
      ),
      child: Text(text, style: AppTypography.bodySmall(color: cs.onSurface)),
    );
  }
}

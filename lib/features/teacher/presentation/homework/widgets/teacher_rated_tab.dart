import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_rated_student_entity.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_answer_section.dart';
import 'package:elara/shared/widgets/student_row_card.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Rated tab — lists students whose submissions have been graded.
/// Tapping a row opens a score view dialog.
class TeacherRatedTab extends StatelessWidget {
  final List<TeacherRatedStudentEntity> ratedStudents;

  const TeacherRatedTab({super.key, required this.ratedStudents});

  void _showScoreDialog(
    BuildContext context,
    TeacherRatedStudentEntity student,
  ) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: context.l10n.teacherStudentScore(student.studentName),
        content: TeacherScoreDialogContent(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.spacingLg.w,
            0,
            AppSpacing.spacingLg.w,
            AppSpacing.spacingMd.h,
          ),
          child: Text(
            context.l10n.teacherRatedSubmissions,
            style: AppTypography.h5(
              color: cs.onSurface,
            ).copyWith(fontWeight: AppTypography.extraBold),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.spacingLg.w,
              0,
              AppSpacing.spacingLg.w,
              AppSpacing.spacing5xl.h,
            ),
            itemCount: ratedStudents.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppSpacing.spacingMd.h),
            itemBuilder: (ctx, i) => StudentRowCard(
              studentName: ratedStudents[i].studentName,
              onTap: () => _showScoreDialog(ctx, ratedStudents[i]),
              trailing: _XpBadge(xp: ratedStudents[i].totalXp),
            ),
          ),
        ),
      ],
    );
  }
}

// ── _XpBadge ──────────────────────────────────────────────────────────────────

/// Trailing widget for the Rated tab row — shows the student's awarded XP.
///
/// Figma: electric icon + "{xp} XP" in brandPrimary500.
class _XpBadge extends StatelessWidget {
  final int xp;

  const _XpBadge({required this.xp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/electric_icon.svg',
          width: 14.w,
          height: 14.w,
          colorFilter: const ColorFilter.mode(
            AppColors.brandPrimary500,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: AppSpacing.spacing2xs.w),
        Text(
          context.l10n.teacherXpLabel(xp),
          style: AppTypography.labelSmall(color: AppColors.brandPrimary500),
        ),
      ],
    );
  }
}

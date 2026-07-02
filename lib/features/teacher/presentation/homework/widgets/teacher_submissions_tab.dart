import 'package:elara/config/app_router.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_student_submission_entity.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_student_submission_route_args.dart';
import 'package:elara/shared/widgets/student_row_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Submissions tab — lists students who have submitted answers.
/// Tapping a row opens a grading dialog.
class TeacherSubmissionsTab extends StatelessWidget {
  final List<TeacherStudentSubmissionEntity> submissions;
  final int totalXp;
  final String moduleId;
  final String groupId;

  const TeacherSubmissionsTab({
    super.key,
    required this.submissions,
    required this.totalXp,
    required this.moduleId,
    required this.groupId,
  });

  Future<void> _onStudentTap(
    BuildContext context,
    TeacherStudentSubmissionEntity submission,
  ) async {
    context.push(
      AppRoutes.teacherStudentSubmission,
      extra: TeacherStudentSubmissionRouteArgs(
        moduleId: moduleId,
        studentId: submission.id,
        studentName: submission.studentName,
        groupId: groupId,
        totalXp: totalXp,
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
            'Submissions',
            // Figma: font/typo/heading/4 = ExtraBold 20px
            style: AppTypography.h4(color: cs.onSurface),
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
            itemCount: submissions.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppSpacing.spacingMd.h),
            itemBuilder: (ctx, i) => StudentRowCard(
              studentName: submissions[i].studentName,
              onTap: () => _onStudentTap(ctx, submissions[i]),
              trailing: _SubmissionScore(
                submitted: submissions[i].submittedCount,
                total: submissions[i].totalProblems,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── _SubmissionScore ──────────────────────────────────────────────────────────

/// Trailing widget for the Submissions tab row.
///
/// Figma score layout:
///   [submitted]  /  [total]
///   SemiBold 20px  Regular 14px (muted)  Regular 14px (muted)
class _SubmissionScore extends StatelessWidget {
  final int submitted;
  final int total;

  const _SubmissionScore({required this.submitted, required this.total});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Figma: font/typo/label/2xl = SemiBold 20px
        Text(
          '$submitted',
          style: TextStyle(
            fontFamily: AppTypography.nunito,
            fontSize: 20.sp,
            fontWeight: AppTypography.semiBold,
            color: cs.onSurface,
            height: 1.4,
          ),
        ),
        SizedBox(width: 2.w),
        // Figma: Regular 14px muted
        Text('/', style: AppTypography.bodyMedium(color: cs.onSurfaceVariant)),
        SizedBox(width: 2.w),
        Text(
          '$total',
          style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

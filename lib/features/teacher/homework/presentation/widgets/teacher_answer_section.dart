import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_rated_student_entity.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_student_answer_entity.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_student_submission_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── Grading dialog content ─────────────────────────────────────────────────────

/// Dialog content for grading a student's submission.
///
/// Shows a scrollable list of answers followed by the "Submit Grade" row.
class TeacherGradeDialogContent extends StatefulWidget {
  final TeacherStudentSubmissionEntity submission;
  final int maxXp;

  const TeacherGradeDialogContent({
    super.key,
    required this.submission,
    required this.maxXp,
  });

  @override
  State<TeacherGradeDialogContent> createState() =>
      _TeacherGradeDialogContentState();
}

class _TeacherGradeDialogContentState extends State<TeacherGradeDialogContent> {
  late final TextEditingController _scoreCtrl;

  @override
  void initState() {
    super.initState();
    _scoreCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _scoreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Scrollable answer cards — scrollbar hidden via ScrollConfiguration
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 380.h),
          child: ScrollConfiguration(
            // Remove the scrollbar thumb entirely
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.submission.answers
                    .map(
                      (a) => Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSpacing.spacingLg.h,
                        ),
                        child: TeacherAnswerSection(answer: a),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        // Submit grade row — pinned below scroll area, no divider
        TeacherScoreInputRow(
          ctrl: _scoreCtrl,
          maxXp: widget.maxXp,
          isGrading: true,
          onSubmit: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

// ── Score view dialog content ──────────────────────────────────────────────────

/// Dialog content for viewing/editing an already-graded student's score.
class TeacherScoreDialogContent extends StatefulWidget {
  final TeacherRatedStudentEntity student;

  const TeacherScoreDialogContent({super.key, required this.student});

  @override
  State<TeacherScoreDialogContent> createState() =>
      _TeacherScoreDialogContentState();
}

class _TeacherScoreDialogContentState extends State<TeacherScoreDialogContent> {
  late final TextEditingController _scoreCtrl;

  @override
  void initState() {
    super.initState();
    _scoreCtrl = TextEditingController(text: '${widget.student.totalXp}');
  }

  @override
  void dispose() {
    _scoreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Student info row
        Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                size: 20.sp,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Text(
              widget.student.studentName,
              style: AppTypography.bodyMedium(
                color: cs.onSurface,
              ).copyWith(fontWeight: AppTypography.semiBold),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        const Divider(),
        SizedBox(height: AppSpacing.spacingXs.h),
        TeacherScoreInputRow(
          ctrl: _scoreCtrl,
          maxXp: widget.student.maxXp,
          isGrading: false,
          onSubmit: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

// ── TeacherAnswerSection ───────────────────────────────────────────────────────

/// Displays one answer entry inside the grading/score overlay:
/// badge → question → image (with border) or plain text answer.
class TeacherAnswerSection extends StatelessWidget {
  final TeacherStudentAnswerEntity answer;

  const TeacherAnswerSection({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Figma: card with 16px padding, 24px radius, cs.surface bg, 1px brandPrimary500 border
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
          // Figma top row: badge (left) + check icon (right), space-between
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TeacherAnswerBadge(number: answer.answerNumber),
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.brandSecondary500,
                size: 20.sp,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacingMd.h),

          // Question — Figma: label/regular 14px semibold, color/text/primary
          Text(
            answer.questionText,
            style: AppTypography.labelRegular(color: cs.onSurface),
          ),

          // Answer body
          if (answer.imageUrl != null) ...[
            SizedBox(height: AppSpacing.spacingMd.h),
            // Figma: image with 1px border, 16px radius, 160px height
            TeacherImagePlaceholder(borderColor: cs.outlineVariant),
          ] else if (answer.answerText != null) ...[
            SizedBox(height: AppSpacing.spacingMd.h),
            // Figma: plain text, bodyMedium, onSurfaceVariant
            Text(
              answer.answerText!,
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

// ── TeacherAnswerBadge ─────────────────────────────────────────────────────────

/// Answer badge used inside the submission overlay.
///
/// Figma overlay style: semi-transparent `brandSecondary500Alpha20` background
/// with `brandSecondary500` (orange) text — NOT solid orange + white.
///
/// Set [filled] = true if you need the solid variant elsewhere.
class TeacherAnswerBadge extends StatelessWidget {
  final int number;

  /// true  = solid brandSecondary500 bg + white text (Problem List cards)
  /// false = brandSecondary500Alpha20 bg + brandSecondary500 text (overlay dialogs)
  final bool filled;

  /// Shows a ✓ icon prefix (used in Score view overlay).
  final bool isGraded;

  const TeacherAnswerBadge({
    super.key,
    required this.number,
    this.filled = false,
    this.isGraded = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = filled
        ? AppColors.brandSecondary500
        : AppColors.brandSecondary500Alpha20;
    final textColor = filled ? AppColors.white : AppColors.brandSecondary500;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSm.w,
        vertical: AppSpacing.spacing2xs.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isGraded) ...[
            Icon(Icons.check_circle, color: textColor, size: 12.sp),
            SizedBox(width: AppSpacing.spacing2xs.w),
          ],
          Text(
            'ANSWER $number',
            style: AppTypography.labelSmall(color: textColor),
          ),
        ],
      ),
    );
  }
}

// ── TeacherScoreInputRow ───────────────────────────────────────────────────────

/// Score input row matching the Figma "Submit Grade" section.
///
/// Layout: [Expanded input with "/ N" suffix] [Submit/Save button]
///
/// Figma:
///   Input: scaffold bg, 16px radius, 40px height, "/ maxXp" suffix (12px SemiBold)
///   Button: brandPrimary500, radiusFull, 40px height, labelLarge (16px) + arrow/lock icon
class TeacherScoreInputRow extends StatelessWidget {
  final TextEditingController ctrl;
  final int maxXp;

  /// true  → "Submit Grade" + arrow icon
  /// false → "Save Score" + lock icon
  final bool isGrading;
  final VoidCallback onSubmit;

  const TeacherScoreInputRow({
    super.key,
    required this.ctrl,
    required this.maxXp,
    required this.isGrading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        // ── Score input (Expanded) with "/ N" suffix ──────────────────
        Expanded(
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              // Figma: #F8FAFC bg with inset shadow
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            ),
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(color: cs.onSurface),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                // Figma: placeholder 'XP' bodySmall center
                hintText: 'XP',
                hintStyle: AppTypography.bodySmall(
                  color: cs.onSurfaceVariant,
                ).copyWith(fontSize: 12.sp),
                // "/ 100" suffix inside the field
                suffix: Text(
                  '/ $maxXp',
                  style: AppTypography.labelSmall(color: cs.onSurfaceVariant),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingMd.w,
                  vertical: AppSpacing.spacingXs.h,
                ),
                isCollapsed: true,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.spacingMd.w),

        // ── Submit / Save button ──────────────────────────────────────
        // Figma: brandPrimary500, radiusFull, padding 8px 16px, labelLarge 16px
        GestureDetector(
          onTap: onSubmit,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg.w,
              vertical: AppSpacing.spacingSm.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary500,
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isGrading ? 'Submit Score' : 'Save Score',
                  // Figma: font/typo/label/large = SemiBold 16px
                  style: AppTypography.labelLarge(color: AppColors.white),
                ),
                SizedBox(width: AppSpacing.spacingSm.w),
                Icon(
                  isGrading
                      ? Icons.arrow_forward_rounded
                      : Icons.lock_outline_rounded,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── TeacherImagePlaceholder ────────────────────────────────────────────────────

/// Placeholder for a handwritten image answer.
///
/// Figma: `border: 1px solid outlineVariant`, `border-radius: 16px`, ~120px tall.
class TeacherImagePlaceholder extends StatelessWidget {
  /// Border color — pass `cs.outlineVariant` from the caller.
  final Color? borderColor;

  const TeacherImagePlaceholder({super.key, this.borderColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = borderColor ?? cs.outlineVariant;

    return Container(
      // Figma: height ≈ 160px, 16px radius, 1px border, surfaceContainerHighest bg
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
        border: Border.all(color: border),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 36.sp,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}

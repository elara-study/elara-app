import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/homework/domain/entities/homework_problem_entity.dart';
import 'package:elara/features/student/homework/domain/entities/homework_problem_status.dart';
import 'package:elara/features/student/homework/presentation/cubits/homework_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// A single problem card displayed in the homework problem list.
///
/// Fully [StatelessWidget] — answer text lives in [HomeworkCubit] state.
/// The only [StatefulWidget] in this file is [_ShadowTextField], which
/// legitimately needs state for its own [TextEditingController] (disposal)
/// and [FocusNode] (focus-driven shadow animation).
class HomeworkProblemCard extends StatelessWidget {
  final HomeworkProblemEntity problem;

  const HomeworkProblemCard({super.key, required this.problem});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isActive = problem.status == HomeworkProblemStatus.active;
    final isSubmittable = isActive && problem.answerText.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacingLg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: PROBLEM X badge + status label ─────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ProblemBadge(number: problem.problemNumber),
                _StatusLabel(status: problem.status),
              ],
            ),

            SizedBox(height: AppSpacing.spacingMd.h),

            // ── Question text ───────────────────────────────────────────────
            Text(
              problem.questionText,
              style: AppTypography.labelRegular(color: cs.onSurface),
            ),

            SizedBox(height: AppSpacing.spacingLg.h),

            // ── Graded feedback ─────────────────────────────────────────────
            if (problem.status == HomeworkProblemStatus.graded &&
                problem.feedback != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.spacingMd.w),
                decoration: BoxDecoration(
                  color: AppColors.success50,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                  border: Border.all(color: AppColors.success200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Grade: ',
                          style: AppTypography.labelSmall(
                            color: AppColors.success700,
                          ).copyWith(fontWeight: AppTypography.bold),
                        ),
                        Text(
                          '${problem.grade}/${problem.maxGrade}',
                          style: AppTypography.labelSmall(
                            color: AppColors.success700,
                          ).copyWith(fontWeight: AppTypography.extraBold),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.spacingXs.h),
                    Text(
                      problem.feedback!,
                      style: AppTypography.bodySmall(
                        color: AppColors.success700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.spacingMd.h),
            ],

            // ── Submitted answer (read-only) ────────────────────────────────
            if (problem.submittedAnswer != null &&
                problem.status != HomeworkProblemStatus.active) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.spacingMd.w),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                ),
                child: Text(
                  problem.submittedAnswer!,
                  style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
                ),
              ),
            ],

            // ── Answer input + submit (active problems only) ────────────────
            if (isActive) ...[
              // [_ShadowTextField] owns its TextEditingController and FocusNode.
              // [initialText] seeds the field; [answerText] syncs it on rebuild.
              _ShadowTextField(
                initialText: problem.answerText,
                answerText: problem.answerText,
                onChanged: (text) => context.read<HomeworkCubit>().updateAnswer(
                      problemId: problem.id,
                      text: text,
                    ),
              ),

              SizedBox(height: AppSpacing.spacingMd.h),

              // Submit row
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: isSubmittable
                          ? () => context
                              .read<HomeworkCubit>()
                              .submitProblem(problem.id)
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.spacingSm.h,
                          horizontal: AppSpacing.spacingLg.w,
                        ),
                        decoration: BoxDecoration(
                          color: isSubmittable
                              ? ButtonColors.primaryDefault
                              : ButtonColors.primaryDefault.withAlpha(100),
                          borderRadius: BorderRadius.circular(
                            AppRadius.radiusFull.r,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Submit Answer',
                              style: AppTypography.labelLarge(
                                color: ButtonColors.primaryText,
                              ),
                            ),
                            SizedBox(width: AppSpacing.spacingSm.w),
                            SvgPicture.asset(
                              'assets/icons/send_icon.svg',
                              width: 16.w,
                              height: 16.h,
                              colorFilter: const ColorFilter.mode(
                                ButtonColors.primaryText,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.spacingMd.w),
                  // Camera button (placeholder — backend will handle uploads)
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ButtonColors.outlineText,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(9.w),
                      child: SvgPicture.asset(
                        'assets/icons/camera_icon.svg',
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                          ButtonColors.outlineText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Internal sub-widgets ───────────────────────────────────────────────────────

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
        color: AppColors.brandSecondary500,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      ),
      child: Text(
        'PROBLEM $number',
        style: AppTypography.labelSmall(
          color: AppColors.neutral50,
        ).copyWith(fontWeight: AppTypography.semiBold),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final HomeworkProblemStatus status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      HomeworkProblemStatus.active => ('Active', AppColors.brandSecondary500),
      HomeworkProblemStatus.pending => ('Pending', AppColors.warning500),
      HomeworkProblemStatus.submitted => (
        'Submitted',
        AppColors.brandPrimary500,
      ),
      HomeworkProblemStatus.graded => ('Graded', AppColors.success500),
    };

    return Text(
      label,
      style: AppTypography.labelSmall(
        color: color,
      ).copyWith(fontWeight: AppTypography.semiBold),
    );
  }
}

/// Text field with a Figma-matching soft blended shadow border.
///
/// This is the ONLY [StatefulWidget] in this file, and it is justified because:
///
/// 1. [TextEditingController] — must be created in [initState] and disposed in
///    [dispose]. Flutter has no built-in hook for this in a [StatelessWidget].
///
/// 2. [FocusNode] — same lifecycle requirements as the controller.
///
/// 3. [_isFocused] — drives a purely visual shadow animation and belongs
///    entirely to this widget; it is not shared with the cubit or any parent.
///
/// Everything else (the typed text, submission status) lives in [HomeworkCubit].
class _ShadowTextField extends StatefulWidget {
  /// Seeds the [TextEditingController] text on first build.
  final String initialText;

  /// Updated from cubit state; used in [didUpdateWidget] to keep the
  /// controller in sync when cubit resets the text (e.g. after submit).
  final String answerText;

  final ValueChanged<String> onChanged;

  const _ShadowTextField({
    required this.initialText,
    required this.answerText,
    required this.onChanged,
  });

  @override
  State<_ShadowTextField> createState() => _ShadowTextFieldState();
}

class _ShadowTextFieldState extends State<_ShadowTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _isFocused = _focusNode.hasFocus);
      });
  }

  @override
  void didUpdateWidget(_ShadowTextField old) {
    super.didUpdateWidget(old);
    // Sync when the cubit resets the draft text (e.g. after a submit clears it).
    if (widget.answerText != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.answerText,
        selection: TextSelection.collapsed(offset: widget.answerText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.brandPrimary500.withValues(alpha: 0.25),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: AppColors.brandPrimary500.withValues(alpha: 0.12),
                  blurRadius: 0,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.06),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        maxLines: 4,
        minLines: 3,
        style: AppTypography.bodySmall(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: 'Type your answer here...',
          hintStyle: AppTypography.bodySmall(color: cs.onSurfaceVariant),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.all(AppSpacing.spacingMd.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

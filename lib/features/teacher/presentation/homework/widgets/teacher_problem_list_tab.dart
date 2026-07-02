import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_problem_entity.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_homework_problem_card.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Problem List tab — lists homework problems with an "+ Add" header.
class TeacherProblemListTab extends StatelessWidget {
  final List<TeacherHomeworkProblemEntity> problems;
  final Future<void> Function(String description) onAddProblem;
  final Future<void> Function({
    required String problemId,
    required String description,
  })
  onUpdateProblem;
  final Future<void> Function(String problemId) onDeleteProblem;

  const TeacherProblemListTab({
    super.key,
    required this.problems,
    required this.onAddProblem,
    required this.onUpdateProblem,
    required this.onDeleteProblem,
  });

  void _showAddProblemDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Add a Problem',
        content: _ProblemFormContent(
          submitLabel: 'Add Problem',
          onSubmit: onAddProblem,
        ),
      ),
    );
  }

  void _showEditProblemDialog(
    BuildContext context,
    TeacherHomeworkProblemEntity problem,
  ) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Edit Problem',
        content: _ProblemFormContent(
          initialDescription: problem.questionText,
          submitLabel: 'Save Changes',
          onSubmit: (description) =>
              onUpdateProblem(problemId: problem.id, description: description),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg.w,
        0,
        AppSpacing.spacingLg.w,
        AppSpacing.spacing5xl.h,
      ),
      itemCount: 1 + problems.length,
      separatorBuilder: (_, index) => SizedBox(
        height: index == 0 ? AppSpacing.spacingLg.h : AppSpacing.spacingMd.h,
      ),
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return AppSectionHeader(
            title: 'Problem List',
            onAdd: () => _showAddProblemDialog(ctx),
          );
        }
        final problem = problems[index - 1];
        return TeacherHomeworkProblemCard(
          problem: problem,
          onEdit: () => _showEditProblemDialog(ctx, problem),
          onDelete: () => onDeleteProblem(problem.id),
        );
      },
    );
  }
}

//   Problem form dialog content

class _ProblemFormContent extends StatefulWidget {
  final String? initialDescription;
  final String submitLabel;
  final Future<void> Function(String description) onSubmit;

  const _ProblemFormContent({
    this.initialDescription,
    required this.submitLabel,
    required this.onSubmit,
  });

  @override
  State<_ProblemFormContent> createState() => _ProblemFormContentState();
}

class _ProblemFormContentState extends State<_ProblemFormContent> {
  late final TextEditingController _ctrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            boxShadow: AppShadows.elevation(theme.brightness),
          ),
          child: TextField(
            controller: _ctrl,
            maxLines: 3,
            style: AppTypography.bodyMedium(color: cs.onSurface),
            decoration: InputDecoration(
              hintText: 'Enter problem description',
              hintStyle: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppSpacing.spacingMd.w),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _isSubmitting
                ? null
                : () async {
                    final text = _ctrl.text.trim();
                    if (text.isEmpty) {
                      return;
                    }

                    setState(() => _isSubmitting = true);
                    await widget.onSubmit(text);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandPrimary500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
              ),
            ),
            child: _isSubmitting
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.submitLabel,
                    style: AppTypography.labelRegular(color: AppColors.white),
                  ),
          ),
        ),
      ],
    );
  }
}

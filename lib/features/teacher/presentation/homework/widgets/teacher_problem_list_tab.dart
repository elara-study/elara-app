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

  const TeacherProblemListTab({super.key, required this.problems});

  void _showAddProblemDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => const AppDialog(
        title: 'Add a Problem',
        content: _AddProblemContent(),
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
        return TeacherHomeworkProblemCard(
          problem: problems[index - 1],
          onEdit: () {},
          onDelete: () {},
        );
      },
    );
  }
}

//   Add Problem dialog content

class _AddProblemContent extends StatefulWidget {
  const _AddProblemContent();

  @override
  State<_AddProblemContent> createState() => _AddProblemContentState();
}

class _AddProblemContentState extends State<_AddProblemContent> {
  final _ctrl = TextEditingController();

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
            onPressed: () {
              if (_ctrl.text.trim().isNotEmpty) Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandPrimary500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
              ),
            ),
            child: Text(
              'Add Problem',
              style: AppTypography.labelRegular(color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_entity.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_group_cubit.dart';
import 'package:elara/features/teacher/presentation/group/widgets/add_student_sheet.dart';
import 'package:elara/features/teacher/presentation/group/widgets/attendance_sheet.dart';
import 'package:elara/features/teacher/presentation/group/widgets/group_stats_header.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_student_profile_route_args.dart';
import 'package:elara/features/teacher/presentation/group/views/attendance_history_route_args.dart';
import 'package:elara/features/teacher/presentation/group/widgets/student_row.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:elara/shared/widgets/app_text_field.dart';
import 'package:elara/shared/widgets/segmented_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Students tab: stats header, attendance card, action buttons, search, list.
class StudentsTab extends StatelessWidget {
  const StudentsTab({super.key, required this.group});

  final TeacherGroupEntity group;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherGroupCubit, TeacherGroupState>(
      builder: (context, state) {
        return switch (state) {
          TeacherGroupInitial() ||
          TeacherGroupLoading() ||
          TeacherGroupDeleted() => const Center(
            child: CircularProgressIndicator(),
          ),
          TeacherGroupError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing2xl),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TeacherGroupLoaded(:final detail) => _StudentsContent(
            detail: detail,
            group: group,
          ),
        };
      },
    );
  }
}

class _StudentsContent extends StatefulWidget {
  final TeacherGroupDetailEntity detail;
  final TeacherGroupEntity group;

  const _StudentsContent({required this.detail, required this.group});

  @override
  State<_StudentsContent> createState() => _StudentsContentState();
}

class _StudentsContentState extends State<_StudentsContent> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<TeacherStudentEntity> get _filtered {
    if (_query.isEmpty) return widget.detail.students;
    final q = _query.toLowerCase();
    return widget.detail.students
        .where((s) => s.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = _filtered;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg.w,
        0,
        AppSpacing.spacingLg.w,
        AppSpacing.spacing5xl.h,
      ),
      children: [
        // Stats tiles
        GroupStatsHeader.fromDetail(widget.detail),
        SizedBox(height: AppSpacing.spacingXl.h),

        // Today's Attendance card
        _AttendanceCard(
          detail: widget.detail,
          onHistoryTap: () => AppNavigation.pushNamed(
            context,
            AppRoutes.attendanceHistory,
            arguments: AttendanceHistoryRouteArgs(
              groupName: '',
              presentToday: widget.detail.presentToday,
              totalStudents: widget.detail.studentCount,
              students: widget.detail.students,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.spacing2xl.h),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: AppPrimaryButton(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingLg.w,
                  vertical: AppSpacing.spacingMd.h,
                ),
                text: 'Add Student',
                borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                leading: SvgPicture.asset(
                  'assets/icons/plus_icon.svg',
                  height: AppIconSizes.iconMd.h,
                  width: AppIconSizes.iconMd.w,
                  colorFilter: const ColorFilter.mode(
                    ButtonColors.primaryText,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => AddStudentDialog.show(
                  context,
                  joinCode: widget.detail.joinCode,
                  onSubmit: (username) {
                    context.read<TeacherGroupCubit>().addStudent(
                      groupId: widget.group.id,
                      username: username,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Expanded(
              child: AppOutlineButton(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingLg.w,
                  vertical: AppSpacing.spacingMd.h,
                ),
                text: 'Attendance',
                borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                leading: SvgPicture.asset(
                  'assets/icons/join_icon.svg',
                  height: AppIconSizes.iconXs.h,
                  width: AppIconSizes.iconXs.w,
                  colorFilter: const ColorFilter.mode(
                    ButtonColors.outlineText,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => AttendanceDialog.show(
                  context,
                  students: widget.detail.students,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.spacing2xl.h),

        // Search bar
        AppTextField(
          fillColor: cs.surfaceContainerHighest,
          hintText: 'Search students...',
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _query = v.trim()),
        ),
        SizedBox(height: AppSpacing.spacing2xl.h),

        // Student list (filtered)
        if (filtered.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.spacing3xl.h),
            child: Text(
              _query.isEmpty
                  ? 'No students yet.'
                  : 'No students match "$_query".',
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: filtered.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppSpacing.spacingMd.h),
            itemBuilder: (_, i) {
              final student = filtered[i];
              return GestureDetector(
                onTap: () => AppNavigation.pushNamed(
                  context,
                  AppRoutes.teacherStudentProfile,
                  arguments: TeacherStudentProfileRouteArgs(
                    group: widget.group,
                    student: student,
                  ),
                ),
                child: StudentRow(student: student),
              );
            },
          ),
      ],
    );
  }
}

// ── Today's Attendance card ────────────────────────────────────────────────────

class _AttendanceCard extends StatelessWidget {
  final TeacherGroupDetailEntity detail;
  final VoidCallback onHistoryTap;

  const _AttendanceCard({required this.detail, required this.onHistoryTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progress = detail.studentCount == 0
        ? 0.0
        : detail.presentToday / detail.studentCount;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingLg.w,
          vertical: AppSpacing.spacing2xl.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Today's Attendance",
                  style: AppTypography.h5(
                    color: cs.onSurface,
                  ).copyWith(fontWeight: AppTypography.extraBold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onHistoryTap,
                  child: SvgPicture.asset(
                    'assets/icons/history_icon.svg',
                    height: AppIconSizes.iconMd.h,
                    width: AppIconSizes.iconMd.w,
                    colorFilter: ColorFilter.mode(
                      cs.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Row(
              children: [
                Text(
                  'Present',
                  style: AppTypography.bodyMedium(
                    color: cs.onSurfaceVariant,
                  ).copyWith(fontWeight: AppTypography.regular),
                ),
                const Spacer(),
                Text(
                  detail.attendanceLabel,
                  style: AppTypography.bodyMedium(
                    color: cs.onSurface,
                  ).copyWith(fontWeight: AppTypography.regular),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingSm.h),
            SegmentedProgressBar(
              progress: progress,
              height: AppSpacing.spacingSm,
            ),
          ],
        ),
      ),
    );
  }
}

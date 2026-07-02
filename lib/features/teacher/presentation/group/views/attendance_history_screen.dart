import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_entity.dart';
import 'package:elara/features/teacher/presentation/group/widgets/attendance_sheet.dart';
import 'package:elara/features/teacher/presentation/group/widgets/group_stats_header.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/segmented_progress_bar.dart';
import 'package:elara/features/teacher/presentation/group/views/attendance_history_route_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single attendance history day entry.
class AttendanceHistoryEntry {
  final String month; // e.g. "APR"
  final int day; // e.g. 26
  final int present;
  final int total;

  const AttendanceHistoryEntry({
    required this.month,
    required this.day,
    required this.present,
    required this.total,
  });

  double get progress => total == 0 ? 0.0 : present / total;
  String get label => '$present / $total';
}

/// Full-screen Attendance History — AppBar + two stat tiles + dated list.
class AttendanceHistoryScreen extends StatelessWidget {
  final String groupName;
  final int presentToday;
  final int totalStudents;
  final List<TeacherStudentEntity> students;

  const AttendanceHistoryScreen({
    super.key,
    required this.groupName,
    required this.presentToday,
    required this.totalStudents,
    required this.students,
  });

  factory AttendanceHistoryScreen.fromArgs(AttendanceHistoryRouteArgs args) {
    return AttendanceHistoryScreen(
      key: ValueKey('attendance-history-${args.groupName}'),
      groupName: args.groupName,
      presentToday: args.presentToday,
      totalStudents: args.totalStudents,
      students: args.students,
    );
  }

  // Mock history — replace with real data when the API is ready.
  static const List<AttendanceHistoryEntry> _mockHistory = [
    AttendanceHistoryEntry(month: 'APR', day: 26, present: 23, total: 28),
    AttendanceHistoryEntry(month: 'APR', day: 25, present: 26, total: 28),
    AttendanceHistoryEntry(month: 'APR', day: 23, present: 19, total: 28),
    AttendanceHistoryEntry(month: 'APR', day: 22, present: 27, total: 28),
    AttendanceHistoryEntry(month: 'APR', day: 21, present: 24, total: 28),
    AttendanceHistoryEntry(month: 'APR', day: 20, present: 28, total: 28),
    AttendanceHistoryEntry(month: 'APR', day: 19, present: 22, total: 28),
  ];

  // Derived stats
  double get _avgAttendance {
    if (_mockHistory.isEmpty) return 0;
    return _mockHistory.map((e) => e.progress).reduce((a, b) => a + b) /
        _mockHistory.length;
  }

  int get _perfectDays =>
      _mockHistory.where((e) => e.present == e.total).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppGlassHeader(
        title: groupName.isEmpty ? 'Group' : groupName,
        subtitle: 'Attendance History',
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.spacingLg.w,
          MediaQuery.paddingOf(context).top +
              kToolbarHeight +
              AppSpacing.spacingXl.h,
          AppSpacing.spacingLg.w,
          AppSpacing.spacing5xl.h,
        ),
        children: [
          GroupStatsHeader(
            icon1: 'assets/icons/join_icon.svg',
            label1: 'Avg. Attendance',
            value1: '${(_avgAttendance * 100).round()}%',
            color1: AppColors.brandSecondary500,
            icon2: 'assets/icons/history_icon.svg',
            label2: 'Perfect Days',
            value2: '$_perfectDays',
            color2: AppColors.success500,
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),

          // History list
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _mockHistory.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppSpacing.spacingMd.h),
            itemBuilder: (_, i) =>
                _HistoryRow(entry: _mockHistory[i], students: students),
          ),
        ],
      ),
    );
  }
}

// ── History row ───────────────────────────────────────────────────────────────

class _HistoryRow extends StatelessWidget {
  final AttendanceHistoryEntry entry;
  final List<TeacherStudentEntity> students;

  const _HistoryRow({required this.entry, required this.students});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () => AttendanceDialog.show(context, students: students),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
          boxShadow: AppShadows.elevation(theme.brightness),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.spacingMd.w),
          child: Row(
            children: [
              // Date badge
              Container(
                width: 48.w,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.spacingXs.h),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                ),
                child: Column(
                  children: [
                    Text(
                      entry.month,
                      style: AppTypography.labelSmall(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${entry.day}',
                      style: AppTypography.h5(
                        color: cs.onSurface,
                      ).copyWith(fontWeight: AppTypography.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.spacingMd.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Present',
                          style: AppTypography.bodyMedium(color: cs.onSurface),
                        ),
                        const Spacer(),
                        Text(
                          entry.label,
                          style: AppTypography.bodyMedium(
                            color: cs.onSurface,
                          ).copyWith(fontWeight: AppTypography.semiBold),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.spacingXs.h),
                    SegmentedProgressBar(
                      progress: entry.progress,
                      height: AppSpacing.spacingXs,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.spacingMd.w),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

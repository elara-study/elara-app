import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_profile_entity.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_student_profile_cubit.dart';
import 'package:elara/features/teacher/presentation/group/widgets/edit_insight_manual_sheet.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_student_insight_card.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_student_parents_section.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_student_stats_grid.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_level_progress_card.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_student_profile_overflow_menu.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Group student profile body — Figma Group Student Profile (1417:7049).
class TeacherStudentProfileBody extends StatelessWidget {
  const TeacherStudentProfileBody({
    super.key,
    required this.profile,
    required this.formatThousands,
    required this.onAddInsight,
  });

  final TeacherStudentProfileEntity profile;
  final String Function(int) formatThousands;
  final VoidCallback onAddInsight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final student = profile.student;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.spacingLg.w,
        right: AppSpacing.spacingLg.w,
        top: kToolbarHeight + AppSpacing.spacing8xl.h,
        bottom: AppSpacing.spacing5xl.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 39.r,
                backgroundColor: cs.surfaceContainerHighest,
                child: Icon(
                  Icons.person_rounded,
                  size: 44.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.spacingSm.h),
              Text(
                student.name,
                textAlign: TextAlign.center,
                style: AppTypography.h3(color: cs.onSurface),
              ),
              Text(
                profile.gradeLabel,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(color: cs.onSurfaceVariant),
              ),
              SizedBox(height: AppSpacing.spacingSm.h),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary500Alpha20,
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingSm.w,
                    vertical: AppSpacing.spacingXs.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/flag_icon.svg',
                        width: 16.w,
                        height: 16.w,
                        colorFilter: ColorFilter.mode(
                          cs.onSurfaceVariant,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: AppSpacing.spacingXs.w),
                      Text(
                        'Level ${profile.level}',
                        style: AppTypography.labelSmall(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),
          ProfileLevelProgressCard(
            formatThousands: formatThousands,
            nextLevel: profile.nextLevel,
            xpCurrent: profile.xpCurrent,
            xpGoal: profile.xpGoal,
            remainder: profile.xpToNextLevel,
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),
          TeacherStudentStatsGrid(
            totalXpDisplay: formatThousands(student.xp),
            lessonsLabel: profile.lessonsStatLabel,
            streakLabel: '${profile.streakDays} days',
            attendanceLabel: profile.attendanceLabel,
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),
          TeacherStudentParentsSection(parents: profile.parents),
          SizedBox(height: AppSpacing.spacing2xl.h),
          AppSectionHeader(title: 'Insights', onAdd: onAddInsight),
          SizedBox(height: AppSpacing.spacingLg.h),
          if (profile.insight != null)
            TeacherStudentInsightCard(
              insight: profile.insight!,
              onEdit: () => showEditInsightManualSheet(
                context,
                studentName: student.name,
                initialInsight: profile.insight!,
              ),
              onSend: () {
                context.read<TeacherStudentProfileCubit>().sendInsight();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Insight sent to parents')),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Scaffold + glass app bar for the group student profile screen.
class TeacherStudentProfileScreen extends StatelessWidget {
  const TeacherStudentProfileScreen({
    super.key,
    required this.handle,
    required this.studentName,
    required this.groupTitle,
    required this.body,
  });

  final String handle;
  final String studentName;
  final String groupTitle;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppGlassHeader(
        title: handle,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.spacingSm.w),
            child: TeacherStudentProfileOverflowMenu(
              studentName: studentName,
              groupTitle: groupTitle,
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}

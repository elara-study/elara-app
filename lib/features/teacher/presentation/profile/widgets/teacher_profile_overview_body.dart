import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/teacher/domain/dashboard/entities/teacher_profile_entity.dart';
import 'package:elara/features/teacher/presentation/dashboard/cubits/teacher_home_cubit.dart';
import 'package:elara/features/teacher/presentation/dashboard/cubits/teacher_home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/localization/localization_extension.dart';

class TeacherProfileOverviewBody extends StatelessWidget {
  const TeacherProfileOverviewBody({
    super.key,
    required this.user,
    required this.profileData,
  });

  final UserEntity? user;
  final TeacherProfileEntity profileData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.spacingLg.w,
        right: AppSpacing.spacingLg.w,
        top: kToolbarHeight + 70.h,
        bottom: 120.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppSpacing.spacingMd.h),

          // ── Profile Header ──────────────────────────────────────────────
          Center(
            child: CircleAvatar(
              radius: 39.r,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.school_rounded,
                size: 40.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.spacingMd.h),
          Text(
            user?.fullName ?? profileData.fullName,
            textAlign: TextAlign.center,
            style: AppTypography.h3(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _buildSubjectsLabel(context),
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.spacingXl.h),

          // ── Info Card ───────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.email_outlined,
                  text: user?.email ?? 'teacher@example.com',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Divider(
                    height: 1,
                    color: AppColors.neutral200,
                  ),
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  text: user?.phone ?? '+20 10 12345678',
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.spacingXl.h),

          // ── Stats Grid ──────────────────────────────────────────────────
          _StatsGrid(profileData: profileData),
        ],
      ),
    );
  }

  String _buildSubjectsLabel(BuildContext context) {
    final homeState = context.watch<TeacherHomeCubit>().state;
    if (homeState is TeacherHomeLoaded && homeState.groups.isNotEmpty) {
      final subjects = homeState.groups
          .map((g) => g.subject)
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();
      if (subjects.isNotEmpty) return subjects.join(', ');
    }
    return 'Science, Mathematics';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.neutral400),
        SizedBox(width: AppSpacing.spacingMd.w),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.profileData});

  final TeacherProfileEntity profileData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _GlowStatCard(
                color: AppColors.brandPrimary500,
                icon: Icons.person_outline_rounded,
                value: '${profileData.totalStudentsCount}',
                label: context.l10n.teacherTotalStudents,
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Expanded(
              child: _GlowStatCard(
                color: AppColors.brandSecondary500,
                icon: Icons.people_outline_rounded,
                value: '${profileData.groupCount}',
                label: context.l10n.teacherActiveGroups,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.spacingMd.h),
        Row(
          children: [
            Expanded(
              child: _GlowStatCard(
                color: AppColors.brandAccent500,
                icon: Icons.route_outlined,
                value: '${profileData.roadmapsCreated}',
                label: context.l10n.teacherRoadmapsCreated,
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Expanded(
              child: _GlowStatCard(
                color: AppColors.success500,
                icon: Icons.timelapse_outlined,
                value: '${profileData.yearsTeaching}',
                label: context.l10n.teacherYearsTeaching,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GlowStatCard extends StatelessWidget {
  const _GlowStatCard({
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.radiusXl.r);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(color, AppColors.white, 0.12) ?? color,
        color,
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Gradient background
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),
            // White half-ellipse glow at top — full width
            Positioned(
              top: -70.h,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: SizedBox(
                      width: 250.w,
                      height: 150.w,
                    ),
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.spacingLg.w,
                  AppSpacing.spacing2xl.h,
                  AppSpacing.spacingLg.w,
                  AppSpacing.spacing2xl.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 32.sp, color: AppColors.white),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    Text(
                      value,
                      textAlign: TextAlign.center,
                      style: AppTypography.h5(color: AppColors.white),
                    ),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

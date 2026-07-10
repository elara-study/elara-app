import 'package:elara/features/parent/presentation/children/widgets/parent_add_child_sheet.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/parent/domain/profile/entities/parent_profile_entity.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentProfileOverviewBody extends StatelessWidget {
  const ParentProfileOverviewBody({
    super.key,
    required this.user,
    required this.profileData,
  });

  final UserEntity? user;
  final ParentProfileEntity profileData;

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

          // Avatar & Name
          Center(
            child: CircleAvatar(
              radius: 46.r,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.person_rounded,
                size: 52.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.spacingMd.h),
          Text(
            user?.fullName ?? 'Parent Name',
            textAlign: TextAlign.center,
            style: AppTypography.h4(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),

          // Contact Info Card
          Container(
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.email_rounded,
                      size: 16.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: AppSpacing.spacingMd.w),
                    Text(
                      user?.email ?? 'email@example.com',
                      style: AppTypography.labelMedium(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 16.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: AppSpacing.spacingMd.w),
                    Text(
                      profileData.phoneNumber,
                      style: AppTypography.labelMedium(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.spacingXl.h),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _ParentStatCard(
                  color: AppColors.brandPrimary500, // Blueish grey
                  icon: Icons.check_rounded,
                  label: 'Avg. Completion',
                  value: '${profileData.averageCompletionPercentage}%',
                ),
              ),
              SizedBox(width: AppSpacing.spacingMd.w),
              Expanded(
                child: _ParentStatCard(
                  color: AppColors.brandSecondary500, // Orange
                  icon: Icons.login_rounded, // Similar to right-arrow out
                  label: 'Avg. Attendance',
                  value: '${profileData.averageAttendancePercentage}%',
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),

          // Children Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Children',
                style: AppTypography.h5(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              ElevatedButton(
                onPressed: () => showParentAddChildSheet(
                  context,
                  context.read<ParentChildrenCubit>(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary500,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                  minimumSize: Size(0, 32.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add',
                      style: AppTypography.labelSmall(color: AppColors.white),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.add_rounded, size: 14.sp),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacingLg.h),

          // Children Row
          BlocBuilder<ParentChildrenCubit, ParentChildrenState>(
            builder: (context, childrenState) {
              if (childrenState is ParentChildrenLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (childrenState is ParentChildrenLoaded) {
                final children = childrenState.dashboard.children;
                if (children.isEmpty) {
                  return Text(
                    'No children linked yet.',
                    style: AppTypography.bodyMedium(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                }
                return Wrap(
                  spacing: AppSpacing.spacingXl.w,
                  runSpacing: AppSpacing.spacingLg.h,
                  children: children.map((child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.person_rounded,
                            size: 32.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: AppSpacing.spacingSm.h),
                        Text(
                          child.displayName.split(' ').first,
                          style: AppTypography.labelSmall(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }
              return const SizedBox();
            },
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}

class _ParentStatCard extends StatelessWidget {
  const _ParentStatCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.spacingLg.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: AppColors.white),
              SizedBox(width: AppSpacing.spacingXs.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelSmall(color: AppColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacingMd.h),
          Text(value, style: AppTypography.h4(color: AppColors.white)),
        ],
      ),
    );
  }
}

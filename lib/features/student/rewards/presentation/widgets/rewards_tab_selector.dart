import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/rewards/presentation/cubits/rewards_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardsTabSelector extends StatelessWidget {
  /// 0 = Badges, 1 = Leaderboard.
  final int activeTab;

  const RewardsTabSelector({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: LightModeColors.surfacePrimary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          _TabItem(label: 'Badges', index: 0, activeTab: activeTab),
          _TabItem(label: 'Leaderboard', index: 1, activeTab: activeTab),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final int activeTab;

  const _TabItem({
    required this.label,
    required this.index,
    required this.activeTab,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<RewardsCubit>().switchTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.spacingXs.h,
            horizontal: AppSpacing.spacing2xs.w,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.brandPrimary500
                : LightModeColors.surfacePrimary,
            borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.button(
              color: isActive
                  ? AppColors.neutral50
                  : LightModeColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

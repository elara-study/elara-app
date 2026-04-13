import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_state.dart';
import 'package:elara/features/student/presentation/widgets/learn/join_group_sheet.dart';
import 'package:elara/features/student/presentation/widgets/learn/subject_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  void _openJoinSheet(BuildContext context) {
    JoinGroupDialog.show(context, context.read<StudentLearnCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightModeColors.surfaceApp,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Pinned header — never scrolls ───────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learn',
                    style: AppTypography.h3(color: LightModeColors.textPrimary),
                  ),

                  SizedBox(height: 20.h),

                  // My Groups header row + Join button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Groups',
                            style: AppTypography.h6(
                              color: LightModeColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Your enrolled classes',
                            style: AppTypography.bodySmall(
                              color: LightModeColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      OutlinedButton.icon(
                        onPressed: () => _openJoinSheet(context),
                        icon: SvgPicture.asset(
                          'assets/icons/join_icon.svg',
                          width: 16.w,
                          height: 16.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.brandPrimary500,
                            BlendMode.srcIn,
                          ),
                        ),
                        label: Text(
                          'Join',
                          style: AppTypography.button(
                            color: AppColors.brandPrimary500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.brandPrimary500,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Scrollable group cards — header above never moves ────────
            Expanded(
              child: BlocBuilder<StudentLearnCubit, StudentLearnState>(
                builder: (context, state) {
                  if (state is StudentLearnLoading ||
                      state is StudentLearnInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is StudentLearnError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<StudentLearnCubit>().loadGroups(),
                    );
                  }
                  if (state is StudentLearnLoaded) {
                    if (state.groups.isEmpty) {
                      return _EmptyGroupsView(
                        onJoin: () => _openJoinSheet(context),
                      );
                    }
                    return ListView.separated(
                      // Horizontal padding applied here so ListView edges align
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                      itemCount: state.groups.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, index) => SubjectGroupCard(
                        group: state.groups[index],
                        onTap: () {
                          // TODO: Navigate to group detail
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyGroupsView extends StatelessWidget {
  final VoidCallback onJoin;

  const _EmptyGroupsView({required this.onJoin});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.groups_outlined, size: 52.sp, color: AppColors.neutral300),
          SizedBox(height: 12.h),
          Text(
            'No groups yet',
            style: AppTypography.h6(color: LightModeColors.textPrimary),
          ),
          SizedBox(height: 6.h),
          Text(
            'Ask your teacher for a group code\nand tap Join to get started.',
            style: AppTypography.bodySmall(
              color: LightModeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: onJoin,
            icon: SvgPicture.asset(
              'assets/icons/join_icon.svg',
              width: 18.w,
              height: 18.w,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              'Join a Group',
              style: AppTypography.button(color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandPrimary500,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48.sp,
            color: AppColors.neutral300,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: AppTypography.bodyMedium(
              color: LightModeColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Try again',
              style: AppTypography.button(color: AppColors.brandPrimary500),
            ),
          ),
        ],
      ),
    );
  }
}

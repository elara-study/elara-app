import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_state.dart';
import 'package:elara/features/student/presentation/widgets/learn/join_group_sheet.dart';
import 'package:elara/shared/widgets/subject_group_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  void _openJoinSheet(BuildContext context) {
    JoinGroupDialog.show(context, context.read<StudentLearnCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const AppGlassHeader(title: 'Learn'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.spacingLg.w,
          right: AppSpacing.spacingLg.w,
          top: kToolbarHeight + 62.h,
          bottom: 120.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MyGroupsHeaderRow(onJoin: () => _openJoinSheet(context)),
            SizedBox(height: AppSpacing.spacing2xl.h),
            BlocBuilder<StudentLearnCubit, StudentLearnState>(
              builder: (context, state) {
                if (state is StudentLearnLoading ||
                    state is StudentLearnInitial) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.spacing5xl.h),
                      child: const CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is StudentLearnError) {
                  return Padding(
                    padding: EdgeInsets.only(top: AppSpacing.spacing5xl.h),
                    child: _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<StudentLearnCubit>().loadGroups(),
                    ),
                  );
                }
                if (state is StudentLearnLoaded) {
                  if (state.groups.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: AppSpacing.spacing5xl.h),
                      child: _EmptyGroupsView(
                        onJoin: () => _openJoinSheet(context),
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.groups.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSpacing.spacingMd.h),
                    itemBuilder: (_, index) {
                      final g = state.groups[index];
                      return SubjectGroupCard(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.studentGroup,

                            arguments: g,
                          );
                        },
                        group: g,
                        variant: SubjectGroupCardVariant.student,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MyGroupsHeaderRow extends StatelessWidget {
  final VoidCallback onJoin;

  const _MyGroupsHeaderRow({required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Groups',
              style: AppTypography.h3(
                color: cs.onSurface,
              ).copyWith(fontWeight: AppTypography.black),
            ),
            Text(
              'Your enrolled classes',
              style: AppTypography.bodyLarge(
                color: cs.onSurfaceVariant,
              ).copyWith(fontWeight: AppTypography.regular),
            ),
          ],
        ),
        OutlinedButton.icon(
          onPressed: onJoin,
          icon: SvgPicture.asset(
            'assets/icons/join_icon.svg',
            width: AppSpacing.spacingLg.w,
            height: AppSpacing.spacingLg.w,
            colorFilter: const ColorFilter.mode(
              ButtonColors.outlineText,
              BlendMode.srcIn,
            ),
          ),
          label: Text(
            'Join',
            style: AppTypography.labelLarge(color: ButtonColors.outlineText),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: ButtonColors.outlineText, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyGroupsView extends StatelessWidget {
  final VoidCallback onJoin;

  const _EmptyGroupsView({required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.groups_outlined, size: 52.sp, color: AppColors.neutral300),
          SizedBox(height: AppSpacing.spacingMd.h),
          Text('No groups yet', style: AppTypography.h6(color: cs.onSurface)),
          SizedBox(height: 6.h),
          Text(
            'Ask your teacher for a group code\nand tap Join to get started.',
            style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.spacingXl.h),
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
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48.sp,
            color: AppColors.neutral300,
          ),
          SizedBox(height: AppSpacing.spacingLg.h),
          Text(
            message,
            style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.spacingXl.h),
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

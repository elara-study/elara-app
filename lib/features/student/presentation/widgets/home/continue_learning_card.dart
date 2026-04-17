import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/course_progress_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

class ContinueLearningCard extends StatelessWidget {
  final CourseProgressEntity progress;
  final VoidCallback? onTap;

  const ContinueLearningCard({super.key, required this.progress, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: _cardDecoration,
        child: Stack(
          children: [
            const Positioned.fill(child: _DecorativeCircles()),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.spacing3xl.h,
                horizontal: AppSpacing.spacingLg.w,
              ),
              child: Row(
                children: [
                  Expanded(child: _CardContent(progress: progress)),
                  const _PlayButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.brandPrimary600, AppColors.brandPrimary400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
  );
}

// background circles
class _DecorativeCircles extends StatelessWidget {
  const _DecorativeCircles();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _circle(right: -40, top: -40, alpha: 0.2),
        _circle(left: -20, bottom: -50, alpha: 0.09),
      ],
    );
  }

  Widget _circle({
    double? right,
    double? left,
    double? top,
    double? bottom,
    required double alpha,
  }) {
    return Positioned(
      right: right,
      left: left,
      top: top,
      bottom: bottom,
      child: Container(
        width: 128.r,
        height: 128.r,
        decoration: BoxDecoration(
          color: AppColors.brandPrimary50.withValues(alpha: alpha),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

//   Main Content
class _CardContent extends StatelessWidget {
  final CourseProgressEntity progress;

  const _CardContent({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CaptionRow(),
        SizedBox(height: AppSpacing.spacingMd.h),

        Text(
          progress.courseName,
          style: AppTypography.h5(
            color: AppColors.neutral50,
          ).copyWith(fontWeight: FontWeight.w900),
        ),

        SizedBox(height: AppSpacing.spacingMd.h),

        _LessonRow(progress: progress),

        SizedBox(height: AppSpacing.spacingXs.h),
        _ProgressBar(progress: progress),
      ],
    );
  }
}

//   Caption
class _CaptionRow extends StatelessWidget {
  const _CaptionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/time_icon.svg',
          width: 16.sp,
          height: 16.sp,
          colorFilter: const ColorFilter.mode(
            AppColors.neutral200,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: AppSpacing.spacingSm.w),
        Text(
          'Continue where you left off',
          style: AppTypography.bodyMedium(color: AppColors.neutral200),
        ),
      ],
    );
  }
}

//   Lesson + %
class _LessonRow extends StatelessWidget {
  final CourseProgressEntity progress;

  const _LessonRow({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          progress.lessonLabel,
          style: AppTypography.bodyMedium(color: AppColors.neutral50),
        ),
        Text(
          '${(progress.progressPercent * 100).round()}%',
          style: AppTypography.bodyMedium(color: AppColors.neutral50),
        ),
      ],
    );
  }
}

//   Progress Bar
class _ProgressBar extends StatelessWidget {
  final CourseProgressEntity progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
        child: LinearProgressIndicator(
          value: progress.progressPercent,
          minHeight: AppSpacing.spacingSm.h,
          backgroundColor: AppColors.brandPrimary100.withValues(alpha: 0.5),
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.brandPrimary700,
          ),
        ),
      ),
    );
  }
}

//   Play Button
class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        color: ButtonColors.secondaryReversedDefault,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ButtonColors.secondaryReversedDefault.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: SvgPicture.asset(
        'assets/icons/video_player_icon.svg',
        width: 24.r,
        height: 24.r,
        fit: BoxFit.scaleDown,
        colorFilter: const ColorFilter.mode(
          ButtonColors.primaryReversedText,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

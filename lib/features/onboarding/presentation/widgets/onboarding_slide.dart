import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data

/// Immutable data for a single onboarding slide.
class OnboardingSlideData {
  final String imagePath;
  final String title;

  /// Word inside [title] to render in [AppColors.brandPrimary500].
  /// Pass an empty string when no highlight is needed.
  final String highlightedWord;
  final String subtitle;

  const OnboardingSlideData({
    required this.imagePath,
    required this.title,
    required this.highlightedWord,
    required this.subtitle,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget

/// Renders one onboarding slide: illustration → heading → body text.
///
/// Figma node 1649-12579 layout:
///   34 px top gap → 255×340 image (r=32, shadow) → 32 px → title → 16 px → subtitle
class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.data});

  final OnboardingSlideData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing2xl.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.spacing4xl.h), // ≈ 34 px top gap
          _SlideImage(imagePath: data.imagePath),
          SizedBox(height: AppSpacing.spacing3xl.h), // 32 px
          _SlideTitle(title: data.title, highlightedWord: data.highlightedWord),
          SizedBox(height: AppSpacing.spacingLg.h), // 16 px
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(color: AppColors.neutral600),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets

class _SlideImage extends StatelessWidget {
  const _SlideImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.radiusXl.r); // 32 px
    return Container(
      width: 255.w,
      height: 340.h,
      decoration: BoxDecoration(borderRadius: radius),
      child: ClipRRect(
        borderRadius: radius,
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholderBuilder: (_) => ColoredBox(
            color: AppColors.brandPrimary100,
            child: Center(
              child: SizedBox(
                width: 32.r,
                height: 32.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlideTitle extends StatelessWidget {
  const _SlideTitle({required this.title, required this.highlightedWord});

  final String title;
  final String highlightedWord;

  @override
  Widget build(BuildContext context) {
    final base = AppTypography.display3(color: AppColors.brandPrimary800);
    final idx = highlightedWord.isEmpty ? -1 : title.indexOf(highlightedWord);

    final InlineSpan span = idx == -1
        ? TextSpan(text: title, style: base)
        : TextSpan(
            style: base,
            children: [
              if (idx > 0) TextSpan(text: title.substring(0, idx)),
              TextSpan(
                text: highlightedWord,
                style: base.copyWith(color: AppColors.brandPrimary500),
              ),
              if (idx + highlightedWord.length < title.length)
                TextSpan(text: title.substring(idx + highlightedWord.length)),
            ],
          );

    return RichText(textAlign: TextAlign.center, text: span);
  }
}

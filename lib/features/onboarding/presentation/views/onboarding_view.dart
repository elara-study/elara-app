import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:elara/features/onboarding/presentation/widgets/onboarding_slide.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingSeen = 'onboarding_seen';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingSlideData> get _slides => [
        OnboardingSlideData(
          imagePath: 'assets/images/onboarding1.svg',
          title: context.l10n.onboardingSlide1Title,
          highlightedWord: context.l10n.onboardingSlide1Highlight,
          subtitle: context.l10n.onboardingSlide1Subtitle,
        ),
        OnboardingSlideData(
          imagePath: 'assets/images/onboarding2.svg',
          title: context.l10n.onboardingSlide2Title,
          highlightedWord: context.l10n.onboardingSlide2Highlight,
          subtitle: context.l10n.onboardingSlide2Subtitle,
        ),
        OnboardingSlideData(
          imagePath: 'assets/images/onboarding3.svg',
          title: context.l10n.onboardingSlide3Title,
          highlightedWord: context.l10n.onboardingSlide3Highlight,
          subtitle: context.l10n.onboardingSlide3Subtitle,
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingSeen, true);
    if (!mounted) return;
    AppNavigation.goNamed(context, AppRoutes.login);
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    final isFirst = _currentPage == 0;
    final isLast = _currentPage == slides.length - 1;

    return Scaffold(
      body: DecoratedBox(
        // Figma gradient: brandPrimary50 → brandPrimary100
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.brandPrimary50, AppColors.brandPrimary100],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar: 3-segment progress + SKIP ─────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingLg.w, // 16 px
                  vertical: AppSpacing.spacingLg.h, // 16 px
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SegmentedProgressBar(
                        current: _currentPage,
                        total: slides.length,
                      ),
                    ),
                    SizedBox(width: AppSpacing.spacingLg.w),
                    // SKIP — hidden on last slide
                    AnimatedOpacity(
                      opacity: isLast ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: isLast ? null : _finishOnboarding,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          context.l10n.commonSkip.toUpperCase(),
                          style: AppTypography.labelSmall(
                            color: AppColors.brandPrimary500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Slides ──────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (p) => setState(() => _currentPage = p),
                  itemCount: slides.length,
                  itemBuilder: (_, i) => OnboardingSlide(data: slides[i]),
                ),
              ),

              // ── Navigation buttons ───────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.spacing2xl.w, // 24 px
                  AppSpacing.spacing3xl.h, // 32 px top gap
                  AppSpacing.spacing2xl.w, // 24 px
                  AppSpacing.spacing5xl.h, // 40 px bottom
                ),
                child: isFirst
                    ? SizedBox(
                        width: double.infinity,
                        // AppPrimaryButton with capsule shape override
                        child: AppPrimaryButton(
                          text: context.l10n.commonContinue,
                          onPressed: _nextPage,
                          icon: Icons.arrow_forward_rounded,
                          borderRadius: BorderRadius.circular(
                            AppRadius.radiusFull,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          _BackButton(onTap: _prevPage),
                          SizedBox(width: AppSpacing.spacing2xl.w), // 24 px
                          Expanded(
                            child: AppPrimaryButton(
                              text: isLast ? context.l10n.commonGetStarted : context.l10n.commonContinue,
                              onPressed: _nextPage,
                              icon: Icons.arrow_forward_rounded,
                              borderRadius: BorderRadius.circular(
                                AppRadius.radiusFull,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private widgets

/// Three equal capsule segments; segments up to and including [current]
/// are filled with brandPrimary700, the rest with brandPrimary100 @ 50 %.
class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i <= current;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(
              right: i < total - 1 ? AppSpacing.spacingXs.w : 0, // 4 px gap
            ),
            height: 8.h,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.brandPrimary700
                  : AppColors.brandPrimary100.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            ),
          ),
        );
      }),
    );
  }
}

/// Circular outlined back button (48×48).
/// AppOutlineButton uses RoundedRectangleBorder and renders text alongside
/// the icon, making it unsuitable for an icon-only circle. This thin private
/// widget is the cleanest approach for this specific case.
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandPrimary500,
          side: const BorderSide(color: AppColors.brandPrimary500),
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Icon(Icons.arrow_back_rounded, size: 20.sp),
      ),
    );
  }
}

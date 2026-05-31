import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key — must match the one used in [OnboardingView].
const _kOnboardingSeen = 'onboarding_seen';

// ── Timing constants ──────────────────────────────────────────────────────────
const _kLogoDuration = Duration(milliseconds: 900);
const _kShimmerDelay = Duration(milliseconds: 700);
const _kShimmerDuration = Duration(milliseconds: 700);
const _kTaglineDelay = Duration(milliseconds: 600);
const _kTaglineDuration = Duration(milliseconds: 500);
const _kExitDelay = Duration(milliseconds: 1900);
const _kExitDuration = Duration(milliseconds: 400);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Logo: elastic scale + fade ──────────────────────────────────────────────
  late final AnimationController _logoCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // ── Shimmer sweep across the logo ───────────────────────────────────────────
  late final AnimationController _shimmerCtrl;
  late final Animation<double> _shimmerPos; // 0 → 1 left-to-right

  // ── Tagline slide-up + fade ─────────────────────────────────────────────────
  late final AnimationController _taglineCtrl;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  // ── Exit fade-out ───────────────────────────────────────────────────────────
  late final AnimationController _exitCtrl;
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    // ── Logo controller ──────────────────────────────────────────────────────
    _logoCtrl = AnimationController(vsync: this, duration: _kLogoDuration);
    _logoScale = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // ── Shimmer controller ───────────────────────────────────────────────────
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: _kShimmerDuration,
    );
    _shimmerPos = Tween<double>(
      begin: -0.6,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    // ── Tagline controller ───────────────────────────────────────────────────
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: _kTaglineDuration,
    );
    _taglineFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut));
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut));

    // ── Exit controller ──────────────────────────────────────────────────────
    _exitCtrl = AnimationController(vsync: this, duration: _kExitDuration);
    _exitFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));

    _startSequence();
  }

  Future<void> _startSequence() async {
    // 1. Logo pops in.
    await _logoCtrl.forward();

    // 2. Shimmer sweeps across the logo after a short pause.
    await Future.delayed(_kShimmerDelay);
    _shimmerCtrl.forward();

    // 3. Tagline slides up, staggered from the shimmer start.
    await Future.delayed(_kTaglineDelay);
    _taglineCtrl.forward();

    // 4. Brief hold, then navigate.
    await Future.delayed(_kExitDelay);
    if (!mounted) return;
    await _exitCtrl.forward();
    if (!mounted) return;
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool(_kOnboardingSeen) ?? false;

    if (!mounted) return;

    if (!onboardingSeen) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    } else {
      context.read<AuthCubit>().checkAuthStatus();
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _shimmerCtrl.dispose();
    _taglineCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppRoutes.navigateAfterAuth(context, state.user);
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _exitFade,
          builder: (context, child) =>
              Opacity(opacity: _exitFade.value, child: child),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.neutral900, AppColors.neutral800]
                    : [AppColors.brandPrimary50, AppColors.brandPrimary100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo (scale + fade) + shimmer overlay ──────────────
                AnimatedBuilder(
                  animation: Listenable.merge([_logoCtrl, _shimmerCtrl]),
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: _ShimmerLogo(
                          shimmerProgress: _shimmerPos.value,
                          isDark: isDark,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: AppSpacing.spacingSm.h),

                // ── Elara wordmark ─────────────────────────────────────
                AnimatedBuilder(
                  animation: Listenable.merge([_logoCtrl, _shimmerCtrl]),
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: SvgPicture.asset(
                          'assets/images/elara.svg',
                          width: 162.w,
                          height: 49.w,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: AppSpacing.spacingMd.h),

                // ── Tagline slides up ──────────────────────────────────
                FadeTransition(
                  opacity: _taglineFade,
                  child: SlideTransition(
                    position: _taglineSlide,
                    child: Text(
                      'Learn. Grow. Succeed.',
                      style: AppTypography.bodySmall(
                        color: isDark
                            ? AppColors.neutral400
                            : AppColors.brandPrimary500,
                      ).copyWith(letterSpacing: 1.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// _ShimmerLogo — logo SVG with a diagonal light-streak overlay that sweeps
// left-to-right when [shimmerProgress] goes from −0.6 → 1.6.
// -----------------------------------------------------------------------------

class _ShimmerLogo extends StatelessWidget {
  final double shimmerProgress; // −0.6 → 1.6
  final bool isDark;

  const _ShimmerLogo({required this.shimmerProgress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        // A narrow diagonal highlight band that slides across the widget.
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.transparent,
            isDark
                ? Colors.white.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.55),
            Colors.transparent,
            Colors.transparent,
          ],
          stops: [
            0.0,
            (shimmerProgress - 0.15).clamp(0.0, 1.0),
            shimmerProgress.clamp(0.0, 1.0),
            (shimmerProgress + 0.15).clamp(0.0, 1.0),
            1.0,
          ],
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 162.w,
        height: 95.65.w,
      ),
    );
  }
}

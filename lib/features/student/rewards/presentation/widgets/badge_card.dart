import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/rewards/domain/entities/badge_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeCard extends StatelessWidget {
  final BadgeEntity badge;
  const BadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;

    final cardColor = isUnlocked
        ? AppColors.brandAccent500
        : Theme.of(context).colorScheme.surface;

    final circleColor = isUnlocked
        ? AppColors.brandPrimary50.withValues(alpha: 0.2)
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);

    final iconAsset = isUnlocked
        ? 'assets/icons/rewards_icon_filled.svg'
        : 'assets/icons/lock_icon.svg';

    final iconColor = isUnlocked
        ? AppColors.brandAccent50
        : Theme.of(context).colorScheme.onSurfaceVariant;

    final iconSize = isUnlocked ? 24.w : 32.w;

    final textColor = isUnlocked
        ? AppColors.brandAccent50
        : Theme.of(context).colorScheme.onSurfaceVariant;

    final descColor = isUnlocked
        ? AppColors.brandAccent50
        : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    final hasProgress = !isUnlocked && badge.progressTotal > 0;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top dome circle with icon ─────────────────────────────────
            SizedBox(
              height: 90.h,
              width: double.infinity,
              child: CustomPaint(
                painter: _TopCirclePainter(color: circleColor),
                child: Center(
                  child: SvgPicture.asset(
                    iconAsset,
                    width: iconSize,
                    height: iconSize,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                ),
              ),
            ),

            // ── Name + description (+ progress bar for locked) ────────────
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.spacingLg.w,
                right: AppSpacing.spacingLg.w,
                bottom: AppSpacing.spacing3xl.h,
              ),
              child: Transform.translate(
                offset: Offset(0, -8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      badge.name,
                      textAlign: TextAlign.center,
                      style: AppTypography.h6(
                        color: textColor,
                      ).copyWith(fontWeight: AppTypography.extraBold),
                    ),
                    Text(
                      badge.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall(color: descColor),
                    ),
                    if (hasProgress) ...[
                      SizedBox(height: AppSpacing.spacingLg.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusFull.r,
                        ),
                        child: LinearProgressIndicator(
                          value: badge.progressPercent,
                          minHeight: 5.h,
                          backgroundColor: AppColors.brandPrimary100,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.brandPrimary700,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${badge.progressCurrent}/${badge.progressTotal}',
                        style: AppTypography.bodySmall(color: textColor),
                      ),
                    ],
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

// ── Painter: large circle whose center sits above the card top ────────────────
// Only the lower dome is visible inside the SizedBox, matching the Figma style.

class _TopCirclePainter extends CustomPainter {
  final Color color;
  const _TopCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.68;
    final centerY = size.height * 0.85 - radius;
    canvas.drawCircle(
      Offset(size.width / 2, centerY),
      radius,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_TopCirclePainter old) => old.color != color;
}

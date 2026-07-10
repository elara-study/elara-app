import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/notifications/domain/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.spacingLg.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: AppShadows.elevationLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: SvgPicture.asset(
                _resolveIcon(notification.type),
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  _resolveColor(notification.type),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.spacingMd.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            notification.type,
                            style: AppTypography.labelRegular(
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!notification.isRead) ...[
                            SizedBox(width: 6.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: cs.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.spacingSm.w),
                    Text(
                      _formatDate(notification.notificationDate),
                      style: AppTypography.caption(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacing2xs.h),
                Text(
                  notification.message,
                  style: AppTypography.bodySmall(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _resolveIcon(String type) {
    if (type.toLowerCase().contains('lesson')) {
      return 'assets/icons/book_icon.svg';
    }
    if (type.toLowerCase().contains('achievement')) {
      return 'assets/icons/rewards_icon.svg';
    }
    if (type.toLowerCase().contains('announcement')) {
      return 'assets/icons/alerts_icon_filled.svg';
    }
    return 'assets/icons/alerts_icon_filled.svg';
  }

  Color _resolveColor(String type) {
    if (type.toLowerCase().contains('lesson')) {
      return AppColors.brandPrimary500;
    }
    if (type.toLowerCase().contains('achievement')) {
      return AppColors.brandAccent500;
    }
    if (type.toLowerCase().contains('announcement')) {
      return AppColors.brandSecondary500;
    }
    return AppColors.brandPrimary500;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hour ago';
    if (diff.inDays < 7) return '${diff.inDays} day ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

import 'package:elara/config/app_router.dart' show AppRoutes;
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/notifications/presentation/cubits/notifications_cubit.dart';
import 'package:elara/features/notifications/presentation/cubits/notifications_state.dart';
import 'package:elara/features/notifications/presentation/widgets/notification_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..loadNotifications(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppGlassHeader(
          title: 'Notifications',
          actions: [
            IconButton(
              onPressed: () => context.push(AppRoutes.notificationsSettings),
              icon: SvgPicture.asset(
                'assets/icons/settings_icon.svg',
                height: AppIconSizes.iconSm.h,
                width: AppIconSizes.iconSm.w,
                colorFilter: ColorFilter.mode(cs.onSurface, BlendMode.srcIn),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingLg.w,
              ),
              child: _NotificationsList(state: state),
            );
          },
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  final NotificationsState state;
  const _TopRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final unreadCount = switch (state) {
      NotificationsLoaded(:final unreadCount) => unreadCount,
      _ => 0,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => context.read<NotificationsCubit>().markAllAsRead(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/done_all_icon.svg',
                height: 16.w,
                width: 16.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandPrimary500,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.spacingXs.w),
              Text(
                'Mark all as read',
                style: AppTypography.labelSmall(
                  color: AppColors.brandPrimary500,
                ),
              ),
            ],
          ),
        ),
        Text(
          '$unreadCount unread',
          style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final NotificationsState state;
  const _NotificationsList({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      NotificationsLoading() =>
        const Center(child: CircularProgressIndicator()),
      NotificationsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.sp,
              color: AppColors.error400,
            ),
            SizedBox(height: AppSpacing.spacingMd.h),
            Text(
              message,
              style: AppTypography.bodyMedium(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      NotificationsLoaded(:final notifications) when notifications.isEmpty =>
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 48.sp,
                color: AppColors.neutral300,
              ),
              SizedBox(height: AppSpacing.spacingMd.h),
              Text(
                'No notifications yet',
                style: AppTypography.h5(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'You\'re all caught up!',
                style: AppTypography.bodyMedium(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      NotificationsLoaded(:final notifications) => ListView.builder(
        padding: EdgeInsets.only(
          top: kToolbarHeight + 62.h,
          bottom: 120.h,
        ),
        itemCount: notifications.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.spacing2xl.h),
              child: _TopRow(state: state),
            );
          }
          final notification = notifications[index - 1];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              onTap: () {
                if (!notification.isRead) {
                  context.read<NotificationsCubit>().markAsRead(notification.id);
                }
              },
              child: NotificationCard(
                notification: notification,
              ),
            ),
          );
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

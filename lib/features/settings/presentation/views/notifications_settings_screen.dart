import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/settings/presentation/cubits/notifications_settings_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/notifications_settings_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/settings/settings_section_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsSettingsCubit, NotificationsSettingsState>(
      builder: (context, state) {
        final cs = Theme.of(context).colorScheme;
        final cubit = context.read<NotificationsSettingsCubit>();
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppGlassHeader(
            title: 'Notifications',
            titleStyle: AppTypography.h4(
              color: cs.onSurface,
              font: AppTypography.comfortaa,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSpacing.spacingLg.w,
              right: AppSpacing.spacingLg.w,
              top: AppSpacing.spacing2xl.h,
              bottom: AppSpacing.spacing3xl.h,
            ),
            child: SettingsSectionList(
              children: [
                SettingsToggleTile(
                  label: 'Streak Reminders',
                  value: state.streakRemindersEnabled,
                  onChanged: cubit.setStreakReminders,
                ),
                SettingsToggleTile(
                  label: 'Homework Reminders',
                  value: state.homeworkRemindersEnabled,
                  onChanged: cubit.setHomeworkReminders,
                ),
                SettingsToggleTile(
                  label: 'New Lessons',
                  value: state.newLessonsEnabled,
                  onChanged: cubit.setNewLessons,
                ),
                SettingsToggleTile(
                  label: 'AI Progress Reports',
                  value: state.aiProgressReportsEnabled,
                  onChanged: cubit.setAiProgressReports,
                ),
                SettingsToggleTile(
                  label: 'Group Updates',
                  value: state.groupUpdatesEnabled,
                  onChanged: cubit.setGroupUpdates,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

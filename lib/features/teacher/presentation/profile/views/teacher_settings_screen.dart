import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_cubit.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/settings/settings_section_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherSettingsScreen extends StatelessWidget {
  const TeacherSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherProfileCubit, TeacherProfileState>(
      listenWhen: (previous, current) => current.pendingSnackMessage != null,
      listener: (context, profileState) {
        final snack = profileState.pendingSnackMessage;
        if (snack != null) {
          AppSnackBar.info(context, snack);
          context.read<TeacherProfileCubit>().clearSnackMessage();
        }
      },
      builder: (context, profileState) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppGlassHeader(
            title: 'Settings',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSpacing.spacingLg.w,
              right: AppSpacing.spacingLg.w,
              top: kToolbarHeight + 74.h,
              bottom: 32.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    final user = authState is AuthAuthenticated
                        ? authState.user
                        : null;
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingLg.w,
                        vertical: AppSpacing.spacingMd.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusLg.r,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.school_rounded,
                              size: 28.sp,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(width: AppSpacing.spacingMd.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName ?? 'Teacher Name',
                                  style: AppTypography.labelLarge(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  user?.email != null
                                      ? '@${user!.email.split('@').first}'
                                      : '@handle',
                                  style: AppTypography.bodySmall(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                SettingsSectionList(
                  children: [
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      buildWhen: (p, c) => p != c,
                      builder: (context, themeMode) {
                        return SettingsToggleTile(
                          icon: Icons.palette,
                          label: 'Dark Mode',
                          value: ThemeCubit.isDarkActive(context, themeMode),
                          onChanged: (v) =>
                              context.read<ThemeCubit>().setDarkMode(v),
                        );
                      },
                    ),
                    SettingsDenseChipTile(
                      icon: Icons.language_rounded,
                      label: 'Language',
                      trailingLabel: 'English',
                      onTap: () => context
                          .read<TeacherProfileCubit>()
                          .requestPlaceholderSnack(
                            'Language picker coming soon.',
                          ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                SettingsSectionList(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.person_rounded,
                      label: 'Profile & Account',
                      onTap: () => AppNavigation.pushNamed(
                        context,
                        AppRoutes.profileAccount,
                        arguments: UserRole.teacher,
                      ),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.shield,
                      label: 'Password & Security',
                      onTap: () => AppNavigation.pushNamed(
                        context,
                        AppRoutes.passwordSecurity,
                      ),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.notifications,
                      label: 'Notifications',
                      onTap: () => AppNavigation.pushNamed(
                        context,
                        AppRoutes.notificationsSettings,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                SettingsSectionList(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.people_alt_rounded,
                      label: 'About Us',
                      onTap: () => context
                          .read<TeacherProfileCubit>()
                          .requestPlaceholderSnack('About Us coming soon.'),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.help_outline_rounded,
                      label: 'Contact Support',
                      onTap: () => context
                          .read<TeacherProfileCubit>()
                          .requestPlaceholderSnack(
                            'Contact Support coming soon.',
                          ),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.lightbulb_outline_rounded,
                      label: 'Feedback & Suggestions',
                      onTap: () => context
                          .read<TeacherProfileCubit>()
                          .requestPlaceholderSnack(
                            'Feedback & Suggestions coming soon.',
                          ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                SettingsSectionList(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.logout_rounded,
                      label: 'Log Out',
                      iconColor: Theme.of(context).colorScheme.error,
                      labelColor: Theme.of(context).colorScheme.error,
                      onTap: () => context.read<AuthCubit>().logout(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

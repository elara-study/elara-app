import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
 import 'package:elara/core/localization/locale_constants.dart';
import 'package:elara/core/localization/localization_extension.dart';
 import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/utils/app_snackbar.dart';
 import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_cubit.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/settings/settings_section_list.dart';
import 'package:elara/shared/widgets/settings/language_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentSettingsScreen extends StatelessWidget {
  const ParentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentProfileCubit, ParentProfileState>(
      listenWhen: (previous, current) =>
          current.pendingSnackMessage != null ||
          current.shouldNavigateToLogin,
      listener: (context, profileState) {
        if (profileState.shouldNavigateToLogin) {
          AppNavigation.pushNamedAndRemoveUntil(context, AppRoutes.login);
          return;
        }

        final snack = profileState.pendingSnackMessage;
        if (snack != null) {
          AppSnackBar.info(context, snack);
          context.read<ParentProfileCubit>().clearSnackMessage();
        }
      },
      builder: (context, profileState) {
        final currentLanguage = AppLocaleConstants.supportedLanguages.firstWhere(
          (l) => l.locale.languageCode == Localizations.localeOf(context).languageCode,
          orElse: () => AppLocaleConstants.supportedLanguages.first,
        );

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppGlassHeader(
            title: context.l10n.settingsTitle,
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
                              Icons.person_rounded,
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
                                  user?.fullName ?? context.l10n.parentNameFallback,
                                  style: AppTypography.labelLarge(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  user?.email != null
                                      ? '@${user!.email.split('@').first}'
                                      : context.l10n.parentHandleFallback,
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
                          label: context.l10n.settingsDarkMode,
                          value: ThemeCubit.isDarkActive(context, themeMode),
                          onChanged: (v) =>
                              context.read<ThemeCubit>().setDarkMode(v),
                        );
                      },
                    ),
                    SettingsDenseChipTile(
                      icon: Icons.language_rounded,
                      label: context.l10n.settingsLanguage,
                      trailingLabel: currentLanguage.nativeName,
                      onTap: () => LanguagePickerSheet.show(context),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                SettingsSectionList(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.person_rounded,
                      label: context.l10n.settingsProfileAndAccount,
                      onTap: () => AppNavigation.pushNamed(
                        context,
                        AppRoutes.profileAccount,
                        arguments: UserRole.parent,
                      ),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.shield,
                      label: context.l10n.settingsPasswordAndSecurity,
                      onTap: () => AppNavigation.pushNamed(
                        context,
                        AppRoutes.passwordSecurity,
                      ),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.notifications,
                      label: context.l10n.settingsNotifications,
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
                      label: context.l10n.settingsAboutUs,
                      onTap: () => context
                          .read<ParentProfileCubit>()
                          .requestPlaceholderSnack(context.l10n.parentAboutUsSoon),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.help_outline_rounded,
                      label: context.l10n.settingsContactSupport,
                      onTap: () => context
                          .read<ParentProfileCubit>()
                          .requestPlaceholderSnack(context.l10n.parentContactSupportSoon),
                    ),
                    SettingsNavigationTile(
                      icon: Icons.lightbulb_outline_rounded,
                      label: context.l10n.settingsFeedbackAndSuggestions,
                      onTap: () => context
                          .read<ParentProfileCubit>()
                          .requestPlaceholderSnack(context.l10n.parentFeedbackSoon),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                SettingsSectionList(
                  children: [
                    SettingsNavigationTile(
                      icon: Icons.logout_rounded,
                      label: context.l10n.settingsLogOut,
                      iconColor: Theme.of(context).colorScheme.error,
                      labelColor: Theme.of(context).colorScheme.error,
                      onTap: () => context.read<ParentProfileCubit>().logout(),
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

import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/localization/locale_constants.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_settings_cubit.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_settings_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/settings/settings_card.dart';
import 'package:elara/shared/widgets/settings/settings_section_list.dart';
import 'package:elara/shared/widgets/settings/language_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Student settings — shared layout tokens; rows match the Elara settings
/// frame; other roles can reuse [SettingsCard] / [SettingsSectionList] with
/// different rows.
class StudentSettingsScreen extends StatelessWidget {
  const StudentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentSettingsCubit, StudentSettingsState>(
      listenWhen: (previous, current) =>
          current.pendingSnackMessage != null || current.shouldNavigateToLogin,
      listener: (context, settingsState) {
        if (settingsState.shouldNavigateToLogin) {
          AppNavigation.pushNamedAndRemoveUntil(context, AppRoutes.login);
        }
        final snack = settingsState.pendingSnackMessage;
        if (snack != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(snack)));
          context.read<StudentSettingsCubit>().clearSnackMessage();
        }
      },
      builder: (context, settingsState) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, auth) {
            final user = auth is AuthAuthenticated ? auth.user : null;
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
                    if (user != null) ...[
                      SettingsCard(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28.r,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.person_rounded,
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
                                    user.fullName,
                                    style: AppTypography.h6(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    user.email,
                                    style: AppTypography.bodyMedium(
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
                      ),
                      SizedBox(height: AppSpacing.spacingLg.h),
                    ],
                    SettingsSectionList(
                      children: [
                        BlocBuilder<ThemeCubit, ThemeMode>(
                          buildWhen: (p, c) => p != c,
                          builder: (context, themeMode) {
                            return SettingsToggleTile(
                              icon: Icons.palette,
                              label: context.l10n.settingsDarkMode,
                              value: ThemeCubit.isDarkActive(
                                context,
                                themeMode,
                              ),
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
                            arguments: UserRole.student,
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
                          icon: Icons.groups_2_rounded,
                          label: context.l10n.settingsAboutUs,
                          onTap: () {},
                        ),
                        SettingsNavigationTile(
                          icon: Icons.help_rounded,
                          label: context.l10n.settingsContactSupport,
                          onTap: () {},
                        ),
                        SettingsNavigationTile(
                          icon: Icons.lightbulb_rounded,
                          label: context.l10n.settingsFeedbackAndSuggestions,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    SettingsSectionList(
                      children: [
                        SettingsNavigationTile(
                          icon: Icons.logout_rounded,
                          label: context.l10n.settingsLogOut,
                          labelColor: AppColors.error500,
                          iconColor: AppColors.error500,
                          onTap: () =>
                              context.read<StudentSettingsCubit>().logout(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

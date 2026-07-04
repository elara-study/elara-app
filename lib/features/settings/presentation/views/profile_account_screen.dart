import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/settings/domain/entities/profile_account_entity.dart';
import 'package:elara/features/settings/presentation/cubits/profile_account_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/profile_account_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/settings/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Profile & Account — GET [ApiConstants.settingsProfileAccount] (mock parses
/// JSON via [ProfileAccountModel.fromJson] like production).
class ProfileAccountScreen extends StatelessWidget {
  const ProfileAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocConsumer<ProfileAccountCubit, ProfileAccountState>(
      listenWhen: (p, c) => switch (c) {
        ProfileAccountLoaded(:final pendingSnackMessage) =>
          pendingSnackMessage != null,
        _ => false,
      },
      listener: (context, state) {
        if (state case ProfileAccountLoaded(:final pendingSnackMessage)) {
          if (pendingSnackMessage != null) {
            AppSnackBar.info(context, pendingSnackMessage);
            context.read<ProfileAccountCubit>().clearSnackMessage();
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppGlassHeader(
            title: 'Profile & Account',
            titleStyle: AppTypography.h4(
              color: cs.onSurface,
              font: AppTypography.comfortaa,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          body: switch (state) {
            ProfileAccountInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
            ProfileAccountLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ProfileAccountError(:final message) => Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.spacingLg.w,
                right: AppSpacing.spacingLg.w,
                top: AppSpacing.spacing2xl.h,
              ),
              child: Column(
                children: [
                  Text(
                    message,
                    style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  TextButton(
                    onPressed: () =>
                        context.read<ProfileAccountCubit>().loadProfile(),
                    child: Text(
                      'Try again',
                      style: AppTypography.button(
                        color: AppColors.brandPrimary500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ProfileAccountLoaded(:final profile) => SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.spacingLg.w,
                right: AppSpacing.spacingLg.w,
                top: AppSpacing.spacing2xl.h,
                bottom: AppSpacing.spacing3xl.h,
              ),
              child: _ProfileAccountForm(profile: profile),
            ),
          },
        );
      },
    );
  }
}

class _ProfileAccountForm extends StatelessWidget {
  const _ProfileAccountForm({required this.profile});

  final ProfileAccountEntity profile;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.person_rounded, size: 20.sp, color: cs.onSurface),
                  SizedBox(width: AppSpacing.spacingMd.w),
                  Expanded(
                    child: Text(
                      'Personal Information',
                      style: AppTypography.h5(color: cs.onSurface),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.spacingLg.h),
              _LabeledDisplayField(label: 'Full Name', value: profile.fullName),
              SizedBox(height: AppSpacing.spacingLg.h),
              _LabeledDisplayField(
                label: 'Username',
                value: profile.username,
                leading: Icon(
                  Icons.alternate_email_rounded,
                  size: 16.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.spacingLg.h),
              _LabeledDisplayField(
                label: 'Email',
                value: profile.email,
                leading: Icon(
                  Icons.email_outlined,
                  size: 16.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.spacingLg.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  final argRole =
                      GoRouterState.of(context).extra as UserRole?;
                  final role = argRole ?? (authState is AuthAuthenticated
                      ? authState.user.role
                      : UserRole.student);

                  switch (role) {
                    case UserRole.teacher:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _LabeledDisplayField(
                                  label: 'Phone Number',
                                  value: profile.phoneNumber ?? '+20 10 12345678',
                                  leading: Icon(
                                    Icons.phone_outlined,
                                    size: 16.sp,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.spacingLg.w),
                              Expanded(
                                child: _LabeledDisplayField(
                                  label: 'Subject(s)',
                                  value: profile.subjects?.join(', ') ?? 'Math',
                                  leading: Icon(
                                    Icons.menu_book_rounded,
                                    size: 16.sp,
                                    color: cs.onSurfaceVariant,
                                  ),
                                  trailing: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16.sp,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.spacingLg.h),
                          _LabeledDisplayField(
                            label: 'Country',
                            value: profile.country ?? 'Egypt',
                            leading: Icon(
                              Icons.public_rounded,
                              size: 16.sp,
                              color: cs.onSurfaceVariant,
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16.sp,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );

                    case UserRole.parent:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _LabeledDisplayField(
                            label: 'Phone Number',
                            value: profile.phoneNumber ?? '+20 10 12345678',
                            leading: Icon(
                              Icons.phone_outlined,
                              size: 16.sp,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: AppSpacing.spacingLg.h),
                          _LabeledDisplayField(
                            label: 'Country',
                            value: profile.country ?? 'Egypt',
                            leading: Icon(
                              Icons.public_rounded,
                              size: 16.sp,
                              color: cs.onSurfaceVariant,
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16.sp,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );

                    case UserRole.student:
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _LabeledDisplayField(
                              label: 'Grade',
                              value: profile.grade ?? '7',
                              leading: Icon(
                                Icons.school_outlined,
                                size: 16.sp,
                                color: cs.onSurfaceVariant,
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16.sp,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.spacingLg.w),
                          Expanded(
                            child: _LabeledDisplayField(
                              label: 'Country',
                              value: profile.country ?? 'Egypt',
                              leading: Icon(
                                Icons.public_rounded,
                                size: 16.sp,
                                color: cs.onSurfaceVariant,
                              ),
                              trailing: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16.sp,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                },
              ),
              SizedBox(height: AppSpacing.spacingLg.h),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () =>
                      context.read<ProfileAccountCubit>().saveChanges(),
                  icon: Icon(Icons.save_outlined, size: 16.sp),
                  label: Text(
                    'Save Changes',
                    style: AppTypography.labelSmall(color: cs.onPrimary),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary500,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacingSm.w,
                      vertical: AppSpacing.spacingXs.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.spacing2xl.h),
        DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
            border: Border.all(color: AppColors.error400),
            boxShadow: [
              BoxShadow(
                color: AppColors.error500.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.spacingLg.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Danger Zone',
                  style: AppTypography.h5(color: AppColors.error500),
                ),
                SizedBox(height: AppSpacing.spacingMd.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Permanently delete your account and all of your '
                        'content',
                        style: AppTypography.bodySmall(
                          color: AppColors.error400,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.spacingSm.w),
                    FilledButton(
                      onPressed: () =>
                          context.read<ProfileAccountCubit>().deleteAccount(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.error500,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingSm.w,
                          vertical: AppSpacing.spacingXs.h,
                        ),
                      ),
                      child: Text(
                        'Delete Account',
                        style: AppTypography.labelSmall(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledDisplayField extends StatelessWidget {
  const _LabeledDisplayField({
    required this.label,
    required this.value,
    this.leading,
    this.trailing,
  });

  final String label;
  final String value;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTypography.labelRegular(color: cs.onSurface)),
        SizedBox(height: AppSpacing.spacingXs.h),
        DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingMd.w,
              vertical: AppSpacing.spacingSm.h,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: AppSpacing.spacingSm.w),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

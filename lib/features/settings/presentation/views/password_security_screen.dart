import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/settings/presentation/cubits/password_security_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/password_security_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/settings/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Change-password form (Figma `432:2658`).
class PasswordSecurityScreen extends StatefulWidget {
  const PasswordSecurityScreen({super.key});

  @override
  State<PasswordSecurityScreen> createState() => _PasswordSecurityScreenState();
}

class _PasswordSecurityScreenState extends State<PasswordSecurityScreen> {
  final _current = TextEditingController();
  final _fresh = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _fresh.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordSecurityCubit, PasswordSecurityState>(
      listenWhen: (p, c) => c.pendingSnackMessage != null,
      listener: (context, state) {
        final msg = state.pendingSnackMessage;
        if (msg != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
          final cubit = context.read<PasswordSecurityCubit>();
          if (msg == 'Password updated (demo).') {
            _current.clear();
            _fresh.clear();
            _confirm.clear();
            cubit
              ..setCurrentPassword('')
              ..setNewPassword('')
              ..setConfirmPassword('');
          }
          cubit.clearSnackMessage();
        }
      },
      builder: (context, state) {
        final scheme = Theme.of(context).colorScheme;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppGlassHeader(
            title: 'Password & Security',
            titleStyle: AppTypography.h4(
              color: scheme.onSurface,
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
            child: SettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 20.sp,
                        color: scheme.onSurface,
                      ),
                      SizedBox(width: AppSpacing.spacingMd.w),
                      Expanded(
                        child: Text(
                          'Password',
                          style: AppTypography.h5(color: scheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  _PasswordField(
                    label: 'Current Password',
                    controller: _current,
                    obscure: state.obscureCurrent,
                    onToggleObscure: context
                        .read<PasswordSecurityCubit>()
                        .toggleObscureCurrent,
                  ),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  _PasswordField(
                    label: 'New Password',
                    controller: _fresh,
                    obscure: state.obscureNew,
                    onToggleObscure: context
                        .read<PasswordSecurityCubit>()
                        .toggleObscureNew,
                  ),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  _PasswordField(
                    label: 'Confirm New Password',
                    controller: _confirm,
                    obscure: state.obscureConfirm,
                    onToggleObscure: context
                        .read<PasswordSecurityCubit>()
                        .toggleObscureConfirm,
                  ),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () {
                        final cubit = context.read<PasswordSecurityCubit>();
                        cubit
                          ..setCurrentPassword(_current.text)
                          ..setNewPassword(_fresh.text)
                          ..setConfirmPassword(_confirm.text);
                        cubit.submit();
                      },
                      icon: Icon(Icons.vpn_key_rounded, size: 16.sp),
                      label: Text(
                        'Change Password',
                        style: AppTypography.labelSmall(
                          color: scheme.onPrimary,
                        ),
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
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTypography.labelRegular(color: cs.onSurface)),
        SizedBox(height: AppSpacing.spacingXs.h),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: AppTypography.bodySmall(color: cs.onSurfaceVariant),
            filled: true,
            fillColor: cs.surfaceContainer,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingMd.w,
              vertical: AppSpacing.spacingSm.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18.sp,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

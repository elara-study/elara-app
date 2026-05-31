import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Labelled input field for use inside auth cards.
class AuthCardField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  final ValueNotifier<bool> _obscure = ValueNotifier(true);

  AuthCardField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark
        ? DarkModeColors.surfaceSecondary
        : LightModeColors.surfaceApp;
    final labelColor = isDark
        ? DarkModeColors.textPrimary
        : LightModeColors.textPrimary;
    final focusedBorderColor = isDark
        ? DarkModeColors.borderFocused
        : LightModeColors.borderFocused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelRegular(color: labelColor)),
        const SizedBox(height: AppSpacing.spacing2xs),
        ValueListenableBuilder<bool>(
          valueListenable: _obscure,
          builder: (_, obscure, __) => AppTextField(
            hintText: hint,
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            obscureText: isPassword && obscure,
            fillColor: fillColor,
            borderRadius: AppRadius.radiusMd.sp,
            enabledBorderColor: isDark
                ? DarkModeColors.borderDefault
                : LightModeColors.borderDefault,
            focusedBorderColor: focusedBorderColor,
            errorBorderColor: AppColors.error500,
            showBorder: false,
            suffixIcon: isPassword
                ? IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: isDark
                          ? DarkModeColors.textSecondary
                          : LightModeColors.textSecondary,
                      size: AppIconSizes.iconXs,
                    ),
                    onPressed: () => _obscure.value = !obscure,
                  )
                : null,
            innerShadowColor: isDark
                ? AppColors.black.withValues(alpha: 0.12)
                : AppColors.black.withValues(alpha: 0.04),
            innerShadowBlur: 4,
            innerShadowOffset: const Offset(2, 2),
          ),
        ),
      ],
    );
  }
}

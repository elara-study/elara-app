import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single reusable text field atom for auth screens.

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;

  // Holds the eye-toggle state without needing StatefulWidget.
  final ValueNotifier<bool> _obscureNotifier = ValueNotifier(true);

  AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  OutlineInputBorder buildborder({
    Color color = LightModeColors.borderDefault,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
      borderSide: BorderSide(color: color, width: 1.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelLarge(color: LightModeColors.textPrimary),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _obscureNotifier,
          builder: (context, obscure, _) {
            return TextFormField(
              controller: controller,
              obscureText: isPassword && obscure,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              enabled: enabled,
              style: AppTypography.bodyMedium(
                color: LightModeColors.textPrimary,
              ),
              validator: validator,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTypography.bodySmall(
                  color: LightModeColors.textSecondary,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: LightModeColors.textPrimary,
                          size: 16.sp,
                        ),
                        onPressed: () => _obscureNotifier.value = !obscure,
                      )
                    : null,
                filled: true,
                fillColor: LightModeColors.surfaceApp,
                border: buildborder(),
                enabledBorder: buildborder(),
                focusedBorder: buildborder(
                  color: LightModeColors.borderFocused,
                ),
                errorBorder: buildborder(color: AppColors.error500),
                focusedErrorBorder: buildborder(color: AppColors.error500),
              ),
            );
          },
        ),
      ],
    );
  }
}

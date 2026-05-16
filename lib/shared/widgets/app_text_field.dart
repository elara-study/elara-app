import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A globally shared text field widget.
class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.fillColor,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: AppTypography.bodyMedium(
        color: cs.onSurface,
      ).copyWith(fontWeight: AppTypography.regular),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Theme.of(context).scaffoldBackgroundColor,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingMd.w,
          vertical: AppSpacing.spacingMd.h,
        ),
        hintText: hintText,
        hintStyle: AppTypography.bodySmall(
          color: cs.onSurfaceVariant,
        ).copyWith(fontWeight: AppTypography.regular),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      validator: validator,
    );
  }
}

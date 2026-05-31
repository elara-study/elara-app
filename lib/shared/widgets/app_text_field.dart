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
  final TextInputType? keyboardType;
  final Color? fillColor;
  final ValueChanged<String>? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final VoidCallback? onTap;

  // Border configuration — callers can override for different visual styles.
  final double borderRadius;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final bool showBorder;

  // Inner shadow — null means no shadow (default, matches old behaviour).
  final Color? innerShadowColor;
  final double innerShadowBlur;
  final Offset innerShadowOffset;

  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.keyboardType,
    this.fillColor,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.onTap,
    this.borderRadius = 100,
    this.enabledBorderColor = Colors.transparent,
    this.focusedBorderColor = Colors.transparent,
    this.errorBorderColor = Colors.red,
    this.showBorder = false,
    this.innerShadowColor,
    this.innerShadowBlur = 4,
    this.innerShadowOffset = const Offset(2, 2),
  });

  OutlineInputBorder _border(Color color, {bool forceBorder = false}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: (showBorder || forceBorder)
            ? BorderSide(color: color, width: 1)
            : BorderSide.none,
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final field = TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      enabled: enabled,
      onTap: onTap,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      validator: validator,
      style: AppTypography.bodyMedium(
        color: cs.onSurface,
      ).copyWith(fontWeight: AppTypography.regular),

      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Theme.of(context).scaffoldBackgroundColor,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingMd.w,
          vertical: AppSpacing.spacingSm.h,
        ),
        hintText: hintText,
        hintStyle: AppTypography.bodySmall(
          color: cs.onSurfaceVariant,
        ).copyWith(fontWeight: AppTypography.regular),
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIconConstraints,
        border: _border(enabledBorderColor),
        enabledBorder: _border(enabledBorderColor),
        focusedBorder: _border(focusedBorderColor, forceBorder: true),
        errorBorder: _border(errorBorderColor, forceBorder: true),
        focusedErrorBorder: _border(errorBorderColor, forceBorder: true),
      ),
    );

    if (innerShadowColor == null) return field;

    return Stack(
      children: [
        field,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _InnerShadowPainter(
                color: innerShadowColor!,
                blurRadius: innerShadowBlur,
                offset: innerShadowOffset,
                cornerRadius: borderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  final Color color;
  final double blurRadius;
  final Offset offset;
  final double cornerRadius;

  const _InnerShadowPainter({
    required this.color,
    required this.blurRadius,
    required this.offset,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(cornerRadius),
    );
    canvas.save();
    canvas.clipRRect(rrect);
    final margin = blurRadius * 4;
    final outerPath = Path()
      ..addRect(
        Rect.fromLTWH(
          -margin,
          -margin,
          size.width + margin * 2,
          size.height + margin * 2,
        ),
      );
    final holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
          Radius.circular(cornerRadius),
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, outerPath, holePath),
      Paint()
        ..color = color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InnerShadowPainter old) =>
      old.color != color ||
      old.blurRadius != blurRadius ||
      old.offset != offset ||
      old.cornerRadius != cornerRadius;
}

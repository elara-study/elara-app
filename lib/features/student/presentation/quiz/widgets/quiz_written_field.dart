import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class QuizWrittenField extends StatelessWidget {
  const QuizWrittenField({
    super.key,
    required this.controller,
    this.hintText = 'Type your answer here…',
    this.minLines = 4,
  });

  final TextEditingController controller;
  final String hintText;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final secondary = theme.brightness == Brightness.dark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(AppRadius.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingSm,
          vertical: AppSpacing.spacingSm,
        ),
        child: TextField(
          controller: controller,
          minLines: minLines,
          maxLines: 8,
          style: AppTypography.bodyMedium(color: onSurface),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: AppTypography.bodyMedium(color: secondary),
            isDense: true,
            filled: false,
          ),
        ),
      ),
    );
  }
}

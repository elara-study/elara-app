import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Full-width outline row (e.g. resources) in [ModuleSheet].
class ModuleOutlineRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  const ModuleOutlineRow({
    super.key,
    this.icon = Icons.folder_outlined,
    required this.label,
    required this.labelStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brandPrimary500Alpha10,
      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.radiusMd),
            border: Border.all(color: ButtonColors.outlineBorder),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: ButtonColors.outlineText),
              const SizedBox(width: AppSpacing.spacingSm),
              Text(label, style: labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Square outline action (quiz / homework) in [ModuleSheet].
class ModuleOutlineTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  const ModuleOutlineTile({
    super.key,
    required this.icon,
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
          child: SizedBox(
            height: 84,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacingLg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: ButtonColors.outlineText),
                  const SizedBox(height: AppSpacing.spacingSm),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

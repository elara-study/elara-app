import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Primary full-width action (e.g. chat) in [ModuleSheet].
class ModulePrimaryTile extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  const ModulePrimaryTile({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    required this.labelStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        boxShadow: AppShadows.elevation(brightness),
      ),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.smart_toy_outlined, size: 20, color: foreground),
                const SizedBox(width: AppSpacing.spacingSm),
                Text(label, style: labelStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Horizontal divider with centred label text.
/// [label] defaults to `'OR LOGIN WITH'` — override for sign-up flows.
class AuthDivider extends StatelessWidget {
  final String label;

  const AuthDivider({super.key, this.label = 'OR LOGIN WITH'});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: cs.outlineVariant)),
        Flexible(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingSm,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: AppTypography.label2xs(color: cs.onSurfaceVariant),
              ),
            ),
          ),
        ),
        Expanded(child: Divider(color: cs.outlineVariant)),
      ],
    );
  }
}

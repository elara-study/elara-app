import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// "Already have an account? Sign in" / "Don't have an account? Sign up" footer
/// used at the bottom of every auth card.
class AuthCardFooter extends StatelessWidget {
  final String prompt;
  final String actionLabel;
  final VoidCallback onTap;

  const AuthCardFooter({
    super.key,
    required this.prompt,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.spacingXs,
      runSpacing: AppSpacing.spacingXs,
      children: [
        Text(
          prompt,
          textAlign: TextAlign.center,
          style: AppTypography.labelSmall(color: cs.onSurface),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(54, 24),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: AppTypography.labelSmall(color: ButtonColors.ghostText),
          ),
        ),
      ],
    );
  }
}

import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Standard two-line header used at the top of every auth card.
class AuthCardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompact;

  const AuthCardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.h3(color: cs.onSurface).copyWith(
            fontSize: isCompact ? 22 : null,
            fontWeight: AppTypography.black,
          ),
        ),
        SizedBox(
          height: isCompact ? AppSpacing.spacingXs : AppSpacing.spacingSm,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyLarge(
            color: cs.onSurfaceVariant,
          ).copyWith(fontSize: isCompact ? 14 : null),
        ),
      ],
    );
  }
}

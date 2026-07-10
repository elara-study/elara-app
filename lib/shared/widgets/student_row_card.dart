import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//   StudentRowCard

/// App-wide shared student row card.
/// Layout: [Avatar] [Name (expanded)] [trailing]

class StudentRowCard extends StatelessWidget {
  final String studentName;

  /// Widget shown on the trailing end of the row (score, XP badge, Switch…).
  final Widget trailing;

  /// Tap callback for the whole card. Pass `null` when the card itself

  final VoidCallback? onTap;

  /// Override the avatar widget. Defaults to a circular placeholder with
  /// [Icons.person_rounded].
  final Widget? avatarChild;

  /// Diameter of the circular avatar. Defaults to 36.
  final double avatarSize;

  /// Card background colour. Defaults to `cs.surface`.
  final Color? cardColor;

  /// Whether to paint the elevation shadow. Defaults to `true`.
  final bool showShadow;

  const StudentRowCard({
    super.key,
    required this.studentName,
    required this.trailing,
    this.onTap,
    this.avatarChild,
    this.avatarSize = 36,
    this.cardColor,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: cardColor ?? cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: showShadow ? AppShadows.elevation(theme.brightness) : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacingMd.w),
        child: Row(
          children: [
            //   Avatar
            _AvatarCircle(size: avatarSize, child: avatarChild),
            SizedBox(width: AppSpacing.spacingMd.w),
            //   Name
            Expanded(
              child: Text(
                studentName,
                style: AppTypography.bodyMedium(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            //   Trailing
            trailing,
          ],
        ),
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(onTap: onTap, child: card);
  }
}

//   _AvatarCircle

/// Circular avatar container. Renders [child] if provided, otherwise falls
/// back to the default [Icons.person_rounded] placeholder.
class _AvatarCircle extends StatelessWidget {
  final double size;
  final Widget? child;

  const _AvatarCircle({required this.size, this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Center(
        child:
            child ??
            Icon(
              Icons.person_rounded,
              size: (size * 0.55).sp,
              color: cs.onSurfaceVariant,
            ),
      ),
    );
  }
}

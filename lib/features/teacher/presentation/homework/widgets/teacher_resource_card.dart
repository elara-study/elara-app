import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:elara/shared/widgets/app_overflow_menu.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Teacher resource card for video, pdf, link, and document types.
///
/// Figma "Asset Card":
///   padding 16px, radius 24px, 80px height, surface bg + shadow.
///   48×48 icon container with 12px radius, 32×32 icon.
///   Title (labelRegular SemiBold 14px) + Meta (caption 10px Regular).
class TeacherResourceCard extends StatelessWidget {
  final TeacherResourceEntity resource;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const TeacherResourceCard({
    super.key,
    required this.resource,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final (icon, iconColor, containerBg) = _typeAssets(resource.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
            boxShadow: AppShadows.elevation(theme.brightness),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Icon container ────────────────────────────────────────
                // Figma: 48×48, border-radius 12px, type-specific bg
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: containerBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, size: 32.sp, color: iconColor),
                ),
                SizedBox(width: AppSpacing.spacingMd.w),

                // ── Info column ───────────────────────────────────────────
                // Figma: gap 4px between title and meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        resource.title,
                        // Figma: font/typo/label/regular = SemiBold 14px
                        style: AppTypography.labelRegular(color: cs.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.spacingXs.h),
                      Text(
                        _subtitle(resource),
                        // Figma: font/typo/caption = Regular 10px
                        style: TextStyle(
                          fontFamily: AppTypography.nunito,
                          fontSize: 10.sp,
                          fontWeight: AppTypography.regular,
                          color: cs.onSurfaceVariant,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Overflow menu ⋮ ───────────────────────────────────────
                if (showActions)
                  AppOverflowMenu(
                    iconSize: 16,
                    items: [
                      AppOverflowMenuItem(
                        label: context.l10n.commonEdit,
                        icon: Icons.mode_edit_outline_rounded,
                        backgroundColor: AppColors.brandPrimary500,
                        onTap: onEdit ?? () {},
                      ),
                      AppOverflowMenuItem(
                        label: context.l10n.commonDelete,
                        icon: Icons.delete_outline_rounded,
                        backgroundColor: AppColors.brandSecondary500,
                        onTap: onDelete ?? () {},
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns (icon, iconColor, containerBackground) for each resource type.
  ///
  /// Figma:
  ///   video  → brandPrimary500Alpha20 bg,  brandPrimary500 icon
  ///   pdf    → brandSecondary500Alpha20 bg, brandSecondary500 icon
  ///   link   → info50 bg,   info500 icon
  ///   image  → success50 bg, success500 icon
  ///   doc    → warning50 bg, warning500 icon
  static (IconData, Color, Color) _typeAssets(TeacherResourceType type) {
    return switch (type) {
      TeacherResourceType.video => (
        Icons.play_arrow_rounded,
        AppColors.brandPrimary500,
        AppColors.brandPrimary500Alpha20,
      ),
      TeacherResourceType.pdf => (
        Icons.picture_as_pdf_rounded,
        AppColors.brandSecondary500,
        AppColors.brandSecondary500Alpha20,
      ),
      TeacherResourceType.link => (
        Icons.link_rounded,
        AppColors.info500,
        AppColors.info50,
      ),
      TeacherResourceType.image => (
        Icons.image_outlined,
        AppColors.success500,
        AppColors.success50,
      ),
      TeacherResourceType.document => (
        Icons.description_outlined,
        AppColors.warning500,
        AppColors.warning50,
      ),
    };
  }

  /// Figma "Meta" field: duration for videos, fileSize for pdfs/images,
  /// falling back to addedAtLabel.
  static String _subtitle(TeacherResourceEntity r) =>
      r.duration ?? r.fileSize ?? r.addedAtLabel;
}

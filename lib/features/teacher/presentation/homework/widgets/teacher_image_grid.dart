import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Horizontally scrolling row of image asset cards.
///
/// Figma: flex-direction row, overflow-x scroll, gap 12px.
/// Each card: 128×96px, border-radius 16px.
class TeacherImageGrid extends StatelessWidget {
  final List<TeacherResourceEntity> resources;

  const TeacherImageGrid({super.key, required this.resources});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: resources.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSpacing.spacingMd.w),
        itemBuilder: (_, i) => TeacherImageCell(resource: resources[i]),
      ),
    );
  }
}

/// Single image asset card — 128×96, top placeholder + bottom title bar.
class TeacherImageCell extends StatelessWidget {
  final TeacherResourceEntity resource;

  const TeacherImageCell({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 128.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
        child: Column(
          children: [
            // ── Image placeholder (top ~64px) ─────────────────────────
            Expanded(
              child: Container(
                color: AppColors.brandPrimary500Alpha10,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 28.sp,
                    color: AppColors.brandPrimary500,
                  ),
                ),
              ),
            ),

            // ── Title bar (bottom 32px) ────────────────────────────────
            // Figma: background surface, padding 8px 12px
            Container(
              height: 32.h,
              color: cs.surface,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd.w,
                vertical: AppSpacing.spacingSm.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      resource.fileName ?? resource.title,
                      // Figma: font/typo/label/small = SemiBold 12px
                      style: AppTypography.labelSmall(color: cs.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.more_vert_rounded,
                    size: 16.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/reports/entities/parent_insight_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Teacher insight card — Figma Insight (1417:7620).
class ParentInsightCard extends StatelessWidget {
  const ParentInsightCard({super.key, required this.insight});

  final ParentInsightEntity insight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onSurface = cs.onSurface;
    final secondary = cs.onSurfaceVariant;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            offset: Offset(0, 4.h),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacingLg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    insight.childName,
                    style: AppTypography.h4(color: onSurface),
                  ),
                ),
                Text(
                  insight.dateLabel,
                  style: AppTypography.bodySmall(color: secondary),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingMd.h),
            Text(
              insight.reportParagraph1,
              style: AppTypography.bodyMedium(color: onSurface),
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Text(
              insight.reportParagraph2,
              style: AppTypography.bodyMedium(color: onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

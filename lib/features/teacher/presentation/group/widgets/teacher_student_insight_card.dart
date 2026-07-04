import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' hide TextDirection;

/// Draft insight card with Edit / Send actions (Figma Insight, 1417:7510).
class TeacherStudentInsightCard extends StatelessWidget {
  const TeacherStudentInsightCard({
    super.key,
    required this.insight,
    this.onEdit,
    this.onSend,
  });

  final TeacherStudentInsightEntity insight;
  final VoidCallback? onEdit;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
            Text(
              insight.updatedLabel,
              style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Text(
              insight.paragraph1,
              style: AppTypography.bodyMedium(color: cs.onSurface),
              textDirection: Bidi.detectRtlDirectionality(insight.paragraph1)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Text(
              insight.paragraph2,
              style: AppTypography.bodyMedium(color: cs.onSurface),
              textDirection: Bidi.detectRtlDirectionality(insight.paragraph2)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
            ),
            if (onEdit != null || onSend != null) ...[
              SizedBox(height: AppSpacing.spacingLg.h),
              Row(
                children: [
                  if (onEdit != null)
                    Expanded(
                      child: AppOutlineButton(
                        text: 'Edit',
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingLg.w,
                          vertical: AppSpacing.spacingMd.h,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusFull.r,
                        ),
                        leading: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: ButtonColors.outlineText,
                        ),
                        onPressed: onEdit,
                      ),
                    ),
                  if (onEdit != null && onSend != null)
                    SizedBox(width: AppSpacing.spacingMd.w),
                  if (onSend != null)
                    Expanded(
                      child: AppPrimaryButton(
                        text: 'Send Insight',
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingLg.w,
                          vertical: AppSpacing.spacingMd.h,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusFull.r,
                        ),
                        icon: Icons.send_rounded,
                        onPressed: onSend,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

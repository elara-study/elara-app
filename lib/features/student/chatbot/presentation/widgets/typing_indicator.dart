import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: cs.primary,
            child: Icon(
              Icons.smart_toy_rounded,
              size: 20.sp,
              color: cs.onPrimary,
            ),
          ),
          SizedBox(width: AppSpacing.spacingSm.w),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd.w,
                vertical: AppSpacing.spacingSm.h,
              ),
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      final v = (_c.value * 3 - i).clamp(0.0, 1.0);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Opacity(
                          opacity: 0.35 + 0.65 * v,
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:elara/core/localization/locale_constants.dart';
import 'package:elara/core/localization/locale_cubit.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LanguagePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.radiusLg.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.spacingLg.w,
        right: AppSpacing.spacingLg.w,
        top: AppSpacing.spacingLg.h,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.spacingLg.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.spacingLg.h),
          Text(
            context.l10n.languagePickerTitle,
            style: AppTypography.h6(color: cs.onSurface),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.spacing2xs.h),
          Text(
            context.l10n.languagePickerSubtitle,
            style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.spacingLg.h),
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, currentLocale) {
              return Column(
                children: AppLocaleConstants.supportedLanguages.map((language) {
                  final isSelected = currentLocale.languageCode == language.locale.languageCode;
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.spacingSm.h),
                    key: ValueKey(language.locale.languageCode),
                    child: InkWell(
                      onTap: () {
                        context.read<LocaleCubit>().changeLocale(language.locale);
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingLg.w,
                          vertical: AppSpacing.spacingMd.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primaryContainer.withValues(alpha: 0.4)
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
                          border: Border.all(
                            color: isSelected ? cs.primary : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                language.nativeName,
                                style: AppTypography.labelLarge(
                                  color: isSelected ? cs.primary : cs.onSurface,
                                ).copyWith(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: cs.primary,
                                size: 20.sp,
                              )
                            else
                              Icon(
                                Icons.circle_outlined,
                                color: cs.outline,
                                size: 20.sp,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

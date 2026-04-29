import 'dart:ui';

import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Drawer header: title, close, frosted search field.
class HistoryPanelHeader extends StatelessWidget {
  const HistoryPanelHeader({
    super.key,
    required this.searchController,
    required this.onClose,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final VoidCallback onClose;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.94),
            border: Border(bottom: BorderSide(color: cs.outlineVariant)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.spacingLg.w,
              AppSpacing.spacingMd.h,
              AppSpacing.spacingLg.w,
              AppSpacing.spacingLg.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'History',
                        style:
                            AppTypography.h5(
                              font: 'Comfortaa',
                              color: cs.onSurface,
                            ).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              height: 28 / 20,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: cs.onSurface),
                      onPressed: onClose,
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonLabel,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingSm.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
                  clipBehavior: Clip.antiAlias,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius:
                          BorderRadius.circular(AppRadius.radiusFull.r),
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withValues(alpha: 0.08),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface,
                      ),
                      cursorColor: cs.primary,
                      decoration: InputDecoration(
                        hintText: 'Search chats...',
                        hintStyle: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 18 / 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: cs.onSurfaceVariant,
                          size: 20.sp,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingMd.w,
                          vertical: AppSpacing.spacingMd.h,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

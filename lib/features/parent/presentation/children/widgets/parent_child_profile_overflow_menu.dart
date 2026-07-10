import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App bar overflow (⋮) for Parent: “Remove Child”, then confirmation dialog.
class ParentChildProfileOverflowMenu extends StatefulWidget {
  const ParentChildProfileOverflowMenu({
    super.key,
    required this.childName,
    required this.childId,
  });

  final String childName;
  final String childId;

  @override
  State<ParentChildProfileOverflowMenu> createState() =>
      _ParentChildProfileOverflowMenuState();
}

class _ParentChildProfileOverflowMenuState
    extends State<ParentChildProfileOverflowMenu> {
  final _portal = OverlayPortalController();
  final _link = LayerLink();

  void _openConfirmation() {
    _portal.hide();
    final profileCubit = context.read<ParentChildProfileCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => _RemoveChildConfirmationDialog(
          childName: widget.childName,
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirmRemove: () async {
            final navigator = Navigator.of(context);
            Navigator.of(dialogContext).pop();
            final success = await profileCubit.unlinkChild(widget.childId);
            if (success && navigator.mounted) {
              navigator.pop(true);
            }
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: (overlayContext) {
          final overlayCs = Theme.of(overlayContext).colorScheme;
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _portal.hide,
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.32),
                  ),
                ),
              ),
              CompositedTransformFollower(
                link: _link,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: Offset(0, AppSpacing.spacingSm.h),
                child: Material(
                  color: overlayCs.surface,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
                  child: InkWell(
                    onTap: _openConfirmation,
                    borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusLg.r,
                        ),
                        boxShadow: AppShadows.elevation(overlayCs.brightness),
                        color: overlayCs.surface,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.spacingSm.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.brandSecondary500Alpha20,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(AppSpacing.spacingSm),
                                child: Icon(
                                  Icons.person_remove_rounded,
                                  size: 20,
                                  color: AppColors.brandSecondary500,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.spacingSm.w),
                            Text(
                              'Remove Child',
                              style: AppTypography.labelRegular(
                                color: overlayCs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          tooltip: 'More options',
          onPressed: _portal.toggle,
        ),
      ),
    );
  }
}

class _RemoveChildConfirmationDialog extends StatelessWidget {
  const _RemoveChildConfirmationDialog({
    required this.childName,
    required this.onCancel,
    required this.onConfirmRemove,
  });

  final String childName;
  final VoidCallback onCancel;
  final VoidCallback onConfirmRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onVar = cs.onSurfaceVariant;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.spacingLg.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.brandSecondary500Alpha20,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.spacingLg),
                  child: Icon(
                    Icons.person_remove_rounded,
                    size: 20,
                    color: AppColors.brandSecondary500,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spacingLg.h),
              Text(
                'Remove $childName?',
                textAlign: TextAlign.center,
                style: AppTypography.h5(
                  color: cs.onSurface,
                ).copyWith(fontWeight: FontWeight.w800, height: 24 / 18),
              ),
              SizedBox(height: AppSpacing.spacingXs.h),
              Text.rich(
                TextSpan(
                  style: AppTypography.bodySmall(
                    color: onVar,
                  ).copyWith(height: 18 / 12),
                  children: [
                    const TextSpan(text: 'Are you sure you want to remove '),
                    TextSpan(
                      text: childName,
                      style: AppTypography.bodySmall(
                        color: cs.onSurface,
                      ).copyWith(fontWeight: FontWeight.w600, height: 16 / 12),
                    ),
                    const TextSpan(
                      text:
                          '? This action cannot be undone. They will be removed from your list.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.spacingLg.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onConfirmRemove,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error500,
                    foregroundColor: AppColors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.spacingSm.h,
                      horizontal: AppSpacing.spacingLg.w,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Remove',
                    style: AppTypography.labelLarge(color: AppColors.white),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spacingSm.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ButtonColors.outlineText,
                    side: const BorderSide(color: ButtonColors.outlineBorder),
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.spacingSm.h,
                      horizontal: AppSpacing.spacingLg.w,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTypography.labelLarge(
                      color: ButtonColors.outlineText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

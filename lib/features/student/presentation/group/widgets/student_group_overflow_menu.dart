import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';

/// App bar overflow (⋮): “Leave Group” row, then confirmation dialog.
class StudentGroupOverflowMenu extends StatefulWidget {
  final String courseTitle;

  const StudentGroupOverflowMenu({super.key, required this.courseTitle});

  @override
  State<StudentGroupOverflowMenu> createState() =>
      _StudentGroupOverflowMenuState();
}

class _StudentGroupOverflowMenuState extends State<StudentGroupOverflowMenu> {
  final _portal = OverlayPortalController();
  final _link = LayerLink();

  void _openConfirmation() {
    _portal.hide();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => _LeaveGroupConfirmationDialog(
          courseTitle: widget.courseTitle,
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirmLeave: () {
            Navigator.of(dialogContext).pop();
            if (!context.mounted) return;
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
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
                offset: const Offset(0, AppSpacing.spacingSm),
                child: Material(
                  color: overlayCs.surface,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                  child: InkWell(
                    onTap: _openConfirmation,
                    borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                        boxShadow: AppShadows.elevation(overlayCs.brightness),
                        color: overlayCs.surface,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.spacingSm),
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
                                  Icons.logout_rounded,
                                  size: 20,
                                  color: AppColors.brandSecondary500,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.spacingSm),
                            Text(
                              overlayContext.l10n.groupLeaveGroup,
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
          tooltip: context.l10n.commonMoreOptions,
          onPressed: _portal.toggle,
        ),
      ),
    );
  }
}

class _LeaveGroupConfirmationDialog extends StatelessWidget {
  final String courseTitle;
  final VoidCallback onCancel;
  final VoidCallback onConfirmLeave;

  const _LeaveGroupConfirmationDialog({
    required this.courseTitle,
    required this.onCancel,
    required this.onConfirmLeave,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onVar = cs.onSurfaceVariant;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
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
                    Icons.logout_rounded,
                    size: 20,
                    color: AppColors.brandSecondary500,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                context.l10n.groupLeaveGroupTitle,
                textAlign: TextAlign.center,
                style: AppTypography.h5(
                  color: cs.onSurface,
                ).copyWith(fontWeight: FontWeight.w800, height: 24 / 18),
              ),
              const SizedBox(height: AppSpacing.spacingXs),
              Text(
                context.l10n.groupLeaveGroupConfirm(courseTitle),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall(
                  color: onVar,
                ).copyWith(height: 18 / 12),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onConfirmLeave,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error500,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.spacingSm,
                      horizontal: AppSpacing.spacingLg,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    context.l10n.groupLeaveGroup,
                    style: AppTypography.labelLarge(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingSm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ButtonColors.outlineText,
                    side: const BorderSide(color: ButtonColors.outlineBorder),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.spacingSm,
                      horizontal: AppSpacing.spacingLg,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    context.l10n.commonCancel,
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

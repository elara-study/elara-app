import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// App bar overflow (⋮): “Remove from Group”, then confirmation dialog.
class TeacherStudentProfileOverflowMenu extends StatefulWidget {
  const TeacherStudentProfileOverflowMenu({
    super.key,
    required this.studentName,
    required this.groupTitle,
  });

  final String studentName;
  final String groupTitle;

  @override
  State<TeacherStudentProfileOverflowMenu> createState() =>
      _TeacherStudentProfileOverflowMenuState();
}

class _TeacherStudentProfileOverflowMenuState
    extends State<TeacherStudentProfileOverflowMenu> {
  final _portal = OverlayPortalController();
  final _link = LayerLink();

  void _openConfirmation() {
    _portal.hide();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => _RemoveFromGroupConfirmationDialog(
          studentName: widget.studentName,
          groupTitle: widget.groupTitle,
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirmRemove: () {
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
                                  Icons.login_outlined,
                                  size: 20,
                                  color: AppColors.brandSecondary500,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.spacingSm),
                            Text(
                              'Remove from Group',
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

class _RemoveFromGroupConfirmationDialog extends StatelessWidget {
  const _RemoveFromGroupConfirmationDialog({
    required this.studentName,
    required this.groupTitle,
    required this.onCancel,
    required this.onConfirmRemove,
  });

  final String studentName;
  final String groupTitle;
  final VoidCallback onCancel;
  final VoidCallback onConfirmRemove;

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
                    Icons.login_outlined,
                    size: 20,
                    color: AppColors.brandSecondary500,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                'Remove $studentName?',
                textAlign: TextAlign.center,
                style: AppTypography.h5(
                  color: cs.onSurface,
                ).copyWith(fontWeight: FontWeight.w800, height: 24 / 18),
              ),
              const SizedBox(height: AppSpacing.spacingXs),
              Text.rich(
                TextSpan(
                  style: AppTypography.bodySmall(
                    color: onVar,
                  ).copyWith(height: 18 / 12),
                  children: [
                    const TextSpan(text: 'Are you sure you want to remove '),
                    TextSpan(
                      text: studentName,
                      style: AppTypography.bodySmall(
                        color: cs.onSurface,
                      ).copyWith(fontWeight: FontWeight.w600, height: 16 / 12),
                    ),
                    const TextSpan(text: ' from '),
                    TextSpan(
                      text: groupTitle,
                      style: AppTypography.bodySmall(
                        color: cs.onSurface,
                      ).copyWith(fontWeight: FontWeight.w600, height: 16 / 12),
                    ),
                    const TextSpan(
                      text:
                          '? They will lose access to all shared materials and '
                          'progress.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onConfirmRemove,
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
                    'Remove',
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

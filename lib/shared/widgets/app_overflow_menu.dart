import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// A single action inside [AppOverflowMenu].
class AppOverflowMenuItem {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const AppOverflowMenuItem({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });
}

/// A custom floating overflow menu triggered by a ⋮ icon.
///
/// Renders each [item] as a full-width colored row stacked vertically.
/// The first item gets rounded top corners and the last gets rounded bottom
/// corners (matching the Figma "Announcement Menu Overlay" spec).
///
/// Usage:
/// ```dart
/// AppOverflowMenu(
///   items: [
///     AppOverflowMenuItem(
///       label: 'Edit',
///       icon: Icons.mode,
///       backgroundColor: AppColors.brandPrimary500,
///       onTap: onEdit,
///     ),
///     AppOverflowMenuItem(
///       label: 'Delete',
///       icon: Icons.delete,
///       backgroundColor: AppColors.brandSecondary500,
///       onTap: onDelete,
///     ),
///   ],
/// )
/// ```
class AppOverflowMenu extends StatefulWidget {
  final List<AppOverflowMenuItem> items;

  /// Size of the ⋮ trigger icon.
  final double iconSize;

  const AppOverflowMenu({super.key, required this.items, this.iconSize = 18});

  @override
  State<AppOverflowMenu> createState() => _AppOverflowMenuState();
}

class _AppOverflowMenuState extends State<AppOverflowMenu> {
  final _key = GlobalKey();
  OverlayEntry? _entry;

  @override
  void dispose() {
    _hideMenu();
    super.dispose();
  }

  void _showMenu() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    final screenWidth = MediaQuery.of(context).size.width;

    // Right-align the panel to the ⋮ button's right edge.
    final right = screenWidth - pos.dx - size.width;
    final top = pos.dy + size.height + 4;

    _entry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // Full-screen dismiss layer
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hideMenu,
            ),
          ),

          // Floating menu panel
          Positioned(
            top: top,
            right: right,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.radiusSm),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radiusSm),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(widget.items.length, (i) {
                        final item = widget.items[i];
                        return GestureDetector(
                          onTap: () {
                            _hideMenu();
                            item.onTap();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.spacingSm, // 8px
                              vertical: AppSpacing.spacingXs, // 4px
                            ),
                            color: item.backgroundColor,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  item.icon,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                                const SizedBox(width: AppSpacing.spacingXs),
                                Text(
                                  item.label,
                                  style: AppTypography.labelSmall(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  void _hideMenu() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      key: _key,
      onTap: _entry == null ? _showMenu : _hideMenu,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingXs),
        child: Icon(
          Icons.more_vert_rounded,
          size: widget.iconSize,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

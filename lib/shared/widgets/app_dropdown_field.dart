import 'dart:math' as math;

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownField extends StatefulWidget {
  final String label;
  final String hint;
  final Widget prefixIcon;

  /// Non-null → opens an animated overlay pinned below the field.
  /// Null     → shows a "Coming soon" snackbar.
  final List<String>? options;

  /// Called whenever the user picks a new value.
  final ValueChanged<String>? onChanged;

  /// Pre-selected value (useful for edit flows).
  final String? initialValue;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.options,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<AppDropdownField> createState() => _AppDropdownFieldState();
}

class _AppDropdownFieldState extends State<AppDropdownField>
    with SingleTickerProviderStateMixin {
  late String? _selected = widget.initialValue;
  bool _isOpen = false;

  /// Measures the field's screen position for overlay placement.
  final _fieldKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // ── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _closeOverlay(animate: false);
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Open ────────────────────────────────────────────────────────────────────

  void _openOverlay() {
    // Always dismiss the keyboard first, regardless of what happens next.
    FocusScope.of(context).unfocus();

    if (widget.options == null) {
      _showComingSoon();
      return;
    }
    if (_isOpen) {
      _closeOverlay();
      return;
    }

    final box = _fieldKey.currentContext!.findRenderObject()! as RenderBox;
    final fieldTopLeft = box.localToGlobal(Offset.zero);
    final fieldW = box.size.width;
    final fieldH = box.size.height;

    // Show at most 4.5 rows so overflow makes the list obviously scrollable.
    const itemH = 44.0;
    const maxVisible = 4.5;
    final listH =
        math.min(widget.options!.length.toDouble(), maxVisible) * itemH;

    // Screen metrics needed to clamp the overlay inside the safe area.
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final bottomPadding = mq.padding.bottom; // system nav bar height

    setState(() => _isOpen = true);

    _overlayEntry = OverlayEntry(
      builder: (_) => _DropdownOverlay(
        anchorTopLeft: fieldTopLeft,
        anchorWidth: fieldW,
        anchorHeight: fieldH,
        listHeight: listH,
        screenHeight: screenH,
        bottomPadding: bottomPadding,
        options: widget.options!,
        selected: _selected,
        fadeAnim: _fadeAnim,
        slideAnim: _slideAnim,
        onSelect: _onSelect,
        onDismiss: _closeOverlay,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animCtrl.forward(from: 0);
  }

  // ── Close ───────────────────────────────────────────────────────────────────

  void _closeOverlay({bool animate = true}) {
    if (_overlayEntry == null) return;
    if (animate) {
      _animCtrl.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) setState(() => _isOpen = false);
      });
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpen = false;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _onSelect(String value) {
    setState(() => _selected = value);
    widget.onChanged?.call(value);
    _closeOverlay();
  }

  void _showComingSoon() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🚀 Coming soon!',
          style: AppTypography.labelSmall(color: AppColors.white),
        ),
        backgroundColor: AppColors.brandPrimary600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = _selected != null;
    final fillColor = isDark
        ? DarkModeColors.surfaceSecondary
        : LightModeColors.surfaceApp;
    final labelColor = isDark
        ? DarkModeColors.textPrimary
        : LightModeColors.textPrimary;
    final valueColor = isDark
        ? DarkModeColors.textPrimary
        : LightModeColors.textPrimary;
    final hintColor = isDark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.labelRegular(color: labelColor),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          key: _fieldKey,
          onTap: _openOverlay,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              border: Border.all(
                color: _isOpen
                    ? AppColors.brandPrimary400
                    : (isDark
                          ? DarkModeColors.borderDefault
                          : Colors.transparent),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                widget.prefixIcon,

                const SizedBox(width: AppSpacing.spacingSm),
                Expanded(
                  child: Text(
                    hasValue ? _selected! : widget.hint,
                    style: AppTypography.bodySmall(
                      color: hasValue ? valueColor : hintColor,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    hasValue
                        ? Icons.check_circle_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 16.w,
                    color: hasValue ? AppColors.brandPrimary400 : hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// _DropdownOverlay — inserted into the Overlay stack, anchored to the field.
// Private: only used by AppDropdownField.
// -----------------------------------------------------------------------------

class _DropdownOverlay extends StatelessWidget {
  final Offset anchorTopLeft;
  final double anchorWidth;
  final double anchorHeight;
  final double listHeight;
  final double screenHeight;
  final double bottomPadding;
  final List<String> options;
  final String? selected;
  final Animation<double> fadeAnim;
  final Animation<Offset> slideAnim;
  final ValueChanged<String> onSelect;
  final VoidCallback onDismiss;

  const _DropdownOverlay({
    required this.anchorTopLeft,
    required this.anchorWidth,
    required this.anchorHeight,
    required this.listHeight,
    required this.screenHeight,
    required this.bottomPadding,
    required this.options,
    required this.selected,
    required this.fadeAnim,
    required this.slideAnim,
    required this.onSelect,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    const gap = 6.0;
    final belowTop = anchorTopLeft.dy + anchorHeight + gap;
    final safeBottom = screenHeight - bottomPadding - 8; // 8 px breathing room

    // Flip the dropdown above the field if it would overflow the safe area.
    final fitsBelow = belowTop + listHeight <= safeBottom;
    final panelTop = fitsBelow
        ? belowTop
        : math.max(0.0, anchorTopLeft.dy - gap - listHeight);

    return Stack(
      children: [
        // Barrier: dismiss on tap outside.
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),

        // Dropdown panel — clamped inside the safe area.
        Positioned(
          left: anchorTopLeft.dx,
          top: panelTop,
          width: anchorWidth,
          child: FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: Material(
                color: Colors.transparent,
                child: _DropdownPanel(
                  listHeight: listHeight,
                  options: options,
                  selected: selected,
                  onSelect: onSelect,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// _DropdownPanel — the visible card with the scrollable list of options.
// -----------------------------------------------------------------------------

class _DropdownPanel extends StatelessWidget {
  final double listHeight;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _DropdownPanel({
    required this.listHeight,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = isDark
        ? DarkModeColors.surfaceSecondary
        : LightModeColors.surfacePrimary;
    final borderColor = isDark
        ? DarkModeColors.borderDefault
        : AppColors.brandPrimary100;

    return Container(
      height: listHeight,
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.30 : 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: options.length,
          itemExtent: 44,
          itemBuilder: (_, i) => _DropdownItem(
            label: options[i],
            isSelected: options[i] == selected,
            onTap: () => onSelect(options[i]),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// _DropdownItem — a single row inside the dropdown panel.
// -----------------------------------------------------------------------------

class _DropdownItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DropdownItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? DarkModeColors.textPrimary
        : LightModeColors.textPrimary;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.brandPrimary100.withValues(alpha: 0.4),
      highlightColor: AppColors.brandPrimary50.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style:
                    AppTypography.bodySmall(
                      color: isSelected ? AppColors.brandPrimary600 : textColor,
                    ).copyWith(
                      fontWeight: isSelected
                          ? AppTypography.semiBold
                          : AppTypography.regular,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_rounded,
                size: 14.w,
                color: AppColors.brandPrimary600,
              ),
          ],
        ),
      ),
    );
  }
}

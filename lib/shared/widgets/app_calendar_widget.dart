import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Public API ───────────────────────────────────────────────────────────────

/// Custom animated calendar widget, Elara design system.
///
/// - Tap **◀ ▶** to navigate months with a slide animation.
/// - Tap the **"Mon YYYY"** title to open a year-grid picker — no more
///   navigating month-by-month to reach a distant year.
/// - Use [showAppCalendarDialog] to present it as a styled dialog.
class AppCalendarWidget extends StatefulWidget {
  const AppCalendarWidget({
    super.key,
    this.initialDate,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  });

  final DateTime? initialDate;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  State<AppCalendarWidget> createState() => _AppCalendarWidgetState();
}

/// Shows an [AppCalendarWidget] inside a themed dialog.
///
/// Returns the selected [DateTime], or `null` if dismissed.
Future<DateTime?> showAppCalendarDialog({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? selectedDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final now = DateTime.now();
  return showDialog<DateTime>(
    context: context,
    barrierColor: AppColors.neutral900.withValues(alpha: 0.6),
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: AppCalendarWidget(
        initialDate: initialDate ?? now,
        selectedDate: selectedDate,
        firstDate: firstDate ?? DateTime(1940),
        lastDate: lastDate ?? DateTime(now.year + 10),
        onDateSelected: (date) => Navigator.of(ctx).pop(date),
      ),
    ),
  );
}

// ─── Widget state ─────────────────────────────────────────────────────────────

enum _CalendarView { month, year }

class _AppCalendarWidgetState extends State<AppCalendarWidget>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  late DateTime _visibleMonth;
  DateTime? _selectedDate;
  _CalendarView _view = _CalendarView.month;

  // ── Month slide animation ──────────────────────────────────────────────────
  late final AnimationController _slideCtrl;
  late Animation<Offset> _slideIn;
  late Animation<Offset> _slideOut;
  late Animation<double> _fadeIn;
  late Animation<double> _fadeOut;
  List<_DayCell>? _previousCells; // snapshot being animated away

  static const _slideDuration = Duration(milliseconds: 320);

  // ─── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final base = widget.initialDate ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
    _selectedDate = widget.selectedDate;

    _slideCtrl = AnimationController(vsync: this, duration: _slideDuration);
    _applySlideAnimations(forward: true);
    _slideCtrl.value = 1.0; // settled
  }

  @override
  void didUpdateWidget(AppCalendarWidget old) {
    super.didUpdateWidget(old);
    if (widget.selectedDate != old.selectedDate) {
      setState(() => _selectedDate = widget.selectedDate);
    }
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  // ─── Animations ─────────────────────────────────────────────────────────────

  void _applySlideAnimations({required bool forward}) {
    final beginOffset = Offset(forward ? 1.0 : -1.0, 0);
    final endOffset = Offset(forward ? -1.0 : 1.0, 0);
    final curve = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeInOutCubic);
    final halfIn = CurvedAnimation(
      parent: _slideCtrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );
    final halfOut = CurvedAnimation(
      parent: _slideCtrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _slideIn = Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(curve);
    _slideOut = Tween<Offset>(begin: Offset.zero, end: endOffset).animate(curve);
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(halfIn);
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(halfOut);
  }

  Future<void> _navigateMonth(bool forward) async {
    if (_slideCtrl.isAnimating) return;
    final snapshot = _buildCells(_visibleMonth);
    setState(() {
      _previousCells = snapshot;
      _applySlideAnimations(forward: forward);
      _visibleMonth = DateTime(
        _visibleMonth.year,
        _visibleMonth.month + (forward ? 1 : -1),
      );
    });
    _slideCtrl.value = 0.0;
    await _slideCtrl.forward();
    if (mounted) setState(() => _previousCells = null);
  }

  // ─── Year picker ────────────────────────────────────────────────────────────

  void _onYearSelected(int year) {
    setState(() {
      _visibleMonth = DateTime(year, _visibleMonth.month);
      _view = _CalendarView.month;
    });
  }

  void _toggleView() {
    setState(() {
      _view = _view == _CalendarView.month
          ? _CalendarView.year
          : _CalendarView.month;
    });
  }

  // ─── Grid helpers ───────────────────────────────────────────────────────────

  List<_DayCell> _buildCells(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final leadingBlanks = firstDay.weekday - 1; // Mon=0 … Sun=6
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final prevMonthDays = DateTime(month.year, month.month, 0).day;

    final cells = <_DayCell>[];

    for (var i = leadingBlanks - 1; i >= 0; i--) {
      final d = prevMonthDays - i;
      cells.add(_DayCell(d, DateTime(month.year, month.month - 1, d), false));
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(_DayCell(d, DateTime(month.year, month.month, d), true));
    }
    final total = cells.length <= 35 ? 35 : 42;
    var trailing = 1;
    while (cells.length < total) {
      cells.add(_DayCell(trailing, DateTime(month.year, month.month + 1, trailing), false));
      trailing++;
    }
    return cells;
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF151B26) : LightModeColors.surfacePrimary;
    final borderColor = isDark ? const Color(0xFF232D3F) : LightModeColors.borderDefault;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.radiusXl),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: isDark ? 0.55 : 0.10),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radiusXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AccentBar(),
            _Header(
              month: _visibleMonth,
              isDark: isDark,
              isYearView: _view == _CalendarView.year,
              onPrev: _view == _CalendarView.month ? () => _navigateMonth(false) : null,
              onNext: _view == _CalendarView.month ? () => _navigateMonth(true) : null,
              onTitleTap: _toggleView,
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeInOutCubic,
              crossFadeState: _view == _CalendarView.year
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _MonthViewBody(
                slideCtrl: _slideCtrl,
                slideIn: _slideIn,
                slideOut: _slideOut,
                fadeIn: _fadeIn,
                fadeOut: _fadeOut,
                currentCells: _buildCells(_visibleMonth),
                previousCells: _previousCells,
                visibleMonth: _visibleMonth,
                selectedDate: _selectedDate,
                isDark: isDark,
                onSelect: (date) {
                  setState(() => _selectedDate = date);
                  widget.onDateSelected?.call(date);
                },
              ),
              secondChild: _YearPickerBody(
                currentYear: _visibleMonth.year,
                firstYear: (widget.firstDate ?? DateTime(1940)).year,
                lastYear: (widget.lastDate ?? DateTime(DateTime.now().year + 10)).year,
                isDark: isDark,
                onYearSelected: _onYearSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── _AccentBar ───────────────────────────────────────────────────────────────

class _AccentBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandPrimary400, AppColors.brandPrimary600],
        ),
      ),
    );
  }
}

// ─── _Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.month,
    required this.isDark,
    required this.isYearView,
    required this.onTitleTap,
    this.onPrev,
    this.onNext,
  });

  final DateTime month;
  final bool isDark;
  final bool isYearView;
  final VoidCallback onTitleTap;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final navBg = isDark
        ? const Color(0xFF1E293B)
        : AppColors.brandPrimary500.withValues(alpha: 0.08);
    final navIcon = isDark ? DarkModeColors.textSecondary : AppColors.brandPrimary500;
    final titleColor = isDark ? DarkModeColors.textPrimary : LightModeColors.textPrimary;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg.w,
        vertical: AppSpacing.spacingLg.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavBtn(
            icon: Icons.chevron_left_rounded,
            bg: navBg,
            iconColor: onPrev != null ? navIcon : navIcon.withValues(alpha: 0.3),
            onTap: onPrev ?? () {},
          ),
          // Tappable title — switches to year picker
          GestureDetector(
            onTap: onTitleTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_monthNames[month.month - 1]} ${month.year}',
                  style: AppTypography.h5(color: titleColor),
                ),
                SizedBox(width: 4.w),
                AnimatedRotation(
                  turns: isYearView ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOutCubic,
                  child: Icon(
                    Icons.expand_more_rounded,
                    size: 18.r,
                    color: AppColors.brandPrimary500,
                  ),
                ),
              ],
            ),
          ),
          _NavBtn(
            icon: Icons.chevron_right_rounded,
            bg: navBg,
            iconColor: onNext != null ? navIcon : navIcon.withValues(alpha: 0.3),
            onTap: onNext ?? () {},
          ),
        ],
      ),
    );
  }
}

// ─── _NavBtn ──────────────────────────────────────────────────────────────────

class _NavBtn extends StatefulWidget {
  const _NavBtn({
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color bg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  State<_NavBtn> createState() => _NavBtnState();
}

class _NavBtnState extends State<_NavBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
    reverseDuration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.85)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(color: widget.bg, shape: BoxShape.circle),
          child: Icon(widget.icon, color: widget.iconColor, size: 20.r),
        ),
      ),
    );
  }
}

// ─── _MonthViewBody ───────────────────────────────────────────────────────────

class _MonthViewBody extends StatelessWidget {
  const _MonthViewBody({
    required this.slideCtrl,
    required this.slideIn,
    required this.slideOut,
    required this.fadeIn,
    required this.fadeOut,
    required this.currentCells,
    required this.previousCells,
    required this.visibleMonth,
    required this.selectedDate,
    required this.isDark,
    required this.onSelect,
  });

  final AnimationController slideCtrl;
  final Animation<Offset> slideIn;
  final Animation<Offset> slideOut;
  final Animation<double> fadeIn;
  final Animation<double> fadeOut;
  final List<_DayCell> currentCells;
  final List<_DayCell>? previousCells;
  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final bool isDark;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final weekdayColor = isDark ? DarkModeColors.textSecondary : LightModeColors.textSecondary;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg.w, 0,
        AppSpacing.spacingLg.w, AppSpacing.spacingXl.h,
      ),
      child: Column(
        children: [
          // Weekday labels
          _WeekdayRow(color: weekdayColor),
          SizedBox(height: AppSpacing.spacingSm.h),
          // Animated grid
          AnimatedBuilder(
            animation: slideCtrl,
            builder: (_, __) {
              if (previousCells == null || slideCtrl.value >= 1.0) {
                return _DayGrid(
                  cells: currentCells,
                  visibleMonth: visibleMonth,
                  selectedDate: selectedDate,
                  isDark: isDark,
                  onSelect: onSelect,
                );
              }
              return Stack(
                children: [
                  FadeTransition(
                    opacity: fadeOut,
                    child: SlideTransition(
                      position: slideOut,
                      child: _DayGrid(
                        cells: previousCells!,
                        visibleMonth: DateTime(visibleMonth.year, visibleMonth.month - 1),
                        selectedDate: selectedDate,
                        isDark: isDark,
                        onSelect: onSelect,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: fadeIn,
                    child: SlideTransition(
                      position: slideIn,
                      child: _DayGrid(
                        cells: currentCells,
                        visibleMonth: visibleMonth,
                        selectedDate: selectedDate,
                        isDark: isDark,
                        onSelect: onSelect,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── _WeekdayRow ──────────────────────────────────────────────────────────────

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.color});
  final Color color;
  static const _labels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels
          .map((l) => Expanded(
                child: Center(
                  child: Text(l, style: AppTypography.overline(color: color)),
                ),
              ))
          .toList(),
    );
  }
}

// ─── _DayGrid ─────────────────────────────────────────────────────────────────

class _DayGrid extends StatelessWidget {
  const _DayGrid({
    required this.cells,
    required this.visibleMonth,
    required this.selectedDate,
    required this.isDark,
    required this.onSelect,
  });

  final List<_DayCell> cells;
  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final bool isDark;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final rowCount = cells.length ~/ 7;
    return Column(
      children: List.generate(rowCount, (row) {
        return Padding(
          padding: row < rowCount - 1
              ? EdgeInsets.only(bottom: AppSpacing.spacingXs.h)
              : EdgeInsets.zero,
          child: Row(
            children: List.generate(7, (col) {
              return Expanded(
                child: _DayCell2(
                  cell: cells[row * 7 + col],
                  selectedDate: selectedDate,
                  isDark: isDark,
                  onSelect: onSelect,
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

// ─── _DayCell2 (interactive day tile) ────────────────────────────────────────

class _DayCell2 extends StatefulWidget {
  const _DayCell2({
    required this.cell,
    required this.selectedDate,
    required this.isDark,
    required this.onSelect,
  });

  final _DayCell cell;
  final DateTime? selectedDate;
  final bool isDark;
  final ValueChanged<DateTime> onSelect;

  @override
  State<_DayCell2> createState() => _DayCell2State();
}

class _DayCell2State extends State<_DayCell2> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 80),
    reverseDuration: const Duration(milliseconds: 160),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.78)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday = _sameDay(widget.cell.date, today);
    final isSelected = widget.selectedDate != null &&
        _sameDay(widget.cell.date, widget.selectedDate!);

    Color bg = Colors.transparent;
    Border? border;
    Color textColor;

    if (isSelected) {
      bg = AppColors.brandPrimary500;
      textColor = AppColors.white;
    } else if (isToday) {
      border = Border.all(color: AppColors.brandPrimary400, width: 1.5);
      textColor = AppColors.brandPrimary400;
    } else if (!widget.cell.isCurrentMonth) {
      textColor = (widget.isDark ? DarkModeColors.textSecondary : LightModeColors.textSecondary)
          .withValues(alpha: 0.35);
    } else {
      textColor = widget.isDark ? DarkModeColors.textPrimary : LightModeColors.textPrimary;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onSelect(widget.cell.date); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Padding(
          padding: EdgeInsets.all(2.r),
          child: AspectRatio(
            aspectRatio: 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: border,
              ),
              child: Center(
                child: Text(
                  '${widget.cell.day}',
                  style: (isSelected || isToday)
                      ? AppTypography.labelRegular(color: textColor)
                      : AppTypography.bodyMedium(color: textColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── _YearPickerBody ──────────────────────────────────────────────────────────

class _YearPickerBody extends StatelessWidget {
  const _YearPickerBody({
    required this.currentYear,
    required this.firstYear,
    required this.lastYear,
    required this.isDark,
    required this.onYearSelected,
  });

  final int currentYear;
  final int firstYear;
  final int lastYear;
  final bool isDark;
  final ValueChanged<int> onYearSelected;

  @override
  Widget build(BuildContext context) {
    final years = List.generate(lastYear - firstYear + 1, (i) => firstYear + i);
    final initialIndex = years.indexOf(currentYear).clamp(0, years.length - 1);
    final controller = ScrollController(
      initialScrollOffset: (initialIndex ~/ 3) * 52.0,
    );

    return SizedBox(
      height: 220.h,
      child: GridView.builder(
        controller: controller,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingLg.w,
          vertical: AppSpacing.spacingSm.h,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 44,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemCount: years.length,
        itemBuilder: (_, i) {
          final year = years[i];
          final isSelected = year == currentYear;
          return _YearTile(
            year: year,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () => onYearSelected(year),
          );
        },
      ),
    );
  }
}

class _YearTile extends StatefulWidget {
  const _YearTile({
    required this.year,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final int year;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_YearTile> createState() => _YearTileState();
}

class _YearTileState extends State<_YearTile> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 80),
    reverseDuration: const Duration(milliseconds: 160),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.88)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isSelected
        ? AppColors.brandPrimary500
        : (widget.isDark
            ? const Color(0xFF1E293B)
            : AppColors.brandPrimary500.withValues(alpha: 0.06));
    final textColor = widget.isSelected
        ? AppColors.white
        : (widget.isDark ? DarkModeColors.textPrimary : LightModeColors.textPrimary);

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.radiusSm),
          ),
          child: Center(
            child: Text(
              '${widget.year}',
              style: widget.isSelected
                  ? AppTypography.labelRegular(color: textColor)
                  : AppTypography.bodyMedium(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _DayCell {
  const _DayCell(this.day, this.date, this.isCurrentMonth);
  final int day;
  final DateTime date;
  final bool isCurrentMonth;
}

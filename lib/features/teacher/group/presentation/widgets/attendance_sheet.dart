import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_entity.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_text_field.dart';
import 'package:elara/shared/widgets/student_row_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Modal dialog for marking attendance.
class AttendanceDialog extends StatefulWidget {
  final List<TeacherStudentEntity> students;

  const AttendanceDialog({super.key, required this.students});

  static Future<void> show(
    BuildContext context, {
    required List<TeacherStudentEntity> students,
  }) {
    return AppDialog.show(
      context: context,
      builder: (ctx) => AttendanceDialog(students: students),
    );
  }

  @override
  State<AttendanceDialog> createState() => _AttendanceDialogState();
}

class _AttendanceDialogState extends State<AttendanceDialog> {
  late final Map<int, bool> _present;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // All students default to present
    _present = {for (final s in widget.students) s.rank: true};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TeacherStudentEntity> get _filtered {
    if (_query.isEmpty) return widget.students;
    return widget.students
        .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Attendance',
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          children: [
            // ── Search bar row ──────────────────────────────────────
            _AttendanceSearchBar(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
            ),
            SizedBox(height: AppSpacing.spacingMd.h),

            // ── Student list ────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _filtered.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: AppSpacing.spacingMd.h),
                itemBuilder: (_, i) {
                  final student = _filtered[i];
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  final borderColor = isDark
                      ? DarkModeColors.borderDefault
                      : LightModeColors.borderDefault;

                  return StudentRowCard(
                    studentName: student.name,
                    // No tap on the row — only the Switch is interactive
                    onTap: null,
                    cardColor: Theme.of(context).scaffoldBackgroundColor,
                    showShadow: false,
                    avatarSize: 40,
                    avatarChild: SvgPicture.asset(
                      'assets/icons/people_outline.svg',
                      width: 22.w,
                      height: 22.w,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSurfaceVariant,
                        BlendMode.srcIn,
                      ),
                    ),
                    trailing: Switch(
                      value: _present[student.rank] ?? true,
                      onChanged: (v) =>
                          setState(() => _present[student.rank] = v),
                      activeColor: AppColors.brandPrimary500,
                      trackOutlineColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.transparent;
                        }
                        return borderColor;
                      }),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.spacingLg.h),

            // ── Save button ─────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                text: 'Save Attendance',
                borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                onPressed: () {
                  // TODO: save attendance to backend
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Search bar with QR scan button
class _AttendanceSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _AttendanceSearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: controller,
            hintText: 'Search students...',
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: AppSpacing.spacingSm.w),

        // QR scan button
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/qr_code.svg',
              width: 20.w,
              height: 20.w,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

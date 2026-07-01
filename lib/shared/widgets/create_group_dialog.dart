import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/shared/widgets/app_dropdown_field.dart';

class GroupDialogConfig {
  final String title;
  final List<String> subjects;
  final List<String> grades;
  final bool showRoadmapName;
  final List<String> roadmaps;

  const GroupDialogConfig({
    this.title = 'Create a group',
    this.subjects = const [
      'Physics',
      'Chemistry',
      'Biology',
      'Mathematics',
      'English',
      'History',
    ],
    this.grades = const ['Grade 10', 'Grade 11', 'Grade 12'],
    this.showRoadmapName = true,
    this.roadmaps = const [],
  });
}

class GroupDialog extends StatelessWidget {
  final GroupDialogConfig config;

  static void show(
    BuildContext context, {
    GroupDialogConfig config = const GroupDialogConfig(),
    required void Function(
      String title,
      String subject,
      String grade,
      String roadmapName,
    )
    onSubmit,
  }) {
    String titleValue = '';
    String roadmapNameValue = '';
    String? subject;
    String? grade;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) => GroupDialog(
          config: config,
          titleValue: titleValue,
          roadmapNameValue: roadmapNameValue,
          selectedSubject: subject,
          selectedGrade: grade,
          onTitleChanged: (v) => setDialogState(() => titleValue = v),
          onRoadmapNameChanged: (v) =>
              setDialogState(() => roadmapNameValue = v),
          onSubjectChanged: (v) => setDialogState(() => subject = v),
          onGradeChanged: (v) => setDialogState(() => grade = v),
          onSubmit: () {
            if (titleValue.isEmpty ||
                (config.showRoadmapName && roadmapNameValue.isEmpty) ||
                subject == null ||
                grade == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill all required fields'),
                ),
              );
              return;
            }
            onSubmit(titleValue, subject!, grade!, roadmapNameValue);
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  final String titleValue;
  final String roadmapNameValue;
  final String? selectedSubject;
  final String? selectedGrade;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onRoadmapNameChanged;
  final ValueChanged<String?> onSubjectChanged;
  final ValueChanged<String?> onGradeChanged;
  final VoidCallback onSubmit;

  const GroupDialog({
    super.key,
    required this.config,
    required this.titleValue,
    required this.roadmapNameValue,
    required this.selectedSubject,
    required this.selectedGrade,
    required this.onTitleChanged,
    required this.onRoadmapNameChanged,
    required this.onSubjectChanged,
    required this.onGradeChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(title: config.title, cs: cs),
              SizedBox(height: AppSpacing.spacing2xl.h),
              _InputField(
                label: 'Title',
                hint: 'Enter group title (e.g., Physics 101)',
                value: titleValue,
                onChanged: onTitleChanged,
                cs: cs,
              ),
              SizedBox(height: AppSpacing.spacing2xl.h),
              _SubjectGradeRow(
                config: config,
                selectedSubject: selectedSubject,
                selectedGrade: selectedGrade,
                onSubjectChanged: onSubjectChanged,
                onGradeChanged: onGradeChanged,
                cs: cs,
              ),
              SizedBox(height: AppSpacing.spacing2xl.h),
              if (config.showRoadmapName) ...[
                AppDropdownField(
                  label: 'Roadmap',
                  hint: 'Select roadmap',
                  prefixIcon: Icon(Icons.map_outlined, size: 16.w),
                  options: config.roadmaps.isEmpty
                      ? ['No roadmaps available']
                      : config.roadmaps,
                  onChanged: onRoadmapNameChanged,
                  initialValue: roadmapNameValue.isEmpty
                      ? null
                      : roadmapNameValue,
                ),
                SizedBox(height: AppSpacing.spacing2xl.h),
              ],
              _SubmitButton(label: config.title, onTap: onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String title;
  final ColorScheme cs;

  const _Header({required this.title, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.h5(
            color: cs.onSurface,
          ).copyWith(fontWeight: FontWeight.w900),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/icons/clear_icon.svg',
            width: 16.w,
            height: 16.w,
            fit: BoxFit.scaleDown,
            colorFilter: ColorFilter.mode(cs.onSurfaceVariant, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatefulWidget {
  final String label;
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;
  final ColorScheme cs;

  const _InputField({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
    required this.cs,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _isFocused = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.bodyMedium(
            color: widget.cs.onSurface,
          ).copyWith(fontWeight: AppTypography.semiBold),
        ),
        SizedBox(height: AppSpacing.spacingSm.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            border: Border.all(
              color: _isFocused ? AppColors.brandPrimary500 : widget.cs.outline,
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.bodySmall(
                color: widget.cs.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd.w,
                vertical: AppSpacing.spacingMd.h,
              ),
            ),
            style: AppTypography.bodySmall(color: widget.cs.onSurface),
          ),
        ),
      ],
    );
  }
}

class _SubjectGradeRow extends StatelessWidget {
  final GroupDialogConfig config;
  final String? selectedSubject;
  final String? selectedGrade;
  final ValueChanged<String?> onSubjectChanged;
  final ValueChanged<String?> onGradeChanged;
  final ColorScheme cs;

  const _SubjectGradeRow({
    required this.config,
    required this.selectedSubject,
    required this.selectedGrade,
    required this.onSubjectChanged,
    required this.onGradeChanged,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppDropdownField(
            label: 'Subject',
            hint: 'Select subject',
            prefixIcon: Icon(Icons.book_outlined, size: 16.w),
            options: config.subjects,
            onChanged: onSubjectChanged,
            initialValue: selectedSubject,
          ),
        ),
        SizedBox(width: AppSpacing.spacingLg.w),
        Expanded(
          child: AppDropdownField(
            label: 'Grade',
            hint: 'Select grade',
            prefixIcon: Icon(Icons.school_outlined, size: 16.w),
            options: config.grades,
            onChanged: onGradeChanged,
            initialValue: selectedGrade,
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SubmitButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandPrimary500,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.spacingMd.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge(
            color: AppColors.neutral50,
          ).copyWith(fontWeight: AppTypography.semiBold),
        ),
      ),
    );
  }
}

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_resource_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dialog content for adding a new resource.
/// [type] is pre-selected by the section that triggered the dialog.
class TeacherAddResourceDialogContent extends StatefulWidget {
  final TeacherResourceType type;
  final void Function(String title, String url, String description) onSubmit;

  const TeacherAddResourceDialogContent({
    super.key,
    required this.type,
    required this.onSubmit,
  });

  @override
  State<TeacherAddResourceDialogContent> createState() =>
      _TeacherAddResourceDialogContentState();
}

class _TeacherAddResourceDialogContentState
    extends State<TeacherAddResourceDialogContent> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _urlCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _urlCtrl = TextEditingController();
    _descCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _urlCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    final url = _urlCtrl.text.trim();
    if (title.isEmpty || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and URL are required')),
      );
      return;
    }
    widget.onSubmit(title, url, _descCtrl.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
      borderSide: BorderSide.none,
    );

    InputDecoration fieldDeco(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
      filled: true,
      fillColor: cs.surfaceContainerHighest,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingMd.w,
        vertical: AppSpacing.spacingMd.h,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Read-only type chip
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingMd.w,
              vertical: AppSpacing.spacingXs.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary500,
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
            ),
            child: Text(
              widget.type.label,
              style: AppTypography.labelSmall(color: AppColors.white),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.spacingMd.h),

        // Title field
        Text('Title', style: AppTypography.labelRegular(color: cs.onSurface)),
        SizedBox(height: AppSpacing.spacingXs.h),
        TextField(
          controller: _titleCtrl,
          style: AppTypography.bodyMedium(color: cs.onSurface),
          decoration: fieldDeco('Resource title…'),
        ),
        SizedBox(height: AppSpacing.spacingMd.h),

        // URL field
        Text('URL', style: AppTypography.labelRegular(color: cs.onSurface)),
        SizedBox(height: AppSpacing.spacingXs.h),
        TextField(
          controller: _urlCtrl,
          style: AppTypography.bodyMedium(color: cs.onSurface),
          keyboardType: TextInputType.url,
          decoration: fieldDeco('https://…'),
        ),
        SizedBox(height: AppSpacing.spacingMd.h),

        // Description field
        Text(
          'Description (optional)',
          style: AppTypography.labelRegular(color: cs.onSurface),
        ),
        SizedBox(height: AppSpacing.spacingXs.h),
        TextField(
          controller: _descCtrl,
          style: AppTypography.bodyMedium(color: cs.onSurface),
          maxLines: 3,
          decoration: fieldDeco('Brief description…'),
        ),
        SizedBox(height: AppSpacing.spacingXl.h),

        // Submit button
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.brandPrimary500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
            ),
          ),
          child: Text(
            'Add Resource',
            style: AppTypography.labelRegular(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

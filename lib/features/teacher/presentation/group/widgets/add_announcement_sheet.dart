import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/localization/localization_extension.dart';

/// Bottom sheet for adding or editing an announcement.
/// [isEdit] = true shows "Edit Announcement" title and pre-fills fields.
class AddAnnouncementSheet extends StatefulWidget {
  final String? initialTitle;
  final String? initialBody;
  final bool isEdit;

  const AddAnnouncementSheet({
    super.key,
    this.initialTitle,
    this.initialBody,
    this.isEdit = false,
  });

  @override
  State<AddAnnouncementSheet> createState() => _AddAnnouncementSheetState();
}

class _AddAnnouncementSheetState extends State<AddAnnouncementSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _bodyController = TextEditingController(text: widget.initialBody ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _bodyController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg.w,
        AppSpacing.spacingLg.h,
        AppSpacing.spacingLg.w,
        AppSpacing.spacing2xl.h + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.radiusXl.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.spacingLg.h),

          // Header
          Row(
            children: [
              Text(
                widget.isEdit ? context.l10n.teacherEditAnnouncement : context.l10n.teacherAddAnnouncementTitle,
                style: AppTypography.h5(color: cs.onSurface)
                    .copyWith(fontWeight: AppTypography.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: cs.onSurfaceVariant),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),

          // Title field
          _FormLabel(text: context.l10n.teacherAnnouncementTitleField, cs: cs),
          SizedBox(height: AppSpacing.spacingSm.h),
          _FormField(
            controller: _titleController,
            hintText: context.l10n.teacherEnterAnnouncementTitle,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.spacingLg.h),

          // Body field
          _FormLabel(text: context.l10n.teacherAnnouncementBodyField, cs: cs),
          SizedBox(height: AppSpacing.spacingSm.h),
          _FormField(
            controller: _bodyController,
            hintText: context.l10n.teacherEnterAnnouncementBody,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canSubmit
                  ? () {
                      // TODO: save to backend
                      Navigator.pop(context);
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandPrimary500,
                disabledBackgroundColor: AppColors.brandPrimary200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                ),
                padding: EdgeInsets.symmetric(vertical: AppSpacing.spacingMd.h),
              ),
              child: Text(
                widget.isEdit ? context.l10n.teacherSaveChanges : context.l10n.teacherAddAnnouncement,
                style: AppTypography.labelLarge(color: AppColors.white)
                    .copyWith(fontWeight: AppTypography.semiBold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  final ColorScheme cs;
  const _FormLabel({required this.text, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodyMedium(color: cs.onSurface)
          .copyWith(fontWeight: AppTypography.semiBold),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const _FormField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodySmall(color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingMd.w,
          vertical: AppSpacing.spacingMd.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
          borderSide: BorderSide(color: cs.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
          borderSide: const BorderSide(
            color: AppColors.brandPrimary500,
            width: 2,
          ),
        ),
      ),
      style: AppTypography.bodySmall(color: cs.onSurface),
    );
  }
}

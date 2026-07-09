import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:elara/core/localization/localization_extension.dart';
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

  String? _pickedFilePath;
  String? _pickedFileName;

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

  Future<void> _pickFile() async {
    try {
      FileType fileType = FileType.any;
      List<String>? allowedExtensions;

      switch (widget.type) {
        case TeacherResourceType.video:
          fileType = FileType.video;
          break;
        case TeacherResourceType.image:
          fileType = FileType.image;
          break;
        case TeacherResourceType.pdf:
          fileType = FileType.custom;
          allowedExtensions = ['pdf'];
          break;
        default:
          fileType = FileType.any;
          break;
      }

      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pickedFilePath = result.files.single.path;
          _pickedFileName = result.files.single.name;
          if (_titleCtrl.text.isEmpty) {
            _titleCtrl.text = _pickedFileName ?? '';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.teacherFailedPickFile('$e'))),
        );
      }
    }
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    final url = widget.type == TeacherResourceType.link
        ? _urlCtrl.text.trim()
        : _pickedFilePath;

    if (title.isEmpty || url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.teacherTitleAndFileRequired(
              widget.type == TeacherResourceType.link
                  ? context.l10n.teacherUrlResource
                  : context.l10n.teacherFileResource,
            ),
          ),
        ),
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
        // Title field
        Text(
          context.l10n.teacherTitleResource,
          style: AppTypography.labelRegular(color: cs.onSurface),
        ),
        SizedBox(height: AppSpacing.spacingXs.h),
        TextField(
          controller: _titleCtrl,
          style: AppTypography.bodyMedium(color: cs.onSurface),
          decoration: fieldDeco(context.l10n.teacherResourceTitleHint),
        ),
        SizedBox(height: AppSpacing.spacingMd.h),

        // Link or File field
        if (widget.type == TeacherResourceType.link) ...[
          Text(
            context.l10n.teacherUrlResource,
            style: AppTypography.labelRegular(color: cs.onSurface),
          ),
          SizedBox(height: AppSpacing.spacingXs.h),
          TextField(
            controller: _urlCtrl,
            style: AppTypography.bodyMedium(color: cs.onSurface),
            keyboardType: TextInputType.url,
            decoration: fieldDeco(context.l10n.teacherUrlHint),
          ),
        ] else ...[
          Text(
            context.l10n.teacherFileResource,
            style: AppTypography.labelRegular(color: cs.onSurface),
          ),
          SizedBox(height: AppSpacing.spacingXs.h),
          InkWell(
            onTap: _pickFile,
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd.w,
                vertical: AppSpacing.spacingMd.h,
              ),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_file_rounded,
                    color: cs.onSurfaceVariant,
                    size: 20.sp,
                  ),
                  SizedBox(width: AppSpacing.spacingSm.w),
                  Expanded(
                    child: Text(
                      _pickedFileName ?? context.l10n.teacherTapSelectFile,
                      style: AppTypography.bodyMedium(
                        color: _pickedFileName != null
                            ? cs.onSurface
                            : cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: AppSpacing.spacingMd.h),

        // Description field
        Text(
          context.l10n.teacherDescriptionOptional,
          style: AppTypography.labelRegular(color: cs.onSurface),
        ),
        SizedBox(height: AppSpacing.spacingXs.h),
        TextField(
          controller: _descCtrl,
          style: AppTypography.bodyMedium(color: cs.onSurface),
          maxLines: 3,
          decoration: fieldDeco(context.l10n.teacherBriefDescription),
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
            context.l10n.teacherAddResourceDialog,
            style: AppTypography.labelRegular(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

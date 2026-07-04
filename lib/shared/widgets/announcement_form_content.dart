import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable announcement form — Title + Body labeled inputs + a submit button.
///
/// Used in both Add and Edit announcement dialogs. Keep it [StatefulWidget]
/// to own the controller lifecycle; the cubit only handles submission.
///
/// ```dart
/// AnnouncementFormContent(
///   submitLabel: 'Add Announcement',
///   onSubmit: (title, body) { /* dispatch cubit event */ },
/// )
/// // Edit mode — pre-fill the fields:
/// AnnouncementFormContent(
///   initialTitle: item.title,
///   initialBody:  item.body,
///   submitLabel:  'Save Changes',
///   onSubmit: (title, body) { /* dispatch cubit event */ },
/// )
/// ```
class AnnouncementFormContent extends StatefulWidget {
  /// Pre-fills the first field (edit mode). Null → empty (add mode).
  final String? initialTitle;

  /// Pre-fills the second field (edit mode). Null → empty (add mode).
  final String? initialBody;

  /// Label shown on the submit button.
  final String submitLabel;

  final void Function(String title, String body) onSubmit;

  // ── Optional field customisation (defaults to announcement labels) ────────
  final String firstFieldLabel;
  final String firstFieldPlaceholder;
  final String secondFieldLabel;
  final String secondFieldPlaceholder;

  /// Whether the second field is multiline.
  final int secondFieldMaxLines;

  const AnnouncementFormContent({
    super.key,
    this.initialTitle,
    this.initialBody,
    required this.submitLabel,
    required this.onSubmit,
    this.firstFieldLabel = 'Title',
    this.firstFieldPlaceholder =
        'Enter announcement title (e.g., Quiz next Friday!)',
    this.secondFieldLabel = 'Body',
    this.secondFieldPlaceholder = 'Enter announcement body',
    this.secondFieldMaxLines = 4,
  });

  @override
  State<AnnouncementFormContent> createState() =>
      _AnnouncementFormContentState();
}

class _AnnouncementFormContentState extends State<AnnouncementFormContent> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _bodyCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    _bodyCtrl = TextEditingController(text: widget.initialBody ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    if (title.isEmpty || body.isEmpty) {
      AppSnackBar.warning(context, 'Please fill in all fields');
      return;
    }

    widget.onSubmit(title, body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //   Fields
        _LabeledInputField(
          label: widget.firstFieldLabel,
          placeholder: widget.firstFieldPlaceholder,
          controller: _titleCtrl,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSpacing.spacingSm.h), // 8px

        _LabeledInputField(
          label: widget.secondFieldLabel,
          placeholder: widget.secondFieldPlaceholder,
          controller: _bodyCtrl,
          maxLines: widget.secondFieldMaxLines,
          textInputAction: TextInputAction.done,
        ),

        // ── Submit button (gap 16px below the fields) ─────────────────────
        SizedBox(height: AppSpacing.spacingLg.h), // 16px

        AppPrimaryButton(
          text: widget.submitLabel,
          onPressed: _submit,
          borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
        ),
      ],
    );
  }
}

// ── Labeled input field ───────────────────────────────────────────────────────

/// A label text above a dark-filled rounded input box.
/// Matches the Figma "Input Field" component spec:
///   fill #0F172A · radius 16px · padding 8px 12px · inset shadow.
class _LabeledInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final int maxLines;
  final TextInputAction? textInputAction;

  const _LabeledInputField({
    required this.label,
    required this.placeholder,
    required this.controller,
    this.maxLines = 1,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(label, style: AppTypography.labelRegular(color: cs.onSurface)),

        // Input box
        Container(
          margin: EdgeInsets.only(top: AppSpacing.spacingXs.h),
          decoration: BoxDecoration(
            // #0F172A = neutral900 = scaffold background in dark mode
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r), // 16px
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            textInputAction: textInputAction,
            textCapitalization: TextCapitalization.sentences,
            style: AppTypography.bodySmall(color: cs.onSurface),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd.w, // 12px
                vertical: AppSpacing.spacingSm.h, // 8px
              ),
              hintText: placeholder,
              hintStyle: AppTypography.bodySmall(color: AppColors.neutral300),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

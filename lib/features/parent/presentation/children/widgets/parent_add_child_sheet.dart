import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/shared/widgets/app_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showParentAddChildSheet(BuildContext context) {
  return showAppFormDialog<void>(context, child: const ParentAddChildSheet());
}

class ParentAddChildSheet extends StatefulWidget {
  const ParentAddChildSheet({super.key});

  @override
  State<ParentAddChildSheet> createState() => _ParentAddChildSheetState();
}

class _ParentAddChildSheetState extends State<ParentAddChildSheet> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    // TODO: wire link-child use case when backend exists
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialogBody(
      title: 'Add a child',
      children: [
        AppFormDialogTextField(
          controller: _usernameController,
          hintText: "Child's username",
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        AppFormDialogPrimaryButton(label: 'Send request', onPressed: _submit),
        SizedBox(height: AppSpacing.spacingSm.h),
      ],
    );
  }
}

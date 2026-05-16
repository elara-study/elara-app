import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/shared/widgets/app_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showProfileLinkParentSheet(BuildContext context) {
  return showAppFormDialog<void>(
    context,
    child: const ProfileLinkParentSheet(),
  );
}

class ProfileLinkParentSheet extends StatefulWidget {
  const ProfileLinkParentSheet({super.key});

  @override
  State<ProfileLinkParentSheet> createState() => _ProfileLinkParentSheetState();
}

class _ProfileLinkParentSheetState extends State<ProfileLinkParentSheet> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialogBody(
      title: 'Link a Parent',
      children: [
        AppFormDialogTextField(
          controller: _usernameController,
          hintText: "Enter your parent's username",
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        AppFormDialogPrimaryButton(label: 'Link Parent', onPressed: _submit),
        SizedBox(height: AppSpacing.spacingSm.h),
      ],
    );
  }
}

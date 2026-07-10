import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/shared/widgets/app_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';
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
      title: context.l10n.profileLinkParentTitle,
      children: [
        AppFormDialogTextField(
          controller: _usernameController,
          hintText: context.l10n.profileLinkParentHint,
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        AppFormDialogPrimaryButton(
          label: context.l10n.profileLinkParentButton,
          onPressed: _submit,
        ),
        SizedBox(height: AppSpacing.spacingSm.h),
      ],
    );
  }
}

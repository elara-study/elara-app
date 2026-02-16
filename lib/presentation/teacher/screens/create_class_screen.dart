import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateClassScreen extends StatelessWidget {
  const CreateClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'teacher.createClass'.tr, showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'teacher.className'.tr,
                  hintText: 'teacher.classNameHint'.tr,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              TextField(
                decoration: InputDecoration(
                  labelText: 'teacher.description'.tr,
                  hintText: 'teacher.descriptionHint'.tr,
                ),
                maxLines: 3,
              ),
              const Spacer(),
              AppPrimaryButton(
                text: 'teacher.createClass'.tr,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

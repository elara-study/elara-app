import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_state.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Join a Group" modal dialog overlay.
///
/// Show it via [JoinGroupDialog.show] — never instantiate directly.
class JoinGroupDialog extends StatefulWidget {
  const JoinGroupDialog({super.key});

  /// Convenience method — launches the dialog above everything including
  /// the bottom nav bar. [cubit] must be passed since the dialog is
  /// rendered in a new overlay route outside the current BlocProvider tree.
  static Future<void> show(BuildContext context, StudentLearnCubit cubit) {
    return AppDialog.show(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: const JoinGroupDialog(),
      ),
    );
  }

  @override
  State<JoinGroupDialog> createState() => _JoinGroupDialogState();
}

class _JoinGroupDialogState extends State<JoinGroupDialog> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocListener<StudentLearnCubit, StudentLearnState>(
      listener: (context, state) {
        if (state is StudentLearnJoinSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully joined the group!'),
              backgroundColor: AppColors.success500,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is StudentLearnError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error500,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: AppDialog(
        title: 'Join a Group',
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the group code provided by your teacher',
                style: AppTypography.bodySmall(
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.spacingLg.h),

              // ── Code input ─
              AppTextField(
                controller: _codeController,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                hintText: 'Enter group code (e.g., ABCD1234)',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a group code';
                  }
                  if (val.trim().length < 4) {
                    return 'Code must be at least 4 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: AppSpacing.spacingLg.h),

              // ── Join button ───────────────────────────────────────
              BlocBuilder<StudentLearnCubit, StudentLearnState>(
                builder: (context, state) {
                  final isJoining = state is StudentLearnJoining;
                  return Container(
                    width: double.infinity,
                    height: AppSpacing.spacing2xl.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppRadius.radiusFull.r,
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ButtonColors.primaryDefault,
                        foregroundColor: ButtonColors.primaryText,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.radiusFull.r,
                          ),
                        ),
                      ),
                      onPressed: isJoining
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<StudentLearnCubit>().joinGroup(
                                  _codeController.text.trim(),
                                );
                              }
                            },
                      child: isJoining
                          ? SizedBox(
                              width: AppSpacing.spacingLg.w,
                              height: AppSpacing.spacingLg.w,
                              child: const CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Join Group',
                              style: AppTypography.labelSmall(
                                color: ButtonColors.primaryText,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

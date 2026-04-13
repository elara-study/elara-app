import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_state.dart';
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
  static Future<void> show(
    BuildContext context,
    StudentLearnCubit cubit,
  ) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Join Group',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, _, __) => BlocProvider.value(
        value: cubit,
        child: const JoinGroupDialog(),
      ),
      transitionBuilder: (ctx, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.12),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
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
    return BlocListener<StudentLearnCubit, StudentLearnState>(
      listener: (context, state) {
        if (state is StudentLearnJoinSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully joined the group! 🎉'),
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
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 28.h),
            decoration: BoxDecoration(
              color: LightModeColors.surfacePrimary,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral900.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Join a Group',
                        style: AppTypography.h5(
                          color: LightModeColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: const BoxDecoration(
                            color: AppColors.neutral100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16.sp,
                            color: LightModeColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    'Enter the group code provided by your teacher',
                    style: AppTypography.bodySmall(
                      color: LightModeColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ── Code input ────────────────────────────────────────
                  TextFormField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.done,
                    style: AppTypography.bodyMedium(
                      color: LightModeColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter group code (e.g., ABCD1234)',
                      hintStyle: AppTypography.bodySmall(
                        color: LightModeColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: LightModeColors.surfaceApp,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusMd.r),
                        borderSide: const BorderSide(
                          color: LightModeColors.borderDefault,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusMd.r),
                        borderSide: const BorderSide(
                          color: LightModeColors.borderDefault,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusMd.r),
                        borderSide: const BorderSide(
                          color: LightModeColors.borderFocused,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusMd.r),
                        borderSide: const BorderSide(
                          color: AppColors.error500,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppRadius.radiusMd.r),
                        borderSide: const BorderSide(
                          color: AppColors.error500,
                          width: 2,
                        ),
                      ),
                    ),
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

                  SizedBox(height: 20.h),

                  // ── Join button ───────────────────────────────────────
                  BlocBuilder<StudentLearnCubit, StudentLearnState>(
                    builder: (context, state) {
                      final isJoining = state is StudentLearnJoining;
                      return SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: isJoining
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<StudentLearnCubit>().joinGroup(
                                          _codeController.text.trim(),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandPrimary500,
                            disabledBackgroundColor: AppColors.brandPrimary200,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.radiusMd.r),
                            ),
                          ),
                          child: isJoining
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Join Group',
                                  style: AppTypography.button(
                                    color: AppColors.white,
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
        ),
      ),
    );
  }
}

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

/// "Join a Group" modal dialog overlay.
///
/// Show it via [JoinGroupDialog.show] — never instantiate directly.
class JoinGroupDialog extends StatefulWidget {
  const JoinGroupDialog({super.key});

  /// Convenience method — launches the dialog above everything including
  /// the bottom nav bar. [cubit] must be passed since the dialog is
  /// rendered in a new overlay route outside the current BlocProvider tree.
  static Future<void> show(BuildContext context, StudentLearnCubit cubit) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Join Group',
      barrierColor: AppColors.neutral900.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, _, __) =>
          BlocProvider.value(value: cubit, child: const JoinGroupDialog()),
      transitionBuilder: (ctx, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.12),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
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
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.spacing2xl.w),
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
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
                        ).copyWith(fontWeight: AppTypography.extraBold),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: SvgPicture.asset(
                          'assets/icons/clear_icon.svg',
                          width: 10.w,
                          height: 10.w,
                          colorFilter: const ColorFilter.mode(
                            LightModeColors.textPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'Enter the group code provided by your teacher',
                    style: AppTypography.bodySmall(
                      color: LightModeColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.spacingLg.h),

                  // ── Code input ─
                  TextFormField(
                    controller: _codeController,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.done,
                    style: AppTypography.bodyMedium(
                      color: LightModeColors.textPrimary,
                    ).copyWith(fontWeight: AppTypography.regular),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LightModeColors.surfaceApp,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingMd.w,
                        vertical: AppSpacing.spacingSm.h,
                      ),
                      hintText: 'Enter group code (e.g., ABCD1234)',
                      hintStyle: AppTypography.bodySmall(
                        color: LightModeColors.textSecondary,
                      ).copyWith(fontWeight: AppTypography.regular),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          100,
                        ), // Full pill shape
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
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

                  SizedBox(height: AppSpacing.spacingSm.h),

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
        ),
      ),
    );
  }
}

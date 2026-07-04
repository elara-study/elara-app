import 'package:elara/core/enums/subject_type.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:elara/shared/widgets/app_calendar_widget.dart';
import 'package:elara/shared/widgets/app_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

/// The sign-up credentials form card.
///
/// Owns all [TextEditingController]s and the [FormState] key internally so
/// the parent screen stays thin and focused on BLoC concerns.
class SignUpForm extends StatefulWidget {
  final UserRole role;
  final bool isLoading;
  final bool isGoogleFlow;
  final void Function({
    required String name,
    required String email,
    required String password,
    required DateTime dateOfBirth,
    String? subjectDisplayName,
    int? grade,
  })
  onSubmit;

  const SignUpForm({
    super.key,
    required this.role,
    required this.isLoading,
    this.isGoogleFlow = false,
    required this.onSubmit,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  DateTime? _birthday;
  String? _selectedSubject;
  int? _selectedGrade;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final picked = await showAppCalendarDialog(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 18, now.month, now.day),
      selectedDate: _birthday,
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 5, now.month, now.day),
    );
    if (picked != null) setState(() => _birthday = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_birthday == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.authBirthdayRequired),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSm),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingSm,
            ),
            duration: const Duration(seconds: 3),
            animation: CurvedAnimation(
              parent: const AlwaysStoppedAnimation(1),
              curve: Curves.easeOutCubic,
            ),
          ),
        );
      return;
    }
    if (widget.role == UserRole.student && _selectedGrade == null) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.authGradeRequired),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSm),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingSm,
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      return;
    }
    widget.onSubmit(
      name: _fullNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      dateOfBirth: _birthday!,
      subjectDisplayName: _selectedSubject,
      grade: _selectedGrade,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? DarkModeColors.textPrimary : LightModeColors.textPrimary;
    final fillColor =
        isDark ? DarkModeColors.surfaceSecondary : LightModeColors.surfaceApp;
    final hintColor =
        isDark ? DarkModeColors.textSecondary : LightModeColors.textSecondary;
    final borderColor =
        isDark ? DarkModeColors.borderDefault : LightModeColors.borderDefault;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthCardHeader(
            title: widget.isGoogleFlow
                ? context.l10n.authCompleteProfile
                : context.l10n.authEnterCredentials,
            subtitle: widget.isGoogleFlow
                ? context.l10n.authCompleteProfileSubtitle
                : context.l10n.authEnterCredentialsSubtitle,
          ),

          const SizedBox(height: AppSpacing.spacingLg),

          // ── Credential fields (hidden in Google flow) ──────────
          if (!widget.isGoogleFlow) ...[
            //   Full Name
            AuthCardField(
              label: context.l10n.authFullName,
              hint: context.l10n.authFullNameHint,
              controller: _fullNameCtrl,
              textInputAction: TextInputAction.next,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return context.l10n.authFullNameRequired;
                }
                if (val.trim().length < 3) {
                  return context.l10n.authNameTooShort;
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.spacingSm),

            //    Username
            AuthCardField(
              label: context.l10n.authUsername,
              hint: '@ ${context.l10n.authUsernameHint}',
              controller: _usernameCtrl,
              textInputAction: TextInputAction.next,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return context.l10n.authUsernameRequired;
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.spacingSm),

            //    Email
            AuthCardField(
              label: context.l10n.authEmail,
              hint: context.l10n.authEmailHint,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (val) {
                if (val == null || val.isEmpty) return context.l10n.authEmailRequired;
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                  return context.l10n.authEmailInvalid;
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.spacingSm),

            //    Password
            AuthCardField(
              label: context.l10n.authPassword,
              hint: context.l10n.authPasswordHintSecure,
              controller: _passwordCtrl,
              isPassword: true,
              textInputAction: TextInputAction.next,
              validator: (val) {
                if (val == null || val.isEmpty) return context.l10n.authNewPasswordRequired;
                if (val.length < 8) {
                  return context.l10n.authNewPasswordTooShort;
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.spacingSm),

            //    Confirm Password
            AuthCardField(
              label: context.l10n.authConfirmPassword,
              hint: context.l10n.authPasswordConfirmHint,
              controller: _confirmPasswordCtrl,
              isPassword: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return context.l10n.authConfirmPasswordRequired;
                }
                if (val != _passwordCtrl.text) return context.l10n.authPasswordsMustMatch;
                return null;
              },
            ),
          ], // end if (!widget.isGoogleFlow)

          //   Date of Birth — all roles
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.authBirthday,
                style: AppTypography.labelRegular(color: labelColor),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickBirthday,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16.w,
                        color: _birthday != null
                            ? AppColors.brandPrimary500
                            : hintColor,
                      ),
                      const SizedBox(width: AppSpacing.spacingSm),
                      Expanded(
                        child: Text(
                          _birthday != null
                              ? DateFormat('dd/MM/yyyy').format(_birthday!)
                              : 'dd / mm / yyyy',
                          style: AppTypography.bodySmall(
                            color: _birthday != null ? labelColor : hintColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //  Subject — teacher only (uses backend SubjectType enum)
          if (widget.role == UserRole.teacher) ...[
            const SizedBox(height: AppSpacing.spacingSm),
            AppDropdownField(
              label: context.l10n.authSubject,
              hint: context.l10n.authSubjectHint,
              prefixIcon: Icon(Icons.school_outlined, size: 16.w),
              options: SubjectType.displayNames,
              onChanged: (v) => setState(() => _selectedSubject = v),
            ),
          ],

          //  Grade — student only
          if (widget.role == UserRole.student) ...[
            const SizedBox(height: AppSpacing.spacingSm),
            AppDropdownField(
              label: context.l10n.authGrade,
              hint: context.l10n.authGradeHint,
              prefixIcon: Icon(Icons.school_outlined, size: 16.w),
              options: [
                '${context.l10n.authGrade} 10',
                '${context.l10n.authGrade} 11',
                '${context.l10n.authGrade} 12',
              ],
              onChanged: (v) {
                // Parse grade number out of selected option name (e.g. 'Grade 12' -> 12)
                final numberStr = RegExp(r'\d+').stringMatch(v);
                if (numberStr != null) {
                  setState(() => _selectedGrade = int.tryParse(numberStr));
                }
              },
            ),
          ],

          const SizedBox(height: AppSpacing.spacingLg),

          //   Submit
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: widget.isGoogleFlow ? context.l10n.authCompleteRegistration : context.l10n.authSignUp,
              isLoading: widget.isLoading,
              onPressed: _submit,
              leading: SvgPicture.asset(
                'assets/icons/join_icon.svg',
                colorFilter: const ColorFilter.mode(
                  ButtonColors.primaryText,
                  BlendMode.srcIn,
                ),
              ),
              borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spacingSm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

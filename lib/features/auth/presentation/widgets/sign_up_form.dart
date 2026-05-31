import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';

import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:elara/shared/widgets/app_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// The sign-up credentials form card.
///
/// Owns all [TextEditingController]s and the [FormState] key internally so
/// the parent screen stays thin and focused on BLoC concerns.
class SignUpForm extends StatefulWidget {
  final UserRole role;
  final bool isLoading;
  final void Function({
    required String fullName,
    required String email,
    required String password,
  })
  onSubmit;

  const SignUpForm({
    super.key,
    required this.role,
    required this.isLoading,
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
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        fullName: _fullNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthCardHeader(
            title: "Enter your credentials",
            subtitle: "Please enter your details to continue",
          ),

          const SizedBox(height: AppSpacing.spacingLg),

          //   Full Name
          AuthCardField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _fullNameCtrl,
            textInputAction: TextInputAction.next,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Full name is required';
              }
              if (val.trim().length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.spacingSm),

          //    Username
          AuthCardField(
            label: 'Username',
            hint: '@ Enter a unique username',
            controller: _usernameCtrl,
            textInputAction: TextInputAction.next,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Username is required';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.spacingSm),

          //    Email
          AuthCardField(
            label: 'Email',
            hint: 'Enter your email address',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.spacingSm),

          //    Password
          AuthCardField(
            label: 'Password',
            hint: 'Enter a secure password',
            controller: _passwordCtrl,
            isPassword: true,
            textInputAction: TextInputAction.next,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Password is required';
              if (val.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.spacingSm),

          //    Confirm Password
          AuthCardField(
            label: 'Confirm Password',
            hint: 'Enter your password again',
            controller: _confirmPasswordCtrl,
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please confirm your password';
              }
              if (val != _passwordCtrl.text) return 'Passwords do not match';
              return null;
            },
          ),

          //   Phone (teacher + parent only)
          if (widget.role == UserRole.teacher ||
              widget.role == UserRole.parent) ...[
            const SizedBox(height: AppSpacing.spacingSm),
            AuthCardField(
              label: 'Phone Number',
              hint: '+ 20 10 12345678',
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              // prefixIcon: const Icon(Icons.phone_outlined, size: 16),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            ),
          ],

          //  Subject (teacher only)
          if (widget.role == UserRole.teacher) ...[
            const SizedBox(height: AppSpacing.spacingSm),
            AppDropdownField(
              label: 'Subject',
              hint: 'Select your subject',
              prefixIcon: Icon(Icons.school_outlined, size: 16.w),
              options: const [
                'Mathematics',
                'Science',
                'Physics',
                'Chemistry',
                'Biology',
                'English',
                'Arabic',
                'History',
                'Geography',
                'Computer Science',
                'Art',
                'Physical Education',
              ],
            ),
          ],
          if (widget.role == UserRole.student) ...[
            const SizedBox(height: AppSpacing.spacingSm),
            AppDropdownField(
              label: 'Grade',
              hint: 'Select your grade',
              prefixIcon: Icon(Icons.school_outlined, size: 16.w),
              options: const [
                'Kindergarten',
                'Grade 1',
                'Grade 2',
                'Grade 3',
                'Grade 4',
                'Grade 5',
                'Grade 6',
                'Grade 7',
                'Grade 8',
                'Grade 9',
                'Grade 10',
                'Grade 11',
                'Grade 12',
              ],
            ),
          ],

          //  Country (all roles — UI only)
          const SizedBox(height: AppSpacing.spacingSm),
          AppDropdownField(
            label: 'Country',
            hint: 'Select your country',
            prefixIcon: SvgPicture.asset(
              'assets/icons/world_icon.svg',
              width: 16.w,
              height: 16.h,
              colorFilter: const ColorFilter.mode(
                ButtonColors.primaryText,
                BlendMode.srcIn,
              ),
            ),
            options: const ['Egypt', 'United States'],
          ),

          const SizedBox(height: AppSpacing.spacingLg),

          //   Submit
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: 'Sign Up',
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

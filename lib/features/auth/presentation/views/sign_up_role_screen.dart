import 'package:elara/config/routes.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/widgets/auth_header.dart';
import 'package:elara/features/auth/presentation/widgets/role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpRoleScreen extends StatefulWidget {
  const SignUpRoleScreen({super.key});

  @override
  State<SignUpRoleScreen> createState() => _SignUpRoleScreenState();
}

class _SignUpRoleScreenState extends State<SignUpRoleScreen> {
  UserRole? _selectedRole;

  void _onRoleTap(UserRole role) {
    setState(() => _selectedRole = role);
    context.read<AuthCubit>().selectRole(role);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        AppRoutes.signUpCredentials,
        arguments: role,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandPrimary100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 136.09.h),

              const AuthHeader(
                title: 'Create your account',
                subtitle: 'Sign up to start your study journey',
              ),

              SizedBox(height: 36.h),

              ...UserRole.values.map(
                (role) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: RoleCard(
                    role: role,
                    isSelected: _selectedRole == role,
                    onTap: () => _onRoleTap(role),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?  ',
                    style: AppTypography.labelSmall(
                      color: LightModeColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    ),
                    child: Text(
                      'Sign in',
                      style: AppTypography.labelSmall(
                        color: ButtonColors.ghostText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

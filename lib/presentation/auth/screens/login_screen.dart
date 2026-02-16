import 'package:elara/config/routes.dart';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/data/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

/// Sign in screen per Figma: Welcome to elara, email/password, Sign in, Sign up link.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final authService = getIt<AuthService>();
        await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelector);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _onSignUp() {
    Navigator.of(context).pushNamed(AppRoutes.signUpCredentials);
  }

  void _onForgotPassword() {
    // TODO: Forgot password flow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.spacing4xl),
                Center(
                  child: SvgPicture.asset(
                    'assets/logo/logo.svg',
                    width: 120,
                    height: 71,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing2xl),
                Text(
                  'Welcome to elara',
                  style: AppTypography.h3(color: AppColors.neutral900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.spacingSm),
                Text(
                  'Sign in to start your study journey',
                  style: AppTypography.bodyLarge(color: AppColors.neutral600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.spacing3xl),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.neutral500,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.spacingSm),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppGhostButton(
                    text: 'Forgot password?',
                    onPressed: _onForgotPassword,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                AppPrimaryButton(
                  text: 'Sign in',
                  onPressed: _isLoading ? null : _onSignIn,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppSpacing.spacing2xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppTypography.labelSmall(color: AppColors.neutral900),
                    ),
                    const SizedBox(width: AppSpacing.spacingXs),
                    TextButton(
                      onPressed: _onSignUp,
                      child: Text(
                        'Sign up',
                        style: AppTypography.labelSmall(
                          color: AppColors.brandPrimary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

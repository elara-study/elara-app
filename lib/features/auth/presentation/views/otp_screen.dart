import 'dart:async';

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

/// Route arguments for [OtpScreen].
class OtpRouteArgs {
  /// The email address that the OTP was sent to.
  final String email;

  /// Callback invoked when the user submits a valid code.
  /// Receives the 6-digit OTP string. Return a Future so the
  /// screen can show the loading state while the caller verifies.
  final Future<void> Function(String otp) onVerify;

  /// Callback invoked when the user taps "Resend code".
  final Future<void> Function() onResend;

  const OtpRouteArgs({
    required this.email,
    required this.onVerify,
    required this.onResend,
  });
}

class OtpScreen extends StatelessWidget {
  final OtpRouteArgs args;

  const OtpScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        builder: (context, m) => _OtpCardContent(args: args, metrics: m),
      ),
    );
  }
}

class _OtpCardContent extends StatefulWidget {
  final OtpRouteArgs args;
  final AuthScreenMetrics metrics;

  const _OtpCardContent({required this.args, required this.metrics});

  @override
  State<_OtpCardContent> createState() => _OtpCardContentState();
}

class _OtpCardContentState extends State<_OtpCardContent> {
  static const int _codeLength = 6;
  static const int _resendCooldownSeconds = 60;

  // One controller + focus node per digit box.
  final List<TextEditingController> _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Resend countdown
  int _resendCooldown = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  //   Helpers

  String get _currentCode => _controllers.map((c) => c.text).join();

  bool get _isCodeComplete => _currentCode.length == _codeLength;

  void _clearError() {
    if (_hasError) setState(() => _hasError = false);
  }

  void _startResendCooldown() {
    setState(() => _resendCooldown = _resendCooldownSeconds);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCooldown <= 1) {
        t.cancel();
        setState(() => _resendCooldown = 0);
      } else {
        setState(() => _resendCooldown--);
      }
    });
  }

  // Actions

  Future<void> _submit() async {
    if (!_isCodeComplete || _isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    try {
      await widget.args.onVerify(_currentCode);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      // Shake and clear the boxes on error
      _clearBoxes();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resend() async {
    if (_resendCooldown > 0 || _isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      await widget.args.onResend();
      if (!mounted) return;
      _clearBoxes();
      _startResendCooldown();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to resend code. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearBoxes() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  //   Build

  @override
  Widget build(BuildContext context) {
    final m = widget.metrics;
    final maskedEmail = _maskEmail(widget.args.email);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //   Header
        AuthCardHeader(
          title: 'Enter OTP code',
          subtitle: 'We sent a 6-digit code to\n$maskedEmail',
          isCompact: m.isCompact,
        ),
        SizedBox(height: m.sectionGap),

        //   OTP boxes
        _OtpBoxRow(
          controllers: _controllers,
          focusNodes: _focusNodes,
          hasError: _hasError,
          onComplete: _submit,
          onChanged: _clearError,
        ),

        //    Error text
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: _hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.spacingXs),
                  child: Text(
                    _errorMessage.isNotEmpty
                        ? _errorMessage
                        : 'Invalid code. Please try again.',
                    textAlign: TextAlign.center,
                    style: AppTypography.labelSmall(color: AppColors.error500),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        SizedBox(height: m.sectionGap),

        //    Verify button
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            text: 'Verify',
            isLoading: _isLoading,
            onPressed: _isCodeComplete ? _submit : null,
            leading: SvgPicture.asset(
              'assets/icons/join_icon.svg',
              colorFilter: const ColorFilter.mode(
                ButtonColors.primaryText,
                BlendMode.srcIn,
              ),
            ),
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacingSm),
          ),
        ),

        SizedBox(height: m.sectionGap),

        //    Resend row
        _ResendRow(
          cooldown: _resendCooldown,
          isLoading: _isLoading,
          onResend: _resend,
        ),
      ],
    );
  }
}

// _OtpBoxRow — 6 individual digit input boxes

class _OtpBoxRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool hasError;
  final VoidCallback onComplete;
  final VoidCallback onChanged;

  const _OtpBoxRow({
    required this.controllers,
    required this.focusNodes,
    required this.hasError,
    required this.onComplete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        controllers.length,
        (i) => _OtpBox(
          controller: controllers[i],
          focusNode: focusNodes[i],
          hasError: hasError,
          onInput: (value) => _onInput(context, i, value),
          onBackspace: () => _onBackspace(i),
        ),
      ),
    );
  }

  void _onInput(BuildContext context, int index, String value) {
    onChanged();
    if (value.isNotEmpty) {
      if (index < controllers.length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
        onComplete();
      }
    }
  }

  void _onBackspace(int index) {
    if (index > 0 && controllers[index].text.isEmpty) {
      controllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
    }
  }
}

// _OtpBox — single digit square

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final void Function(String) onInput;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onInput,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark
        ? DarkModeColors.surfaceSecondary
        : LightModeColors.surfaceApp;
    final defaultBorder = isDark
        ? DarkModeColors.borderDefault
        : LightModeColors.borderDefault;

    return SizedBox(
      width: 44,
      height: 52,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspace();
          }
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: AppTypography.h3(
            color: isDark
                ? DarkModeColors.textPrimary
                : LightModeColors.textPrimary,
          ),
          onChanged: (v) {
            // Handle paste: take only the last char if somehow > 1
            if (v.length > 1) {
              final last = v[v.length - 1];
              controller.value = controller.value.copyWith(
                text: last,
                selection: TextSelection.collapsed(offset: last.length),
              );
              onInput(last);
            } else {
              onInput(v);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              borderSide: BorderSide(
                color: hasError ? AppColors.error500 : defaultBorder,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              borderSide: BorderSide(
                color: hasError
                    ? AppColors.error500
                    : (isDark
                          ? DarkModeColors.borderFocused
                          : LightModeColors.borderFocused),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              borderSide: const BorderSide(
                color: AppColors.error500,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              borderSide: const BorderSide(color: AppColors.error500, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

// _ResendRow — "Didn't receive the code? Resend" + countdown

class _ResendRow extends StatelessWidget {
  final int cooldown;
  final bool isLoading;
  final VoidCallback onResend;

  const _ResendRow({
    required this.cooldown,
    required this.isLoading,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canResend = cooldown == 0 && !isLoading;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.spacingXs,
      children: [
        Text(
          "Didn't receive the code?",
          style: AppTypography.labelSmall(color: cs.onSurface),
        ),
        if (cooldown > 0)
          Text(
            'Resend in ${cooldown}s',
            style: AppTypography.labelSmall(color: cs.onSurfaceVariant),
          )
        else
          TextButton(
            onPressed: canResend ? onResend : null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(54, 24),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Resend',
              style: AppTypography.labelSmall(
                color: canResend ? ButtonColors.ghostText : cs.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

// Utility

/// Masks an email: `ma9060139@gmail.com` → `ma***39@gmail.com`
String _maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;
  final local = parts[0];
  final domain = parts[1];
  if (local.length <= 4) return email;
  final visible =
      '${local.substring(0, 2)}***${local.substring(local.length - 2)}';
  return '$visible@$domain';
}

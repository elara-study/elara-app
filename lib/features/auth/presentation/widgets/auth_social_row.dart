import 'package:elara/features/auth/presentation/widgets/auth_social_button.dart';
import 'package:flutter/material.dart';

/// Google + Facebook social auth buttons.
class AuthSocialRow extends StatelessWidget {
  final double gap;
  final bool shouldStack;
  final VoidCallback onTap;

  const AuthSocialRow({
    super.key,
    required this.gap,
    required this.shouldStack,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final google = AuthSocialButton(
      label: 'Google',
      svgAsset: 'assets/icons/google.svg',
      onTap: onTap,
    );
    final facebook = AuthSocialButton(
      label: 'Facebook',
      svgAsset: 'assets/icons/facebook_icon.svg',
      onTap: onTap,
    );

    if (shouldStack) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          google,
          SizedBox(height: gap),
          facebook,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: google),
        SizedBox(width: gap),
        Expanded(child: facebook),
      ],
    );
  }
}

import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ProfileSignedOutBody extends StatelessWidget {
  const ProfileSignedOutBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign in to view your profile',
            style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: Text(
              'Login',
              style: AppTypography.button(color: cs.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

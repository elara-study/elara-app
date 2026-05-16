import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ComingSoonTab extends StatelessWidget {
  final String title;

  const ComingSoonTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing2xl),
        child: Text(
          '$title coming soon',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

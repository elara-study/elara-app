import 'package:flutter/material.dart';

/// Title + “N% completed” for the roadmap list.
class RoadmapLearningPathHeader extends StatelessWidget {
  final double completedFraction;

  const RoadmapLearningPathHeader({super.key, required this.completedFraction});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percent = (completedFraction * 100).round().clamp(0, 100);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Path',
          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Text(
          '$percent% completed',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

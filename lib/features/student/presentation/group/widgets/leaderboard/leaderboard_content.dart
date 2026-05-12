import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/domain/group/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/presentation/group/widgets/leaderboard/leaderboard_row.dart';
import 'package:flutter/material.dart';

class LeaderboardContent extends StatelessWidget {
  final List<GroupLeaderboardEntry> entries;

  const LeaderboardContent({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      children: [
        for (final entry in entries) ...[
          LeaderboardRow(entry: entry),
          const SizedBox(height: AppSpacing.spacingMd),
        ],
      ],
    );
  }
}

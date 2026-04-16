import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/presentation/cubits/student_group_cubit.dart';
import 'package:elara/features/student/group/presentation/widgets/leaderboard/leaderboard_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentGroupCubit, StudentGroupState>(
      builder: (context, state) {
        switch (state.status) {
          case StudentGroupStatus.initial:
          case StudentGroupStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case StudentGroupStatus.failure:
            return _Failure(message: state.message ?? 'Something went wrong');
          case StudentGroupStatus.loaded:
            return LeaderboardContent(entries: state.leaderboard);
        }
      },
    );
  }
}

class _Failure extends StatelessWidget {
  final String message;

  const _Failure({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing2xl),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

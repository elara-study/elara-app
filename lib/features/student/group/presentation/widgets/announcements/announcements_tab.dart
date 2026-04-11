import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/presentation/cubits/announcements_cubit.dart';
import 'package:elara/features/student/group/presentation/widgets/announcements/announcement_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tab body: list of announcements from [AnnouncementsCubit].
class AnnouncementsTab extends StatelessWidget {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
      builder: (context, state) {
        switch (state.status) {
          case AnnouncementsLoadStatus.initial:
          case AnnouncementsLoadStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case AnnouncementsLoadStatus.failure:
            return _Failure(message: state.message ?? 'Something went wrong');
          case AnnouncementsLoadStatus.loaded:
            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spacing2xl),
                  child: Text(
                    'No announcements yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacingLg,
                AppSpacing.spacingSm,
                AppSpacing.spacingLg,
                AppSpacing.spacingLg,
              ),
              itemCount: state.items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.spacingLg),
              itemBuilder: (context, index) {
                return AnnouncementCard(announcement: state.items[index]);
              },
            );
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

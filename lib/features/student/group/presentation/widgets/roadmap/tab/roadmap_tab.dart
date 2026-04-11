import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/presentation/cubits/roadmap_cubit.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/content/roadmap_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoadmapTab extends StatelessWidget {
  const RoadmapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapCubit, RoadmapState>(
      builder: (context, state) {
        switch (state.status) {
          case RoadmapLoadStatus.initial:
          case RoadmapLoadStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case RoadmapLoadStatus.failure:
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spacing2xl),
                child: Text(
                  state.message ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          case RoadmapLoadStatus.loaded:
            final r = state.roadmap;
            if (r == null) {
              return const SizedBox.shrink();
            }
            return RoadmapContent(roadmap: r);
        }
      },
    );
  }
}

import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_roadmap_cubit.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_roadmap_tab.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Standalone roadmap detail screen matching the Figma learning-path layout.
class TeacherRoadmapDetailScreen extends StatelessWidget {
  final TeacherGroupEntity roadmap;

  const TeacherRoadmapDetailScreen({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppGlassHeader(
        title: roadmap.name,
        subtitle: '${roadmap.subject} • Grade ${roadmap.grade}',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.spacingLg.w),
            child: PopupMenuButton<String>(
              icon: SvgPicture.asset(
                'assets/icons/settings_icon.svg',
                height: AppIconSizes.iconSm.h,
                width: AppIconSizes.iconSm.w,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete Roadmap',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<TeacherRoadmapDetailCubit, TeacherRoadmapState>(
        builder: (context, state) {
          return switch (state.status) {
            TeacherRoadmapLoadStatus.initial ||
            TeacherRoadmapLoadStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            TeacherRoadmapLoadStatus.failure => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spacing2xl),
                child: Text(
                  state.message ?? 'Something went wrong',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TeacherRoadmapLoadStatus.loaded => TeacherRoadmapContent(
              roadmap: state.roadmap!,
              groupId: roadmap.id,
              subject: roadmap.subject,
            ),
          };
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Roadmap'),
        content: const Text(
          'Are you sure you want to delete this roadmap? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: dispatch delete roadmap when API is available
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

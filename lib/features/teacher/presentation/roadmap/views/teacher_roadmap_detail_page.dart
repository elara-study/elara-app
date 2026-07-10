import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_roadmap_details_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/delete_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_roadmap_cubit.dart';
import 'package:elara/features/teacher/presentation/roadmap/views/teacher_roadmap_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Route wrapper for the standalone teacher roadmap detail screen.
class TeacherRoadmapDetailPage extends StatelessWidget {
  final TeacherGroupEntity roadmap;

  const TeacherRoadmapDetailPage({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = TeacherRoadmapDetailCubit(
          getIt<GetTeacherRoadmapDetailsUseCase>(),
          roadmap.id,
          deleteRoadmap: getIt<DeleteTeacherRoadmapUseCase>(),
        );
        cubit.loadRoadmap();
        return cubit;
      },
      child: TeacherRoadmapDetailScreen(roadmap: roadmap),
    );
  }
}

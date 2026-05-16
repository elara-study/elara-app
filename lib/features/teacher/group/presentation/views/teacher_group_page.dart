import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_announcements_usecase.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_roadmap_usecase.dart';
import 'package:elara/features/student/group/presentation/cubits/announcements_cubit.dart';
import 'package:elara/features/student/group/presentation/cubits/roadmap_cubit.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/presentation/cubits/teacher_group_cubit.dart';
import 'package:elara/features/teacher/group/presentation/views/teacher_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Entry point: injects Cubits then renders [TeacherGroupScreen].
class TeacherGroupPage extends StatelessWidget {
  final TeacherGroupEntity group;

  const TeacherGroupPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = TeacherGroupCubit(getIt<TeacherGroupDataSource>());
            cubit.loadGroup(group.id);
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = RoadmapCubit(
              getIt<GetGroupRoadmapUseCase>(),
              group.id,
            );
            cubit.loadRoadmap();
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = AnnouncementsCubit(
              getIt<GetGroupAnnouncementsUseCase>(),
              group.id,
            );
            cubit.loadAnnouncements();
            return cubit;
          },
        ),
      ],
      child: TeacherGroupScreen(group: group),
    );
  }
}

import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_announcements_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/add_teacher_announcement_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/delete_teacher_announcement_usecase.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_roadmap_cubit.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_announcements_cubit.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_group_cubit.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherGroupPage extends StatelessWidget {
  final TeacherGroupEntity group;

  const TeacherGroupPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<TeacherGroupCubit>();
            cubit.loadGroup(group.id);
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = TeacherRoadmapCubit(
              getIt<GetTeacherRoadmapUseCase>(),
              group.id,
            );
            cubit.loadRoadmap();
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = TeacherAnnouncementsCubit(
              getAnnouncements: getIt<GetTeacherAnnouncementsUseCase>(),
              addAnnouncement: getIt<AddTeacherAnnouncementUseCase>(),
              deleteAnnouncement: getIt<DeleteTeacherAnnouncementUseCase>(),
              groupId: group.id,
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

import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_announcements_usecase.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_roadmap_usecase.dart';
import 'package:elara/features/student/group/presentation/cubits/announcements_cubit.dart';
import 'package:elara/features/student/group/presentation/cubits/roadmap_cubit.dart';
import 'package:elara/features/student/group/presentation/cubits/student_group_cubit.dart';
import 'package:elara/features/student/group/presentation/views/student_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentGroupPage extends StatelessWidget {
  final String groupId;

  const StudentGroupPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = getIt<StudentGroupCubit>();
            cubit.loadGroup(groupId: groupId);
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = RoadmapCubit(
              getIt<GetGroupRoadmapUseCase>(),
              groupId,
            );
            cubit.loadRoadmap();
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = AnnouncementsCubit(
              getIt<GetGroupAnnouncementsUseCase>(),
              groupId,
            );
            cubit.loadAnnouncements();
            return cubit;
          },
        ),
      ],
      child: const StudentGroupScreen(),
    );
  }
}

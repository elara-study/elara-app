import 'package:elara/features/teacher/domain/dashboard/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/dashboard/entities/teacher_profile_entity.dart';

class TeacherDashboardEntity {
  final TeacherProfileEntity profile;
  final List<TeacherGroupEntity> groups;
  final List<TeacherGroupEntity> roadmaps;
  final List<TeacherActivityEntity> recentActivity;

  const TeacherDashboardEntity({
    required this.profile,
    required this.groups,
    required this.roadmaps,
    required this.recentActivity,
  });
}

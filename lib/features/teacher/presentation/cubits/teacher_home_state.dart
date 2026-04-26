import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';

sealed class TeacherHomeState {
  const TeacherHomeState();
}

final class TeacherHomeInitial extends TeacherHomeState {
  const TeacherHomeInitial();
}

final class TeacherHomeLoading extends TeacherHomeState {
  const TeacherHomeLoading();
}

final class TeacherHomeLoaded extends TeacherHomeState {
  final TeacherProfileEntity profile;
  final List<TeacherGroupEntity> groups;
  final List<TeacherActivityEntity> recentActivity;

  const TeacherHomeLoaded({
    required this.profile,
    required this.groups,
    required this.recentActivity,
  });
}

final class TeacherHomeError extends TeacherHomeState {
  final String message;
  const TeacherHomeError(this.message);
}

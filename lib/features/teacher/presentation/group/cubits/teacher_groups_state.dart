import 'package:equatable/equatable.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';

sealed class TeacherGroupsState extends Equatable {
  const TeacherGroupsState();

  @override
  List<Object?> get props => [];
}

final class TeacherGroupsInitial extends TeacherGroupsState {
  const TeacherGroupsInitial();
}

final class TeacherGroupsLoading extends TeacherGroupsState {
  const TeacherGroupsLoading();
}

final class TeacherGroupsLoaded extends TeacherGroupsState {
  final List<TeacherGroupEntity> groups;

  const TeacherGroupsLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

final class TeacherGroupsError extends TeacherGroupsState {
  final String message;

  const TeacherGroupsError({required this.message});

  @override
  List<Object?> get props => [message];
}

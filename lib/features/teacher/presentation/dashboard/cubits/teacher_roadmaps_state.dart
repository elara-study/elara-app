import 'package:equatable/equatable.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';

sealed class TeacherRoadmapsState extends Equatable {
  const TeacherRoadmapsState();

  @override
  List<Object?> get props => [];
}

final class TeacherRoadmapsInitial extends TeacherRoadmapsState {
  const TeacherRoadmapsInitial();
}

final class TeacherRoadmapsLoading extends TeacherRoadmapsState {
  const TeacherRoadmapsLoading();
}

final class TeacherRoadmapsLoaded extends TeacherRoadmapsState {
  final List<TeacherGroupEntity> roadmaps;

  const TeacherRoadmapsLoaded({required this.roadmaps});

  @override
  List<Object?> get props => [roadmaps];
}

final class TeacherRoadmapsError extends TeacherRoadmapsState {
  final String message;

  const TeacherRoadmapsError({required this.message});

  @override
  List<Object?> get props => [message];
}

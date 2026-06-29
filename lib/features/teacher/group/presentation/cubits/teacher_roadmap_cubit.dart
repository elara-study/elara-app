import 'package:elara/features/teacher/group/domain/usecases/get_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_roadmap_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TeacherRoadmapLoadStatus { initial, loading, loaded, failure }

class TeacherRoadmapState extends Equatable {
  final TeacherRoadmapLoadStatus status;
  final TeacherRoadmapEntity? roadmap;
  final String? message;

  const TeacherRoadmapState({
    required this.status,
    this.roadmap,
    this.message,
  });

  const TeacherRoadmapState.initial() : this(status: TeacherRoadmapLoadStatus.initial);
  const TeacherRoadmapState.loading() : this(status: TeacherRoadmapLoadStatus.loading);
  const TeacherRoadmapState.loaded(TeacherRoadmapEntity roadmap)
      : this(status: TeacherRoadmapLoadStatus.loaded, roadmap: roadmap);
  const TeacherRoadmapState.failure(String message)
      : this(status: TeacherRoadmapLoadStatus.failure, message: message);

  @override
  List<Object?> get props => [status, roadmap, message];
}

class TeacherRoadmapCubit extends Cubit<TeacherRoadmapState> {
  final GetTeacherRoadmapUseCase _getRoadmap;
  final String _groupId;

  TeacherRoadmapCubit(this._getRoadmap, this._groupId)
      : super(const TeacherRoadmapState.initial());

  Future<void> loadRoadmap() async {
    emit(const TeacherRoadmapState.loading());
    final result = await _getRoadmap(_groupId);
    result.fold(
      (failure) => emit(TeacherRoadmapState.failure(failure.message)),
      (roadmap) => emit(TeacherRoadmapState.loaded(roadmap)),
    );
  }
}

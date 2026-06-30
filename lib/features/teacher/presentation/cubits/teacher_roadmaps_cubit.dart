import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elara/features/teacher/domain/usecases/get_teacher_roadmaps_usecase.dart';
import 'package:elara/features/teacher/domain/usecases/create_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_roadmaps_state.dart';

class TeacherRoadmapsCubit extends Cubit<TeacherRoadmapsState> {
  final GetTeacherRoadmapsUseCase _getTeacherRoadmapsUseCase;
  final CreateTeacherRoadmapUseCase _createTeacherRoadmapUseCase;

  TeacherRoadmapsCubit(
    this._getTeacherRoadmapsUseCase,
    this._createTeacherRoadmapUseCase,
  ) : super(const TeacherRoadmapsInitial());

  Future<void> loadRoadmaps() async {
    emit(const TeacherRoadmapsLoading());
    final result = await _getTeacherRoadmapsUseCase();
    result.fold(
      (failure) => emit(TeacherRoadmapsError(message: failure.message)),
      (roadmaps) => emit(TeacherRoadmapsLoaded(roadmaps: roadmaps)),
    );
  }

  Future<void> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  }) async {
    emit(const TeacherRoadmapsLoading());
    final result = await _createTeacherRoadmapUseCase(
      title: title,
      subject: subject,
      grade: grade,
    );

    result.fold(
      (failure) => emit(TeacherRoadmapsError(message: failure.message)),
      (_) => loadRoadmaps(), // Reload roadmaps after creation
    );
  }
}

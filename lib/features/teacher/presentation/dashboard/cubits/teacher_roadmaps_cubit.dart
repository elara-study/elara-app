import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_roadmaps_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/create_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_roadmap_details_usecase.dart';
import 'package:elara/features/teacher/presentation/dashboard/cubits/teacher_roadmaps_state.dart';

class TeacherRoadmapsCubit extends Cubit<TeacherRoadmapsState> {
  final GetTeacherRoadmapsUseCase _getTeacherRoadmapsUseCase;
  final CreateTeacherRoadmapUseCase _createTeacherRoadmapUseCase;
  final GetTeacherRoadmapDetailsUseCase _getTeacherRoadmapDetailsUseCase;

  TeacherRoadmapsCubit(
    this._getTeacherRoadmapsUseCase,
    this._createTeacherRoadmapUseCase,
    this._getTeacherRoadmapDetailsUseCase,
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

  Future<void> loadRoadmapDetails(String roadmapId) async {
    // Just hitting the endpoint as requested for now.
    // Further UI state handling can be added here if needed.
    final result = await _getTeacherRoadmapDetailsUseCase(roadmapId);
    result.fold((failure) => null, (roadmap) => null);
  }
}

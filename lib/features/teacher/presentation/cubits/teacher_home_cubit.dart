import 'package:elara/features/teacher/domain/usecases/get_teacher_dashboard_usecase.dart';
import 'package:elara/features/teacher/domain/usecases/create_teacher_group_usecase.dart';
import 'package:elara/features/teacher/domain/usecases/create_teacher_roadmap_usecase.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherHomeCubit extends Cubit<TeacherHomeState> {
  final GetTeacherDashboardUseCase _getTeacherDashboard;
  final CreateTeacherGroupUseCase _createTeacherGroup;
  final CreateTeacherRoadmapUseCase _createTeacherRoadmap;

  TeacherHomeCubit({
    required GetTeacherDashboardUseCase getTeacherDashboard,
    required CreateTeacherGroupUseCase createTeacherGroup,
    required CreateTeacherRoadmapUseCase createTeacherRoadmap,
  })  : _getTeacherDashboard = getTeacherDashboard,
        _createTeacherGroup = createTeacherGroup,
        _createTeacherRoadmap = createTeacherRoadmap,
        super(const TeacherHomeInitial());

  Future<void> loadHome() async {
    emit(const TeacherHomeLoading());
    try {
      final result = await _getTeacherDashboard();

      result.fold(
        (failure) => emit(TeacherHomeError('Failed to load home: ${failure.message}')),
        (dashboard) => emit(
          TeacherHomeLoaded(
            profile: dashboard.profile,
            groups: dashboard.groups,
            roadmaps: dashboard.roadmaps,
            recentActivity: dashboard.recentActivity,
          ),
        ),
      );
    } catch (e) {
      emit(TeacherHomeError('Failed to load home: ${e.toString()}'));
    }
  }

  Future<void> createGroup({
    required String title,
    required String subject,
    required String grade,
    required String roadmapName,
  }) async {
    try {
      final result = await _createTeacherGroup(
        title: title,
        subject: subject,
        grade: grade,
        roadmapName: roadmapName,
      );
      
      result.fold(
        (failure) => emit(TeacherHomeError('Failed to create group: ${failure.message}')),
        (_) => loadHome(), // refresh the list
      );
    } catch (e) {
      emit(TeacherHomeError('Failed to create group: ${e.toString()}'));
    }
  }

  Future<void> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  }) async {
    try {
      final result = await _createTeacherRoadmap(
        title: title,
        subject: subject,
        grade: grade,
      );
      
      result.fold(
        (failure) => emit(TeacherHomeError('Failed to create roadmap: ${failure.message}')),
        (_) => loadHome(), // refresh the list
      );
    } catch (e) {
      emit(TeacherHomeError('Failed to create roadmap: ${e.toString()}'));
    }
  }
}

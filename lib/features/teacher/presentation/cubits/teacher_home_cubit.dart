import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherHomeCubit extends Cubit<TeacherHomeState> {
  final TeacherHomeRepository _repository;

  TeacherHomeCubit(this._repository) : super(const TeacherHomeInitial());

  Future<void> loadHome() async {
    emit(const TeacherHomeLoading());
    try {
      // All three calls run in parallel for faster load.
      final results = await Future.wait([
        _repository.getProfile(),
        _repository.getGroups(),
        _repository.getRecentActivity(),
      ]);

      // Simple extraction, assuming success. In a real app, handle Left (failures) appropriately.
      final profileResult = results[0] as dynamic;
      final groupsResult = results[1] as dynamic;
      final activityResult = results[2] as dynamic;

      if (profileResult.isLeft() || groupsResult.isLeft() || activityResult.isLeft()) {
        emit(const TeacherHomeError('Failed to load some dashboard data.'));
        return;
      }

      emit(
        TeacherHomeLoaded(
          profile: profileResult.fold((l) => throw Exception(), (r) => r),
          groups: groupsResult.fold((l) => throw Exception(), (r) => r),
          recentActivity: activityResult.fold((l) => throw Exception(), (r) => r),
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
  }) async {
    try {
      final result = await _repository.createGroup(
        title: title,
        subject: subject,
        grade: grade,
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
      final result = await _repository.createRoadmap(
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

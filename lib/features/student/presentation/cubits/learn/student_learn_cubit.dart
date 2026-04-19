import 'package:elara/features/student/domain/repositories/student_repository.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLearnCubit extends Cubit<StudentLearnState> {
  final StudentRepository _repository;

  StudentLearnCubit({required StudentRepository repository})
      : _repository = repository,
        super(const StudentLearnInitial());

  /// Fetches the student's enrolled groups for the Learn screen.
  Future<void> loadGroups() async {
    if (isClosed) return;
    emit(const StudentLearnLoading());
    try {
      final groups = await _repository.getGroups();
      if (isClosed) return;
      emit(StudentLearnLoaded(groups));
    } catch (e) {
      if (isClosed) return;
      emit(StudentLearnError(_extractMessage(e)));
    }
  }

  /// Submits a group join request with the teacher-provided [code].
  /// Emits [StudentLearnJoining] while in-flight, then reloads groups
  /// on success or emits [StudentLearnError] on failure.
  Future<void> joinGroup(String code) async {
    if (isClosed) return;
    emit(const StudentLearnJoining());
    try {
      await _repository.joinGroup(code);
      if (isClosed) return;
      emit(const StudentLearnJoinSuccess());
      // Refresh the groups list to include the newly joined group
      await loadGroups();
    } catch (e) {
      if (isClosed) return;
      emit(StudentLearnError(_extractMessage(e)));
    }
  }

  String _extractMessage(Object e) =>
      e.toString().replaceAll('Exception: ', '');
}

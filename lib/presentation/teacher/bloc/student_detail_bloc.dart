import 'package:elara/domain/repositories/student_performance_repository.dart';
import 'package:elara/presentation/teacher/bloc/student_detail_event.dart';
import 'package:elara/presentation/teacher/bloc/student_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  final StudentPerformanceRepository _repository;

  StudentDetailBloc(this._repository) : super(StudentDetailInitial()) {
    on<LoadStudentDetails>(_onLoadStudentDetails);
  }

  Future<void> _onLoadStudentDetails(
    LoadStudentDetails event,
    Emitter<StudentDetailState> emit,
  ) async {
    emit(StudentDetailLoading());
    try {
      final performance = await _repository.getStudentPerformance(event.studentId);
      if (performance != null) {
        emit(StudentDetailLoaded(performance));
      } else {
        emit(const StudentDetailError('Student not found'));
      }
    } catch (e) {
      emit(StudentDetailError(e.toString()));
    }
  }
}

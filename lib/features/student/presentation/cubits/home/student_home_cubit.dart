import 'package:elara/features/student/domain/repositories/student_repository.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  final StudentRepository _repository;

  StudentHomeCubit({required StudentRepository repository})
      : _repository = repository,
        super(const StudentHomeInitial());

  /// Loads all Home screen data in a single parallel fetch.
  Future<void> loadHome() async {
    emit(const StudentHomeLoading());
    try {
      // Fire all requests concurrently — no waterfall delays.
      final results = await Future.wait([
        _repository.getStudentProfile(),
        _repository.getContinueLearning(),
        _repository.getDailyGoals(),
        _repository.getGroups(),
      ]);

      emit(
        StudentHomeLoaded(
          profile: results[0] as dynamic,
          continuelearning: results[1] as dynamic,
          dailyGoals: results[2] as dynamic,
          groups: results[3] as dynamic,
        ),
      );
    } catch (e) {
      emit(StudentHomeError(_extractMessage(e)));
    }
  }

  String _extractMessage(Object e) =>
      e.toString().replaceAll('Exception: ', '');
}

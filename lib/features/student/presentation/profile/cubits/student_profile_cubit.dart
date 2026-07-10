import 'package:elara/core/error/failures.dart';
import 'package:elara/features/student/domain/profile/usecases/get_student_profile_overview_use_case.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Drives the student Profile tab from [GetStudentProfileOverviewUseCase].
@injectable
class StudentProfileCubit extends Cubit<StudentProfileState> {
  StudentProfileCubit(this._getOverview) : super(const StudentProfileInitial());

  final GetStudentProfileOverviewUseCase _getOverview;

  Future<void> loadProfile() async {
    emit(const StudentProfileLoading());
    try {
      final overview = await _getOverview();
      emit(StudentProfileLoaded(overview));
    } on Failure catch (f) {
      emit(StudentProfileError(f.message));
    } catch (e) {
      emit(StudentProfileError(_message(e)));
    }
  }

  String _message(Object e) {
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return e.toString();
  }
}

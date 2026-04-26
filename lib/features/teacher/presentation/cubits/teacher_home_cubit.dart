import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherHomeCubit extends Cubit<TeacherHomeState> {
  final TeacherHomeDataSource _dataSource;

  TeacherHomeCubit(this._dataSource) : super(const TeacherHomeInitial());

  Future<void> loadHome() async {
    emit(const TeacherHomeLoading());
    try {
      // All three calls run in parallel for faster load.
      final results = await Future.wait([
        _dataSource.getProfile(),
        _dataSource.getGroups(),
        _dataSource.getRecentActivity(),
      ]);

      emit(
        TeacherHomeLoaded(
          profile: results[0] as dynamic,
          groups: results[1] as dynamic,
          recentActivity: results[2] as dynamic,
        ),
      );
    } catch (e) {
      emit(TeacherHomeError('Failed to load home: ${e.toString()}'));
    }
  }
}

import 'package:elara/features/student/presentation/group/cubits/announcements_cubit.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAnnouncementsCubit extends Cubit<AnnouncementsState> {
  final TeacherGroupDataSource _dataSource;
  final String _groupId;

  TeacherAnnouncementsCubit(this._dataSource, this._groupId)
      : super(const AnnouncementsState.initial());

  Future<void> loadAnnouncements() async {
    emit(const AnnouncementsState.loading());
    try {
      final items = await _dataSource.getAnnouncements(_groupId);
      emit(AnnouncementsState.loaded(items));
    } catch (e) {
      emit(AnnouncementsState.failure(e.toString()));
    }
  }

  Future<void> addAnnouncement(String title, String body) async {
    // Optionally emit a loading state here if the UI is designed to handle it,
    // but the simplest is just to call the data source and reload.
    try {
      await _dataSource.addAnnouncement(_groupId, title, body);
      // Reload announcements after adding
      await loadAnnouncements();
    } catch (e) {
      emit(AnnouncementsState.failure(e.toString()));
    }
  }
}

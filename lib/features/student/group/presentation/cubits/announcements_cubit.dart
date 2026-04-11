import 'package:elara/features/student/group/domain/entities/group_announcement.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_announcements_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'announcements_state.dart';

/// Loads and exposes group announcements for the Announcements tab.
class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final GetGroupAnnouncementsUseCase _getAnnouncements;
  final String _groupId;

  AnnouncementsCubit(this._getAnnouncements, this._groupId)
    : super(const AnnouncementsState.initial());

  Future<void> loadAnnouncements() async {
    emit(const AnnouncementsState.loading());
    final result = await _getAnnouncements(groupId: _groupId);
    emit(
      result.fold(
        onSuccess: AnnouncementsState.loaded,
        onFailure: (f) => AnnouncementsState.failure(f.message),
      ),
    );
  }
}

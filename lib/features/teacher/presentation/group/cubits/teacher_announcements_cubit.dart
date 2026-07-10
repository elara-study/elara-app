import 'package:elara/features/teacher/domain/group/usecases/get_teacher_announcements_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/add_teacher_announcement_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/delete_teacher_announcement_usecase.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TeacherAnnouncementsState extends Equatable {
  const TeacherAnnouncementsState();

  @override
  List<Object?> get props => [];
}

class TeacherAnnouncementsInitial extends TeacherAnnouncementsState {
  const TeacherAnnouncementsInitial();
}

class TeacherAnnouncementsLoading extends TeacherAnnouncementsState {
  const TeacherAnnouncementsLoading();
}

class TeacherAnnouncementsLoaded extends TeacherAnnouncementsState {
  const TeacherAnnouncementsLoaded(this.announcements);

  final List<GroupAnnouncement> announcements;

  @override
  List<Object?> get props => [announcements];
}

class TeacherAnnouncementsError extends TeacherAnnouncementsState {
  const TeacherAnnouncementsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TeacherAnnouncementsCubit extends Cubit<TeacherAnnouncementsState> {
  final GetTeacherAnnouncementsUseCase _getAnnouncements;
  final AddTeacherAnnouncementUseCase _addAnnouncement;
  final DeleteTeacherAnnouncementUseCase _deleteAnnouncement;
  final String groupId;

  TeacherAnnouncementsCubit({
    required GetTeacherAnnouncementsUseCase getAnnouncements,
    required AddTeacherAnnouncementUseCase addAnnouncement,
    required DeleteTeacherAnnouncementUseCase deleteAnnouncement,
    required this.groupId,
  }) : _getAnnouncements = getAnnouncements,
       _addAnnouncement = addAnnouncement,
       _deleteAnnouncement = deleteAnnouncement,
       super(const TeacherAnnouncementsInitial());

  Future<void> loadAnnouncements() async {
    emit(const TeacherAnnouncementsLoading());
    final result = await _getAnnouncements(groupId);
    result.fold(
      (failure) => emit(TeacherAnnouncementsError(failure.message)),
      (announcements) => emit(TeacherAnnouncementsLoaded(announcements)),
    );
  }

  Future<void> addAnnouncement(String title, String content) async {
    final result = await _addAnnouncement(groupId, title, content);
    result.fold(
      (failure) {}, // Handle silently or via listener
      (_) => loadAnnouncements(), // Refresh the list
    );
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    final result = await _deleteAnnouncement(groupId, announcementId);
    result.fold(
      (failure) {}, // Handle silently
      (_) => loadAnnouncements(), // Refresh the list
    );
  }
}

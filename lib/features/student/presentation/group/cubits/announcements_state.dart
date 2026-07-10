part of 'announcements_cubit.dart';

enum AnnouncementsLoadStatus { initial, loading, loaded, failure }

class AnnouncementsState extends Equatable {
  final AnnouncementsLoadStatus status;
  final List<GroupAnnouncement> items;
  final String? message;

  const AnnouncementsState._({
    required this.status,
    this.items = const [],
    this.message,
  });

  const AnnouncementsState.initial()
    : this._(status: AnnouncementsLoadStatus.initial);

  const AnnouncementsState.loading()
    : this._(status: AnnouncementsLoadStatus.loading);

  const AnnouncementsState.loaded(List<GroupAnnouncement> items)
    : this._(status: AnnouncementsLoadStatus.loaded, items: items);

  const AnnouncementsState.failure(String message)
    : this._(status: AnnouncementsLoadStatus.failure, message: message);

  @override
  List<Object?> get props => [status, items, message];
}

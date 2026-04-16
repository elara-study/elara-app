import 'package:equatable/equatable.dart';

/// A course announcement shown in the student group feed.
class GroupAnnouncement extends Equatable {
  final String id;
  final String title;
  final String body;

  /// Pre-formatted relative time (e.g. "2 hours ago") from the API or mapper.
  final String relativeTimeLabel;

  const GroupAnnouncement({
    required this.id,
    required this.title,
    required this.body,
    required this.relativeTimeLabel,
  });

  @override
  List<Object> get props => [id, title, body, relativeTimeLabel];
}

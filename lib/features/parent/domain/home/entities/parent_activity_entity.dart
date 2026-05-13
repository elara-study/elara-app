import 'package:equatable/equatable.dart';

/// Recent activity feed item (lesson, homework, etc.).
class ParentActivityEntity extends Equatable {
  const ParentActivityEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String timeLabel;

  @override
  List<Object?> get props => [id, title, subtitle, timeLabel];
}

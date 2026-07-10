import 'package:equatable/equatable.dart';

/// Group + course summary for the student Learn header and progress card.
class StudentGroupOverview extends Equatable {
  final String? groupId;
  final String courseTitle;
  final String courseSubtitle;
  final int completedLessons;
  final int totalLessons;

  const StudentGroupOverview({
    this.groupId,
    required this.courseTitle,
    required this.courseSubtitle,
    required this.completedLessons,
    required this.totalLessons,
  });

  @override
  List<Object?> get props => [
    groupId,
    courseTitle,
    courseSubtitle,
    completedLessons,
    totalLessons,
  ];
}

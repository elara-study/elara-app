import 'package:equatable/equatable.dart';

/// Group + course summary for the student Learn header and progress card.
class StudentGroupOverview extends Equatable {
  final String courseTitle;
  final String courseSubtitle;
  final int completedLessons;
  final int totalLessons;

  const StudentGroupOverview({
    required this.courseTitle,
    required this.courseSubtitle,
    required this.completedLessons,
    required this.totalLessons,
  });

  @override
  List<Object?> get props => [
    courseTitle,
    courseSubtitle,
    completedLessons,
    totalLessons,
  ];
}

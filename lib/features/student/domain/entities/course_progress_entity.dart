import 'package:equatable/equatable.dart';

/// Represents the student's "Continue where you left off" card
/// shown on the Home screen.
class CourseProgressEntity extends Equatable {
  /// The course / subject name (e.g. "Algebra Basics")
  final String courseName;

  /// Human-readable lesson label (e.g. "Lesson 5 of 8")
  final String lessonLabel;

  /// Current lesson index (1-based, e.g. 5)
  final int currentLesson;

  /// Total number of lessons in the course
  final int totalLessons;

  /// Overall completion percentage (0.0 – 1.0)
  final double progressPercent;

  /// Optional: deep-link to jump directly into the lesson
  final String? lessonId;

  const CourseProgressEntity({
    required this.courseName,
    required this.lessonLabel,
    required this.currentLesson,
    required this.totalLessons,
    required this.progressPercent,
    this.lessonId,
  });

  @override
  List<Object?> get props => [
        courseName,
        lessonLabel,
        currentLesson,
        totalLessons,
        progressPercent,
        lessonId,
      ];
}

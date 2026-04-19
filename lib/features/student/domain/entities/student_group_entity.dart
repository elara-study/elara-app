import 'package:equatable/equatable.dart';

/// Represents a class group the student is enrolled in.
/// Used on both the Home screen (compact list) and the Learn screen (full card).
class StudentGroupEntity extends Equatable {
  /// Server-side group identifier
  final String id;

  /// Display name of the group (e.g. "Mathematics 7A")
  final String name;

  /// Subject label shown as a tag (e.g. "MATHEMATICS", "SCIENCE")
  final String subject;

  /// Grade label shown alongside the subject tag (e.g. "Grade 7")
  final String grade;

  /// Teacher's display name (e.g. "Ms. Dalia")
  final String teacherName;

  /// Total number of enrolled students
  final int studentCount;

  /// Total number of lessons in this group's course
  final int totalLessons;

  /// Completed lessons count
  final int completedLessons;

  /// Student's progress percentage in this group (0.0 – 1.0)
  final double progressPercent;

  /// Colour key for the card — maps to AppColors (e.g. "blue", "orange", "green")
  /// Used to drive AppActionCard's primaryColor on the Home screen compact cards.
  final String colorKey;

  const StudentGroupEntity({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.teacherName,
    required this.studentCount,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercent,
    required this.colorKey,
  });

  /// Human-readable lesson progress label (e.g. "13/20 lessons")
  String get lessonProgressLabel => '$completedLessons/$totalLessons lessons';

  @override
  List<Object?> get props => [
        id,
        name,
        subject,
        grade,
        teacherName,
        studentCount,
        totalLessons,
        completedLessons,
        progressPercent,
        colorKey,
      ];
}

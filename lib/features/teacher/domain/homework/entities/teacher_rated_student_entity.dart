import 'package:equatable/equatable.dart';

/// A student whose submissions have been graded and scored.
class TeacherRatedStudentEntity extends Equatable {
  final String id;
  final String studentName;
  final String? avatarUrl;

  /// Total XP awarded to the student.
  final int totalXp;

  /// Maximum possible XP for this assignment.
  final int maxXp;

  const TeacherRatedStudentEntity({
    required this.id,
    required this.studentName,
    this.avatarUrl,
    required this.totalXp,
    required this.maxXp,
  });

  @override
  List<Object?> get props => [id, studentName, avatarUrl, totalXp, maxXp];
}

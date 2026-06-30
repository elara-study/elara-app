import 'package:elara/features/teacher/group/domain/entities/teacher_student_entity.dart';
import 'package:equatable/equatable.dart';

/// Overview stats shown in the Students tab header.
class TeacherGroupDetailEntity extends Equatable {
  final String name;
  final String subject;
  final int grade;
  final String joinCode;

  final int studentCount;

  /// 0..1 — average completion percentage across all students.
  final double avgCompletion;

  /// How many students are present today (for the attendance row).
  final int presentToday;

  final List<TeacherStudentEntity> students;

  const TeacherGroupDetailEntity({
    required this.name,
    required this.subject,
    required this.grade,
    required this.joinCode,
    required this.studentCount,
    required this.avgCompletion,
    required this.presentToday,
    required this.students,
  });

  /// "23 / 28" style label.
  String get attendanceLabel => '$presentToday / $studentCount';

  /// "87%" style label.
  String get avgCompletionLabel => '${(avgCompletion * 100).round()}%';

  @override
  List<Object?> get props => [
        name,
        subject,
        grade,
        joinCode,
        studentCount,
        avgCompletion,
        presentToday,
        students,
      ];
}

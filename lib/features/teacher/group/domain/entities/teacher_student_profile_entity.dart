import 'package:elara/features/student/domain/profile/entities/profile_linked_parent_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';
import 'package:equatable/equatable.dart';

/// Full student snapshot for the teacher group profile screen (Figma 1417:7049).
class TeacherStudentProfileEntity extends Equatable {
  const TeacherStudentProfileEntity({
    required this.student,
    required this.handle,
    required this.gradeLabel,
    required this.level,
    required this.nextLevel,
    required this.xpCurrent,
    required this.xpGoal,
    required this.streakDays,
    required this.attendancePercent,
    required this.parents,
    this.insight,
  });

  final TeacherStudentEntity student;
  final String handle;
  final String gradeLabel;
  final int level;
  final int nextLevel;
  final int xpCurrent;
  final int xpGoal;
  final int streakDays;
  final int attendancePercent;
  final List<ProfileLinkedParentEntity> parents;
  final TeacherStudentInsightEntity? insight;

  int get xpToNextLevel => (xpGoal - xpCurrent).clamp(0, xpGoal);

  String get lessonsStatLabel =>
      '${student.completedLessons}/${student.totalLessons}';

  String get attendanceLabel => '$attendancePercent%';

  @override
  List<Object?> get props => [
    student,
    handle,
    gradeLabel,
    level,
    nextLevel,
    xpCurrent,
    xpGoal,
    streakDays,
    attendancePercent,
    parents,
    insight,
  ];
}

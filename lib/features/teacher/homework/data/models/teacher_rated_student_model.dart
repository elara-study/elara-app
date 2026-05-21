import 'package:elara/features/teacher/homework/domain/entities/teacher_rated_student_entity.dart';

class TeacherRatedStudentModel extends TeacherRatedStudentEntity {
  const TeacherRatedStudentModel({
    required super.id,
    required super.studentName,
    super.avatarUrl,
    required super.totalXp,
    required super.maxXp,
  });
}

import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';

class TeacherHomeworkModel extends TeacherHomeworkEntity {
  const TeacherHomeworkModel({
    required super.moduleId,
    required super.moduleTitle,
    required super.moduleLabel,
    required super.groupId,
    required super.subject,
    required super.totalXp,
    required super.problems,
    required super.submissions,
    required super.ratedStudents,
  });
}

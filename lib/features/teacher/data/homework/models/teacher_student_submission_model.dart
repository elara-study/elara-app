import 'package:elara/features/teacher/domain/homework/entities/teacher_student_submission_entity.dart';

class TeacherStudentSubmissionModel extends TeacherStudentSubmissionEntity {
  const TeacherStudentSubmissionModel({
    required super.id,
    required super.studentName,
    super.avatarUrl,
    required super.submittedCount,
    required super.totalProblems,
    required super.answers,
  });
}

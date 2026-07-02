import 'package:elara/features/teacher/domain/homework/entities/teacher_student_answer_entity.dart';

class TeacherStudentAnswerModel extends TeacherStudentAnswerEntity {
  const TeacherStudentAnswerModel({
    required super.answerNumber,
    required super.questionText,
    super.answerText,
    super.imageUrl,
    super.score,
    required super.maxScore,
  });
}

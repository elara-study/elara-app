import 'package:elara/features/teacher/homework/domain/entities/teacher_homework_problem_entity.dart';

class TeacherHomeworkProblemModel extends TeacherHomeworkProblemEntity {
  const TeacherHomeworkProblemModel({
    required super.id,
    required super.problemNumber,
    required super.questionText,
    super.sampleAnswerText,
    super.hasImageSubmission,
  });
}

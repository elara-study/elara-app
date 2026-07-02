import 'package:elara/features/student/data/quiz/models/quiz_question_model.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';

/// JSON model for the quiz session returned by POST /api/v1/quiz/generate.
class QuizSessionModel {
  const QuizSessionModel({
    required this.sessionId,
    required this.title,
    required this.totalQuestions,
    required this.moduleName,
    required this.subjectName,
    required this.questions,
  });

  final int sessionId;
  final String title;
  final int totalQuestions;
  final String moduleName;
  final String subjectName;
  final List<QuizQuestionModel> questions;

  factory QuizSessionModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'] as List<dynamic>? ?? [];
    return QuizSessionModel(
      sessionId: json['sessionId'] as int,
      title: json['title'] as String,
      totalQuestions: json['totalQuestions'] as int,
      moduleName: json['moduleName'] as String,
      subjectName: json['subjectName'] as String,
      questions: rawQuestions
          .map((q) => QuizQuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  QuizSession toEntity() {
    return QuizSession(
      id: sessionId.toString(),
      title: title,
      // subjectName maps to the subtitle shown under the title in the app bar.
      subtitle: subjectName,
      // moduleName maps to the module label shown above the progress bar.
      moduleLabel: moduleName,
      questions: questions.map((q) => q.toEntity()).toList(),
      progressTotal: totalQuestions,
    );
  }
}

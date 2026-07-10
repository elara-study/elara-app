import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/answer_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_hint.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';

/// Quiz data + submission — [MockQuizRepository] handles legacy demo flow;
/// [QuizRepositoryImpl] handles the live API.
abstract class QuizRepository {
  // ── Legacy (mock-compatible) ───────────────────────────────────────────────

  Future<ApiResult<QuizSession>> getSession({
    required String quizId,
    String? groupId,
    String? moduleId,
  });

  Future<ApiResult<QuizResults>> submitAnswers({
    required String quizId,
    required List<QuizAnswerSubmission> answers,
  });

  // ── Live API ───────────────────────────────────────────────────────────────

  Future<ApiResult<QuizSession>> generateQuiz({
    required String groupId,
    required String moduleId,
    required int questionCount,
    required String difficultyLevel,
    required List<String> questionTypes,
  });

  Future<ApiResult<QuizHint>> getHint({
    required int sessionId,
    required int questionNumber,
  });

  Future<ApiResult<AnswerResult>> submitAnswer({
    required int sessionId,
    required int questionNumber,
    required String questionType,
    String? selectedOptionText,
    String? answerContent,
    required bool hintUsed,
  });

  Future<ApiResult<QuizResults>> completeQuiz(int sessionId);
}


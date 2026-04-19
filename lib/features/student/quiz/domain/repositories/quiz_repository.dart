import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_results.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_session.dart';

/// Quiz data + submission — swap [MockQuizRepository] for a Dio-backed impl later.
abstract class QuizRepository {
  Future<ApiResult<QuizSession>> getSession({
    required String quizId,
    String? groupId,
    String? moduleId,
  });

  Future<ApiResult<QuizResults>> submitAnswers({
    required String quizId,
    required List<QuizAnswerSubmission> answers,
  });
}

import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/data/quiz/datasources/quiz_remote_datasource.dart';
import 'package:elara/features/student/domain/quiz/entities/answer_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_hint.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

/// Live API implementation of [QuizRepository].
///
/// Catches [ServerException] from the data source and wraps it in
/// [ServerFailure] so the cubit only sees [ApiResult].
class QuizRepositoryImpl implements QuizRepository {
  QuizRepositoryImpl(this._dataSource);

  final QuizRemoteDataSource _dataSource;

  @override
  Future<ApiResult<QuizSession>> generateQuiz({
    required String groupId,
    required String moduleId,
    required int questionCount,
    required String difficultyLevel,
    required List<String> questionTypes,
  }) async {
    try {
      final session = await _dataSource.generateQuiz(
        groupId: groupId,
        moduleId: moduleId,
        questionCount: questionCount,
        difficultyLevel: difficultyLevel,
        questionTypes: questionTypes,
      );
      return ApiResult.success(session);
    } on ServerException catch (e) {
      return ApiResult.failure(ServerFailure(e.message));
    }
  }

  @override
  Future<ApiResult<QuizHint>> getHint({
    required int sessionId,
    required int questionNumber,
  }) async {
    try {
      final hint = await _dataSource.getHint(
        sessionId: sessionId,
        questionNumber: questionNumber,
      );
      return ApiResult.success(hint);
    } on ServerException catch (e) {
      return ApiResult.failure(ServerFailure(e.message));
    }
  }

  @override
  Future<ApiResult<AnswerResult>> submitAnswer({
    required int sessionId,
    required int questionNumber,
    required String questionType,
    String? selectedOptionText,
    String? answerContent,
    required bool hintUsed,
  }) async {
    try {
      final result = await _dataSource.submitAnswer(
        sessionId: sessionId,
        questionNumber: questionNumber,
        questionType: questionType,
        selectedOptionText: selectedOptionText,
        answerContent: answerContent,
        hintUsed: hintUsed,
      );
      return ApiResult.success(result);
    } on ServerException catch (e) {
      return ApiResult.failure(ServerFailure(e.message));
    }
  }

  @override
  Future<ApiResult<QuizResults>> completeQuiz(int sessionId) async {
    try {
      final results = await _dataSource.completeQuiz(sessionId);
      return ApiResult.success(results);
    } on ServerException catch (e) {
      return ApiResult.failure(ServerFailure(e.message));
    }
  }

  // ── Legacy stubs (not called in live flow but satisfy the contract) ────────

  @override
  Future<ApiResult<QuizSession>> getSession({
    required String quizId,
    String? groupId,
    String? moduleId,
  }) async {
    return ApiResult.failure(
      const ServerFailure('getSession is not supported in the live repository'),
    );
  }

  @override
  Future<ApiResult<QuizResults>> submitAnswers({
    required String quizId,
    required List<QuizAnswerSubmission> answers,
  }) async {
    return ApiResult.failure(
      const ServerFailure(
        'submitAnswers is not supported in the live repository',
      ),
    );
  }
}

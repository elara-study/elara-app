import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/data/quiz/models/answer_result_model.dart';
import 'package:elara/features/student/data/quiz/models/quiz_hint_model.dart';
import 'package:elara/features/student/data/quiz/models/quiz_result_model.dart';
import 'package:elara/features/student/data/quiz/models/quiz_session_model.dart';
import 'package:elara/features/student/domain/quiz/entities/answer_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_hint.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';

/// Calls the live quiz API endpoints. Uses the shared [DioClient] — never
/// instantiates [Dio] directly.
class QuizRemoteDataSource {
  QuizRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  /// POST /api/v1/quiz/generate
  Future<QuizSession> generateQuiz({
    required String groupId,
    required String moduleId,
    required int questionCount,
    required String difficultyLevel,
    required List<String> questionTypes,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.generateQuiz,
        data: {
          'groupId': groupId,
          'moduleId': moduleId,
          'questionCount': questionCount,
          'difficultyLevel': difficultyLevel,
          'questionTypes': questionTypes,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QuizSessionModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to generate quiz',
      );
    }
  }

  /// GET /api/v1/quiz/sessions/:sessionId/questions/:questionNumber/hint
  Future<QuizHint> getHint({
    required int sessionId,
    required int questionNumber,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.quizHint(sessionId, questionNumber),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QuizHintModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to fetch hint',
      );
    }
  }

  /// POST /api/v1/quiz/sessions/:sessionId/answers
  Future<AnswerResult> submitAnswer({
    required int sessionId,
    required int questionNumber,
    required String questionType,
    String? selectedOptionText,
    String? answerContent,
    required bool hintUsed,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.submitAnswer(sessionId),
        data: {
          'questionNumber': questionNumber,
          'questionType': questionType,
          'selectedOptionText': selectedOptionText,
          'answerContent': answerContent,
          'hintUsed': hintUsed,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return AnswerResultModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to submit answer',
      );
    }
  }

  /// POST /api/v1/quiz/sessions/:sessionId/complete
  Future<QuizResults> completeQuiz(int sessionId) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.completeQuiz(sessionId),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return QuizResultModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to complete quiz',
      );
    }
  }
}

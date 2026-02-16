import 'package:dio/dio.dart';
import 'package:elara/data/models/api_models.dart';

class QuizApiService {
  final Dio _dio;

  QuizApiService(this._dio);

  Future<QuizApiModel> generateQuiz({
    required int classId,
    required String topic,
    required int questionsCount,
    required String questionType,
    String? evaluationCriteria,
  }) async {
    try {
      final response = await _dio.post(
        '/api/classes/$classId/quizzes',
        data: {
          'topic': topic,
          'questionsCount': questionsCount,
          'questionType': questionType,
          if (evaluationCriteria != null) 'evaluationCriteria': evaluationCriteria,
        },
      );
      return QuizApiModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to generate quiz: ${e.toString()}');
    }
  }

  Future<List<QuizApiModel>> getQuizzes(int classId) async {
    try {
      final response = await _dio.get('/api/classes/$classId/quizzes');
      final List<dynamic> data = response.data;
      return data.map((json) => QuizApiModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch quizzes: ${e.toString()}');
    }
  }

  Future<List<QuizApiModel>> getStudentQuizzes(int classId) async {
    try {
      final response = await _dio.get('/api/students/classes/$classId/quizzes');
      final List<dynamic> data = response.data;
      return data.map((json) => QuizApiModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch student quizzes: ${e.toString()}');
    }
  }

  Future<void> submitQuiz({
    required int classId,
    required int quizId,
    required Map<String, dynamic> answers,
  }) async {
    try {
      await _dio.post(
        '/api/students/classes/$classId/quizzes/submit',
        data: {
          'quizId': quizId,
          'answers': answers,
        },
      );
    } catch (e) {
      throw Exception('Failed to submit quiz: ${e.toString()}');
    }
  }
}

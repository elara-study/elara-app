import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elara/domain/models/essay_submission.dart';
import 'package:elara/domain/models/question.dart';
import 'package:elara/domain/models/quiz.dart';
import 'package:elara/domain/models/rubric.dart';
import 'package:flutter/foundation.dart';

class AiService {
  final Dio _dio;
  final String _apiKey =
      'YOUR_OPENAI_API_KEY'; // TODO: Move to .env or secure storage

  AiService({Dio? dio}) : _dio = dio ?? Dio();

  /// Generates a quiz based on the provided parameters.
  Future<Quiz> generateQuiz({
    required String topic,
    required int count,
    required String difficulty,
    required String type,
  }) async {
    // TODO: Implement actual API call to OpenAI/Claude
    // For now, we return a mock response to demonstrate the UI flow.
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    try {
      // Mock generation logic
      final List<Question> questions = List.generate(count, (index) {
        return Question(
          id:
              DateTime.now().millisecondsSinceEpoch.toString() +
              index.toString(),
          type: type == 'Written only'
              ? QuestionType.written
              : QuestionType.mcq,
          text: 'Generated Question ${index + 1} about $topic ($difficulty)',
          options: type == 'Written only'
              ? null
              : ['Option A', 'Option B', 'Option C', 'Option D'],
          correctOptionIndex: 0,
          gradingCriteria: type == 'Written only'
              ? 'Standard criteria for $topic'
              : null,
        );
      });

      return Quiz(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '$topic Quiz',
        subject: topic,
        topic: topic,
        numberOfQuestions: count,
        questionType: type,
        difficulty: difficulty,
        questions: questions,
        createdAt: DateTime.now(),
        classId: 'class_1',
        dueDate: DateTime.now().add(const Duration(days: 7)),
      );
    } catch (e) {
      debugPrint('Error generating quiz: $e');
      throw Exception('Failed to generate quiz');
    }
  }

  // Placeholder for essay grading
  Future<GradingResult> gradeEssay(String essay, Rubric rubric) async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate analysis

    // Mock grading result based on rubric or random
    // In real app, we send rubric criteria to LLM.

    final List<CriterionScore> scores = rubric.criteria.map((criterion) {
      // Mock score logic
      final score = (DateTime.now().millisecond % 4) + 1;
      return CriterionScore(
        criterionId: criterion.id,
        criterionTitle: criterion.title,
        score: score,
        feedback: 'Good attempt at ${criterion.title}, but needs more depth.',
        quote: essay.length > 20 ? essay.substring(0, 20) + '...' : essay,
      );
    }).toList();

    double totalScore = 0;
    for (var s in scores) {
      // Find weight
      final weight = rubric.criteria
          .firstWhere((c) => c.id == s.criterionId)
          .weight;
      totalScore += (s.score / 4) * weight;
    }

    return GradingResult(
      totalScore: totalScore,
      overallFeedback: 'Overall a solid essay. See detailed breakdown below.',
      criterionScores: scores,
    );
  }
}

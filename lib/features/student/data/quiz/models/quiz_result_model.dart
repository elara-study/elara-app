import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';

/// JSON model for the quiz completion response from POST /api/v1/quiz/sessions/:id/complete.
///
/// The API returns nested objects (`results` + `studentProgress`) which are
/// flattened into the existing [QuizResults] entity.
class QuizResultModel {
  const QuizResultModel({
    required this.sessionId,
    required this.completedAt,
    required this.quizTitle,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.unansweredCount,
    required this.totalQuestions,
    required this.accuracyPercentage,
    required this.xpEarned,
    required this.totalXP,
    required this.level,
    required this.currentStreak,
    required this.elaraInsight,
  });

  final int sessionId;
  final String completedAt;
  final String quizTitle;
  final int correctAnswers;
  final int wrongAnswers;
  final int unansweredCount;
  final int totalQuestions;
  final double accuracyPercentage;
  final int xpEarned;
  final int totalXP;
  final int level;
  final int currentStreak;
  final String elaraInsight;

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as Map<String, dynamic>;
    final progress = json['studentProgress'] as Map<String, dynamic>;

    return QuizResultModel(
      sessionId: json['sessionId'] as int,
      completedAt: json['completedAt'] as String? ?? '',
      quizTitle: json['quizTitle'] as String? ?? '',
      correctAnswers: results['correctAnswers'] as int? ?? 0,
      wrongAnswers: results['wrongAnswers'] as int? ?? 0,
      unansweredCount: results['unansweredCount'] as int? ?? 0,
      totalQuestions: results['totalQuestions'] as int? ?? 0,
      accuracyPercentage:
          (results['accuracyPercentage'] as num?)?.toDouble() ?? 0.0,
      xpEarned: results['xpEarned'] as int? ?? 0,
      totalXP: progress['totalXP'] as int? ?? 0,
      level: progress['level'] as int? ?? 1,
      currentStreak: progress['currentStreak'] as int? ?? 0,
      elaraInsight: json['elaraInsight'] as String? ?? '',
    );
  }

  QuizResults toEntity() {
    return QuizResults(
      scorePercent: accuracyPercentage.round(),
      correctCount: correctAnswers,
      totalCount: totalQuestions,
      unansweredCount: unansweredCount,
      wrongCount: wrongAnswers,
      xpEarned: xpEarned,
      totalScoreXp: totalXP,
      level: level,
      // levelProgress is not returned by the API — default to 0.
      levelProgress: 0,
      streakDays: currentStreak,
      insightMessage: elaraInsight.isNotEmpty ? elaraInsight : null,
    );
  }
}

import 'package:equatable/equatable.dart';

class StudentPerformance extends Equatable {
  final String studentId;
  final String studentName;
  final String email;
  final String? avatarUrl;
  final double overallGrade;
  final int totalQuizzes;
  final int totalEssays;
  final double averageQuizScore;
  final double averageEssayScore;
  final List<QuizAttempt> quizAttempts;
  final List<EssayAttempt> essayAttempts;
  final List<PerformanceMetric> strengths;
  final List<PerformanceMetric> weaknesses;
  final List<ActivityLogEntry> activityLog;

  const StudentPerformance({
    required this.studentId,
    required this.studentName,
    required this.email,
    this.avatarUrl,
    required this.overallGrade,
    required this.totalQuizzes,
    required this.totalEssays,
    required this.averageQuizScore,
    required this.averageEssayScore,
    required this.quizAttempts,
    required this.essayAttempts,
    required this.strengths,
    required this.weaknesses,
    required this.activityLog,
  });

  @override
  List<Object?> get props => [
        studentId,
        studentName,
        email,
        avatarUrl,
        overallGrade,
        totalQuizzes,
        totalEssays,
        averageQuizScore,
        averageEssayScore,
        quizAttempts,
        essayAttempts,
        strengths,
        weaknesses,
        activityLog,
      ];
}

class QuizAttempt extends Equatable {
  final String id;
  final String quizTitle;
  final double score;
  final double maxScore;
  final DateTime submittedAt;
  final int timeSpentMinutes;
  final List<QuestionResult> questionResults;

  const QuizAttempt({
    required this.id,
    required this.quizTitle,
    required this.score,
    required this.maxScore,
    required this.submittedAt,
    required this.timeSpentMinutes,
    required this.questionResults,
  });

  double get percentage => (score / maxScore) * 100;

  @override
  List<Object?> get props => [
        id,
        quizTitle,
        score,
        maxScore,
        submittedAt,
        timeSpentMinutes,
        questionResults,
      ];
}

class QuestionResult extends Equatable {
  final String questionText;
  final bool isCorrect;
  final String? studentAnswer;
  final String? correctAnswer;

  const QuestionResult({
    required this.questionText,
    required this.isCorrect,
    this.studentAnswer,
    this.correctAnswer,
  });

  @override
  List<Object?> get props => [questionText, isCorrect, studentAnswer, correctAnswer];
}

class EssayAttempt extends Equatable {
  final String id;
  final String essayTitle;
  final double score;
  final double maxScore;
  final DateTime submittedAt;
  final String rubricName;
  final List<CriterionScore> criteriaScores;
  final String? feedback;

  const EssayAttempt({
    required this.id,
    required this.essayTitle,
    required this.score,
    required this.maxScore,
    required this.submittedAt,
    required this.rubricName,
    required this.criteriaScores,
    this.feedback,
  });

  double get percentage => (score / maxScore) * 100;

  @override
  List<Object?> get props => [
        id,
        essayTitle,
        score,
        maxScore,
        submittedAt,
        rubricName,
        criteriaScores,
        feedback,
      ];
}

class CriterionScore extends Equatable {
  final String criterionName;
  final double score;
  final double maxScore;
  final String feedback;

  const CriterionScore({
    required this.criterionName,
    required this.score,
    required this.maxScore,
    required this.feedback,
  });

  @override
  List<Object?> get props => [criterionName, score, maxScore, feedback];
}

class PerformanceMetric extends Equatable {
  final String criterionName;
  final double averageScore;
  final String description;

  const PerformanceMetric({
    required this.criterionName,
    required this.averageScore,
    required this.description,
  });

  @override
  List<Object?> get props => [criterionName, averageScore, description];
}

class ActivityLogEntry extends Equatable {
  final String id;
  final String title;
  final String type; // 'quiz' or 'essay'
  final DateTime timestamp;
  final String status; // 'submitted', 'graded', 'pending'

  const ActivityLogEntry({
    required this.id,
    required this.title,
    required this.type,
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [id, title, type, timestamp, status];
}

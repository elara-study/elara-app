import 'package:elara/domain/models/rubric.dart';
import 'package:equatable/equatable.dart';

class EssaySubmission extends Equatable {
  final String id;
  final String studentName;
  final String content;
  final DateTime submissionDate;
  final GradingResult? result;

  const EssaySubmission({
    required this.id,
    required this.studentName,
    required this.content,
    required this.submissionDate,
    this.result,
  });

  @override
  List<Object?> get props => [id, studentName, content, submissionDate, result];
}

class GradingResult extends Equatable {
  final double totalScore;
  final String overallFeedback;
  final List<CriterionScore> criterionScores;

  const GradingResult({
    required this.totalScore,
    required this.overallFeedback,
    required this.criterionScores,
  });

  @override
  List<Object?> get props => [totalScore, overallFeedback, criterionScores];
}

class CriterionScore extends Equatable {
  final String criterionId;
  final String criterionTitle;
  final int score; // 1-4
  final String feedback;
  final String? quote; // Evidence from text

  const CriterionScore({
    required this.criterionId,
    required this.criterionTitle,
    required this.score,
    required this.feedback,
    this.quote,
  });

  @override
  List<Object?> get props => [
    criterionId,
    criterionTitle,
    score,
    feedback,
    quote,
  ];
}

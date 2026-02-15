import 'package:equatable/equatable.dart';

class GradingResult extends Equatable {
  const GradingResult({
    required this.questionId,
    required this.score,
    this.feedback,
    this.identifiedGaps = const [],
  });

  final String questionId;
  final double score;
  final String? feedback;
  final List<String> identifiedGaps;

  @override
  List<Object?> get props => [questionId, score, feedback, identifiedGaps];
}

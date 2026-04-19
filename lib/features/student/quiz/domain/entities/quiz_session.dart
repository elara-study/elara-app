import 'package:elara/features/student/quiz/domain/entities/quiz_question.dart';
import 'package:equatable/equatable.dart';

/// Loaded quiz definition for one attempt.
class QuizSession extends Equatable {
  const QuizSession({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.moduleLabel,
    required this.questions,
    this.progressTotal,
  });

  final String id;
  final String title;
  final String subtitle;
  final String moduleLabel;
  final List<QuizQuestion> questions;

  /// When the API tracks a larger quiz (e.g. 20) but returns one page of questions.
  final int? progressTotal;

  int get effectiveTotal => progressTotal ?? questions.length;

  @override
  List<Object?> get props => [id, title, subtitle, moduleLabel, questions, progressTotal];
}

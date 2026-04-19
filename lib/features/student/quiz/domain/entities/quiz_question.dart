import 'package:elara/features/student/quiz/domain/entities/quiz_option.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_question_kind.dart';
import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.id,
    required this.kind,
    required this.prompt,
    this.options = const [],
    this.pointsLabel = '+10',
    this.hintMessage,
  });

  final String id;
  final QuizQuestionKind kind;
  final String prompt;
  final List<QuizOption> options;
  final String pointsLabel;
  final String? hintMessage;

  @override
  List<Object?> get props => [id, kind, prompt, options, pointsLabel, hintMessage];
}

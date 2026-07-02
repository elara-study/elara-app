import 'package:equatable/equatable.dart';

/// Hint response for a single quiz question.
class QuizHint extends Equatable {
  const QuizHint({required this.content, required this.hintLevel});

  final String content;
  final int hintLevel;

  @override
  List<Object?> get props => [content, hintLevel];
}

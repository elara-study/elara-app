import 'package:equatable/equatable.dart';

enum QuestionType { mcq, written }

class Question extends Equatable {
  const Question({
    required this.id,
    required this.type,
    required this.text,
    this.options,
    this.correctOptionIndex,
    this.gradingCriteria,
  });

  final String id;
  final QuestionType type;
  final String text;
  final List<String>? options;
  final int? correctOptionIndex;
  final String? gradingCriteria;

  @override
  List<Object?> get props => [id, type, text, options, correctOptionIndex, gradingCriteria];
}

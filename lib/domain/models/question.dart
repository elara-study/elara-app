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

  Question copyWith({
    String? id,
    QuestionType? type,
    String? text,
    List<String>? options,
    int? correctOptionIndex,
    String? gradingCriteria,
  }) {
    return Question(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      gradingCriteria: gradingCriteria ?? this.gradingCriteria,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'gradingCriteria': gradingCriteria,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      type: QuestionType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
          orElse: () => QuestionType.mcq),
      text: json['text'],
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      correctOptionIndex: json['correctOptionIndex'],
      gradingCriteria: json['gradingCriteria'],
    );
  }

  @override
  List<Object?> get props =>
      [id, type, text, options, correctOptionIndex, gradingCriteria];
}

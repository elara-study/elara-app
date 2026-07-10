import 'package:elara/features/student/domain/quiz/entities/quiz_option.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_question.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_question_kind.dart';

/// JSON model for a single quiz question returned by the generate endpoint.
class QuizQuestionModel {
  const QuizQuestionModel({
    required this.questionNumber,
    required this.text,
    required this.questionType,
    required this.hint,
    required this.options,
  });

  final int questionNumber;
  final String text;
  final String questionType;
  /// The hint string returned by the backend (may be empty if not provided).
  final String? hint;
  final List<String> options;

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    // Backend returns 'hint' as a plain string, not a boolean 'hasHint'.
    final hintRaw = json['hint'];
    final hintStr = hintRaw is String && hintRaw.isNotEmpty ? hintRaw : null;
    return QuizQuestionModel(
      questionNumber: json['questionNumber'] as int,
      text: json['text'] as String,
      questionType: json['questionType'] as String,
      hint: hintStr,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  QuizQuestion toEntity() {
    return QuizQuestion(
      id: 'q$questionNumber',
      kind: questionType == 'MCQ'
          ? QuizQuestionKind.mcq
          : QuizQuestionKind.written,
      prompt: text,
      // Convert plain-string options to QuizOption with stable index-based IDs.
      options: options
          .asMap()
          .entries
          .map((e) => QuizOption(id: 'opt_${e.key}', label: e.value))
          .toList(),
      // hint comes from the generate response; lazy fetching via getHint is skipped.
      hintMessage: hint,
    );
  }
}

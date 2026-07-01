import 'package:equatable/equatable.dart';

/// A single problem in the teacher's module homework assignment.
class TeacherHomeworkProblemEntity extends Equatable {
  final String id;
  final int problemNumber;
  final String questionText;

  /// A sample text answer submitted by a student — null if no text submission yet.
  final String? sampleAnswerText;

  /// True when at least one student submitted an image answer for this problem.
  final bool hasImageSubmission;

  const TeacherHomeworkProblemEntity({
    required this.id,
    required this.problemNumber,
    required this.questionText,
    this.sampleAnswerText,
    this.hasImageSubmission = false,
  });

  @override
  List<Object?> get props => [
    id,
    problemNumber,
    questionText,
    sampleAnswerText,
    hasImageSubmission,
  ];
}

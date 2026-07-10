import 'package:equatable/equatable.dart';

/// A single answer submitted by a student for one homework problem.
class TeacherStudentAnswerEntity extends Equatable {
  final int answerNumber;
  final String questionText;

  /// Text answer typed by the student (null if submitted as image only).
  final String? answerText;

  /// URL / path to a handwritten photo submitted by the student.
  final String? imageUrl;

  /// Score awarded by the teacher (null if not yet graded).
  final int? score;

  /// Maximum possible score for this problem.
  final int maxScore;

  const TeacherStudentAnswerEntity({
    required this.answerNumber,
    required this.questionText,
    this.answerText,
    this.imageUrl,
    this.score,
    required this.maxScore,
  });

  bool get isGraded => score != null;

  @override
  List<Object?> get props => [
    answerNumber,
    questionText,
    answerText,
    imageUrl,
    score,
    maxScore,
  ];
}

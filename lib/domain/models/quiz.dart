import 'package:elara/domain/models/question.dart';
import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  const Quiz({
    required this.id,
    required this.classId,
    required this.title,
    required this.questions,
    this.dueDate,
  });

  final String id;
  final String classId;
  final String title;
  final List<Question> questions;
  final DateTime? dueDate;

  @override
  List<Object?> get props => [id, classId, title, questions, dueDate];
}

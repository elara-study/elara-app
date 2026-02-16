import 'package:elara/domain/models/question.dart';
import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  final String id;
  final String title;
  final String subject;
  final String topic;
  final int numberOfQuestions;
  final String questionType; // MCQ, Writen, Mixed
  final String difficulty; // Easy, Medium, Hard
  final List<Question> questions;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String? classId;

  const Quiz({
    required this.id,
    required this.title,
    required this.subject,
    required this.topic,
    required this.numberOfQuestions,
    required this.questionType,
    required this.difficulty,
    required this.questions,
    required this.createdAt,
    this.dueDate,
    this.classId,
  });

  Quiz copyWith({
    String? id,
    String? title,
    String? subject,
    String? topic,
    int? numberOfQuestions,
    String? questionType,
    String? difficulty,
    List<Question>? questions,
    DateTime? createdAt,
    DateTime? dueDate,
    String? classId,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      questionType: questionType ?? this.questionType,
      difficulty: difficulty ?? this.difficulty,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      classId: classId ?? this.classId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'topic': topic,
      'numberOfQuestions': numberOfQuestions,
      'questionType': questionType,
      'difficulty': difficulty,
      'questions': questions.map((x) => x.toJson()).toList(), // Assuming Question has toJson
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'classId': classId,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      subject: json['subject'] ?? '',
      topic: json['topic'] ?? '',
      numberOfQuestions: json['numberOfQuestions'] ?? 0,
      questionType: json['questionType'] ?? 'Mixed',
      difficulty: json['difficulty'] ?? 'Medium',
      questions: List<Question>.from(
          json['questions']?.map((x) => Question.fromJson(x)) ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      classId: json['classId'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subject,
        topic,
        numberOfQuestions,
        questionType,
        difficulty,
        questions,
        createdAt,
        dueDate,
        classId,
      ];
}

import 'package:equatable/equatable.dart';

class ClassModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String joinCode;
  final int teacherId;
  final String teacherName;
  final DateTime createdAt;

  const ClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.joinCode,
    required this.teacherId,
    required this.teacherName,
    required this.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      joinCode: json['joinCode'],
      teacherId: json['teacherId'],
      teacherName: json['teacherName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'joinCode': joinCode,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, description, joinCode, teacherId, teacherName, createdAt];
}

class QuizApiModel extends Equatable {
  final int id;
  final String quizTitle;
  final int type;
  final List<QuestionApiModel> questions;

  const QuizApiModel({
    required this.id,
    required this.quizTitle,
    required this.type,
    required this.questions,
  });

  factory QuizApiModel.fromJson(Map<String, dynamic> json) {
    return QuizApiModel(
      id: json['id'],
      quizTitle: json['quizTitle'],
      type: json['type'],
      questions: (json['questions'] as List)
          .map((q) => QuestionApiModel.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizTitle': quizTitle,
      'type': type,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, quizTitle, type, questions];
}

class QuestionApiModel extends Equatable {
  final int id;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final List<String> gradingCriteria;
  final int maxScore;

  const QuestionApiModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.gradingCriteria,
    required this.maxScore,
  });

  factory QuestionApiModel.fromJson(Map<String, dynamic> json) {
    return QuestionApiModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      gradingCriteria: List<String>.from(json['gradingCriteria'] ?? []),
      maxScore: json['maxScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctAnswer': correctAnswer,
      'gradingCriteria': gradingCriteria,
      'maxScore': maxScore,
    };
  }

  @override
  List<Object?> get props => [id, text, options, correctAnswer, gradingCriteria, maxScore];
}

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final String? userId;
  final String? role;

  const LoginResponse({required this.token, this.userId, this.role});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userId: json['userId']?.toString(),
      role: json['role'],
    );
  }
}

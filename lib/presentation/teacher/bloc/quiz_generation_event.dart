part of 'quiz_generation_bloc.dart';

abstract class QuizGenerationEvent extends Equatable {
  const QuizGenerationEvent();

  @override
  List<Object> get props => [];
}

class GenerateQuizRequested extends QuizGenerationEvent {
  final String topic;
  final int count;
  final String difficulty;
  final String type;

  const GenerateQuizRequested({
    required this.topic,
    required this.count,
    required this.difficulty,
    required this.type,
  });

  @override
  List<Object> get props => [topic, count, difficulty, type];
}

part of 'quiz_generation_bloc.dart';

abstract class QuizGenerationState extends Equatable {
  const QuizGenerationState();
  
  @override
  List<Object> get props => [];
}

class QuizGenerationInitial extends QuizGenerationState {}

class QuizGenerationLoading extends QuizGenerationState {}

class QuizGenerationSuccess extends QuizGenerationState {
  final Quiz quiz;

  const QuizGenerationSuccess(this.quiz);

  @override
  List<Object> get props => [quiz];
}

class QuizGenerationFailure extends QuizGenerationState {
  final String error;

  const QuizGenerationFailure(this.error);

  @override
  List<Object> get props => [error];
}

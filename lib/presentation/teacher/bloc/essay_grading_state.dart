part of 'essay_grading_bloc.dart';

abstract class EssayGradingState extends Equatable {
  const EssayGradingState();
  
  @override
  List<Object> get props => [];
}

class EssayGradingInitial extends EssayGradingState {}

class EssayGradingLoading extends EssayGradingState {}

class EssayGradingSuccess extends EssayGradingState {
  final GradingResult result;

  const EssayGradingSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class EssayGradingFailure extends EssayGradingState {
  final String error;

  const EssayGradingFailure(this.error);

  @override
  List<Object> get props => [error];
}

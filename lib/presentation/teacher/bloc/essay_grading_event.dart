part of 'essay_grading_bloc.dart';

abstract class EssayGradingEvent extends Equatable {
  const EssayGradingEvent();

  @override
  List<Object> get props => [];
}

class GradeEssayRequested extends EssayGradingEvent {
  final String essayContent;
  final Rubric rubric;

  const GradeEssayRequested({required this.essayContent, required this.rubric});

  @override
  List<Object> get props => [essayContent, rubric];
}

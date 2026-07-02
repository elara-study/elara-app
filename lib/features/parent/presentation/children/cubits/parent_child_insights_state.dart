import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ParentChildInsightsState extends Equatable {
  const ParentChildInsightsState();

  @override
  List<Object?> get props => [];
}

class ParentChildInsightsInitial extends ParentChildInsightsState {}

class ParentChildInsightsLoading extends ParentChildInsightsState {}

class ParentChildInsightsLoaded extends ParentChildInsightsState {
  final List<TeacherStudentInsightEntity> insights;

  const ParentChildInsightsLoaded(this.insights);

  @override
  List<Object?> get props => [insights];
}

class ParentChildInsightsError extends ParentChildInsightsState {
  final String message;

  const ParentChildInsightsError(this.message);

  @override
  List<Object?> get props => [message];
}

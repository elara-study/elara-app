import 'package:elara/domain/models/student_performance.dart';
import 'package:equatable/equatable.dart';

abstract class StudentDetailState extends Equatable {
  const StudentDetailState();

  @override
  List<Object?> get props => [];
}

class StudentDetailInitial extends StudentDetailState {}

class StudentDetailLoading extends StudentDetailState {}

class StudentDetailLoaded extends StudentDetailState {
  final StudentPerformance performance;

  const StudentDetailLoaded(this.performance);

  @override
  List<Object?> get props => [performance];
}

class StudentDetailError extends StudentDetailState {
  final String message;

  const StudentDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

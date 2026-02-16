import 'package:equatable/equatable.dart';

abstract class StudentDetailEvent extends Equatable {
  const StudentDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadStudentDetails extends StudentDetailEvent {
  final String studentId;

  const LoadStudentDetails(this.studentId);

  @override
  List<Object> get props => [studentId];
}

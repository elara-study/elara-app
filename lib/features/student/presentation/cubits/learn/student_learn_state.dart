import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:equatable/equatable.dart';

abstract class StudentLearnState extends Equatable {
  const StudentLearnState();

  @override
  List<Object?> get props => [];
}

class StudentLearnInitial extends StudentLearnState {
  const StudentLearnInitial();
}

class StudentLearnLoading extends StudentLearnState {
  const StudentLearnLoading();
}

class StudentLearnLoaded extends StudentLearnState {
  final List<StudentGroupEntity> groups;

  const StudentLearnLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

/// Emitted while the joinGroup API call is in progress
class StudentLearnJoining extends StudentLearnState {
  const StudentLearnJoining();
}

/// Emitted after a successful joinGroup call
class StudentLearnJoinSuccess extends StudentLearnState {
  const StudentLearnJoinSuccess();
}

class StudentLearnError extends StudentLearnState {
  final String message;

  const StudentLearnError(this.message);

  @override
  List<Object?> get props => [message];
}

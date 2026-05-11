import 'package:elara/features/student/profile/domain/entities/student_profile_overview_entity.dart';
import 'package:equatable/equatable.dart';

sealed class StudentProfileState extends Equatable {
  const StudentProfileState();

  @override
  List<Object?> get props => [];
}

class StudentProfileInitial extends StudentProfileState {
  const StudentProfileInitial();
}

class StudentProfileLoading extends StudentProfileState {
  const StudentProfileLoading();
}

class StudentProfileLoaded extends StudentProfileState {
  const StudentProfileLoaded(this.overview);

  final StudentProfileOverviewEntity overview;

  @override
  List<Object?> get props => [overview];
}

class StudentProfileError extends StudentProfileState {
  const StudentProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ParentChildProfileState extends Equatable {
  const ParentChildProfileState();

  @override
  List<Object?> get props => [];
}

class ParentChildProfileInitial extends ParentChildProfileState {
  const ParentChildProfileInitial();
}

class ParentChildProfileLoading extends ParentChildProfileState {
  const ParentChildProfileLoading();
}

class ParentChildProfileLoaded extends ParentChildProfileState {
  const ParentChildProfileLoaded(this.profile);

  final ParentChildProfileEntity profile;

  @override
  List<Object?> get props => [profile];
}

class ParentChildProfileError extends ParentChildProfileState {
  const ParentChildProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

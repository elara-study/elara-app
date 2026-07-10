import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ParentChildHomeworkState extends Equatable {
  const ParentChildHomeworkState();

  @override
  List<Object?> get props => [];
}

class ParentChildHomeworkInitial extends ParentChildHomeworkState {
  const ParentChildHomeworkInitial();
}

class ParentChildHomeworkLoading extends ParentChildHomeworkState {
  const ParentChildHomeworkLoading();
}

class ParentChildHomeworkLoaded extends ParentChildHomeworkState {
  const ParentChildHomeworkLoaded({
    required this.homeworks,
    required this.totalCount,
    required this.submittedCount,
    required this.gradedCount,
  });

  final List<ParentHomeworkCardEntity> homeworks;
  final int totalCount;
  final int submittedCount;
  final int gradedCount;

  @override
  List<Object?> get props => [
    homeworks,
    totalCount,
    submittedCount,
    gradedCount,
  ];
}

class ParentChildHomeworkError extends ParentChildHomeworkState {
  const ParentChildHomeworkError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

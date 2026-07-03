import 'package:elara/features/parent/domain/home/entities/parent_children_dashboard_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ParentChildrenState extends Equatable {
  const ParentChildrenState();

  @override
  List<Object?> get props => [];
}

class ParentChildrenInitial extends ParentChildrenState {
  const ParentChildrenInitial();
}

class ParentChildrenLoading extends ParentChildrenState {
  const ParentChildrenLoading();
}

class ParentChildrenLoaded extends ParentChildrenState {
  const ParentChildrenLoaded(
    this.dashboard, {
    this.successMessage,
    this.errorMessage,
  });

  final ParentChildrenDashboardEntity dashboard;
  final String? successMessage;
  final String? errorMessage;

  ParentChildrenLoaded copyWith({
    ParentChildrenDashboardEntity? dashboard,
    String? successMessage,
    String? errorMessage,
  }) {
    return ParentChildrenLoaded(
      dashboard ?? this.dashboard,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [dashboard, successMessage, errorMessage];
}

class ParentChildrenError extends ParentChildrenState {
  const ParentChildrenError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

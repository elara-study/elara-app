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
  const ParentChildrenLoaded(this.dashboard);

  final ParentChildrenDashboardEntity dashboard;

  @override
  List<Object?> get props => [dashboard];
}

class ParentChildrenError extends ParentChildrenState {
  const ParentChildrenError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ParentHomeState extends Equatable {
  const ParentHomeState();

  @override
  List<Object?> get props => [];
}

class ParentHomeInitial extends ParentHomeState {
  const ParentHomeInitial();
}

class ParentHomeLoading extends ParentHomeState {
  const ParentHomeLoading();
}

class ParentHomeLoaded extends ParentHomeState {
  const ParentHomeLoaded(this.overview);

  final ParentHomeOverviewEntity overview;

  @override
  List<Object?> get props => [overview];
}

class ParentHomeError extends ParentHomeState {
  const ParentHomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

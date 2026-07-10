import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ParentReportsState extends Equatable {
  const ParentReportsState();

  @override
  List<Object?> get props => [];
}

class ParentReportsInitial extends ParentReportsState {
  const ParentReportsInitial();
}

class ParentReportsLoading extends ParentReportsState {
  const ParentReportsLoading();
}

class ParentReportsLoaded extends ParentReportsState {
  const ParentReportsLoaded(this.overview);

  final ParentReportsOverviewEntity overview;

  @override
  List<Object?> get props => [overview];
}

class ParentReportsError extends ParentReportsState {
  const ParentReportsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

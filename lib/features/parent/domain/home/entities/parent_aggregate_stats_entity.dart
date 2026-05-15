import 'package:equatable/equatable.dart';

/// Cross-child averages shown on the parent home screen.
class ParentAggregateStatsEntity extends Equatable {
  const ParentAggregateStatsEntity({
    required this.avgCompletionPercent,
    required this.avgAttendancePercent,
  });

  final int avgCompletionPercent;
  final int avgAttendancePercent;

  @override
  List<Object?> get props => [avgCompletionPercent, avgAttendancePercent];
}

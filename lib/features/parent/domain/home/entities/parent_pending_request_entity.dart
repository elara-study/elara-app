import 'package:equatable/equatable.dart';

/// Pending child-link request (Figma Pending Request Card).
class ParentPendingRequestEntity extends Equatable {
  const ParentPendingRequestEntity({
    required this.id,
    required this.displayName,
    required this.gradeLabel,
    required this.requestedTimeLabel,
  });

  final String id;
  final String displayName;
  final String gradeLabel;
  final String requestedTimeLabel;

  @override
  List<Object?> get props => [id, displayName, gradeLabel, requestedTimeLabel];
}

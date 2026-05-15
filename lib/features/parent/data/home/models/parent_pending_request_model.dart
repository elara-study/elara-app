import 'package:elara/features/parent/domain/home/entities/parent_pending_request_entity.dart';

class ParentPendingRequestModel {
  const ParentPendingRequestModel({
    required this.id,
    required this.displayName,
    required this.gradeLabel,
    required this.requestedTimeLabel,
  });

  final String id;
  final String displayName;
  final String gradeLabel;
  final String requestedTimeLabel;

  ParentPendingRequestEntity toEntity() => ParentPendingRequestEntity(
    id: id,
    displayName: displayName,
    gradeLabel: gradeLabel,
    requestedTimeLabel: requestedTimeLabel,
  );
}

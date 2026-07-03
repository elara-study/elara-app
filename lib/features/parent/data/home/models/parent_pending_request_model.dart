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

  factory ParentPendingRequestModel.fromJson(Map<String, dynamic> json) {
    return ParentPendingRequestModel(
      id: (json['id'] ?? json['requestId'] ?? json['request_id'] ?? json['linkRequestId'] ?? json['link_request_id'] ?? '').toString(),
      displayName: json['student_name'] as String? ?? json['displayName'] as String? ?? json['studentName'] as String? ?? json['childName'] as String? ?? json['name'] as String? ?? '',
      gradeLabel: json['grade'] as String? ?? json['gradeLabel'] as String? ?? json['grade_label'] as String? ?? '',
      requestedTimeLabel: json['requested_at'] as String? ?? json['requestedTimeLabel'] as String? ?? json['requestedAt'] as String? ?? '',
    );
  }

  ParentPendingRequestEntity toEntity() => ParentPendingRequestEntity(
    id: id,
    displayName: displayName,
    gradeLabel: gradeLabel,
    requestedTimeLabel: requestedTimeLabel,
  );
}

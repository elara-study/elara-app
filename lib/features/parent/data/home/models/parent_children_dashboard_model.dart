import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/data/home/models/parent_pending_request_model.dart';
import 'package:elara/features/parent/domain/home/entities/parent_children_dashboard_entity.dart';

class ParentChildrenDashboardModel {
  const ParentChildrenDashboardModel({
    required this.pendingRequests,
    required this.children,
  });

  final List<ParentPendingRequestModel> pendingRequests;
  final List<ParentChildProgressModel> children;

  factory ParentChildrenDashboardModel.fromJson(Map<String, dynamic> json) {
    final pendingRequestsList = json['pending_requests'] as List? ?? json['pendingRequests'] as List? ?? [];
    final childrenList = json['children'] as List? ?? [];

    return ParentChildrenDashboardModel(
      pendingRequests: pendingRequestsList
          .whereType<Map<String, dynamic>>()
          .map(ParentPendingRequestModel.fromJson)
          .toList(),
      children: childrenList
          .whereType<Map<String, dynamic>>()
          .map(ParentChildProgressModel.fromJson)
          .toList(),
    );
  }

  ParentChildrenDashboardEntity toEntity() => ParentChildrenDashboardEntity(
    pendingRequests: pendingRequests.map((e) => e.toEntity()).toList(),
    children: children.map((e) => e.toEntity()).toList(),
  );
}

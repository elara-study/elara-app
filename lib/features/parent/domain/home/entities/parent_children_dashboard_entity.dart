import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_pending_request_entity.dart';
import 'package:equatable/equatable.dart';

/// Children tab payload (Figma `205:2260`).
class ParentChildrenDashboardEntity extends Equatable {
  const ParentChildrenDashboardEntity({
    required this.pendingRequests,
    required this.children,
  });

  final List<ParentPendingRequestEntity> pendingRequests;
  final List<ParentChildProgressEntity> children;

  @override
  List<Object?> get props => [pendingRequests, children];
}

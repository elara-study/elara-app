part of 'roadmap_cubit.dart';

enum RoadmapLoadStatus { initial, loading, loaded, failure }

class RoadmapState extends Equatable {
  final RoadmapLoadStatus status;
  final GroupRoadmap? roadmap;
  final String? message;

  const RoadmapState._({required this.status, this.roadmap, this.message});

  const RoadmapState.initial() : this._(status: RoadmapLoadStatus.initial);

  const RoadmapState.loading() : this._(status: RoadmapLoadStatus.loading);

  const RoadmapState.loaded(GroupRoadmap roadmap)
    : this._(status: RoadmapLoadStatus.loaded, roadmap: roadmap);

  const RoadmapState.failure(String message)
    : this._(status: RoadmapLoadStatus.failure, message: message);

  @override
  List<Object?> get props => [status, roadmap, message];
}

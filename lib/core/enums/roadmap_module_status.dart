/// Row state for a module on the student group learning roadmap.
enum RoadmapModuleStatus {
  completed('Completed'),
  inProgress('In progress'),
  locked('Locked');

  const RoadmapModuleStatus(this.defaultDisplayLabel);

  /// Default chip copy when a module has no `statusLabelOverride`.
  final String defaultDisplayLabel;

  bool get isLocked => this == RoadmapModuleStatus.locked;

  bool get isInProgress => this == RoadmapModuleStatus.inProgress;
}

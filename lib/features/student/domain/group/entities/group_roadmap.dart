import 'package:elara/core/enums/roadmap_module_status.dart';
import 'package:equatable/equatable.dart';

export 'package:elara/core/enums/roadmap_module_status.dart';

/// One module / lesson on the group roadmap.
class GroupRoadmapModule extends Equatable {
  final String moduleLabel;
  final String title;
  final String description;
  final RoadmapModuleStatus status;

  /// When non-null, shown instead of the default label for [status].
  final String? statusLabelOverride;

  const GroupRoadmapModule({
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.status,
    this.statusLabelOverride,
  });

  @override
  List<Object?> get props => [
    moduleLabel,
    title,
    description,
    status,
    statusLabelOverride,
  ];
}

/// Roadmap payload for a group (modules + overall completion for the header).
class GroupRoadmap extends Equatable {
  final List<GroupRoadmapModule> modules;

  /// 0..1; used for “N% completed” in the learning path header.
  final double completedFraction;

  const GroupRoadmap({required this.modules, required this.completedFraction});

  /// Uses [completedFraction] when set; otherwise derives from [modules].
  factory GroupRoadmap.fromModules(
    List<GroupRoadmapModule> modules, {
    double? completedFraction,
  }) {
    double computed = 0;
    if (modules.isNotEmpty) {
      final done = modules
          .where((m) => m.status == RoadmapModuleStatus.completed)
          .length;
      computed = done / modules.length;
    }
    return GroupRoadmap(
      modules: modules,
      completedFraction: completedFraction ?? computed,
    );
  }

  @override
  List<Object?> get props => [modules, completedFraction];
}

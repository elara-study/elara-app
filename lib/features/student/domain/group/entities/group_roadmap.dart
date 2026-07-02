import 'package:elara/core/enums/roadmap_module_status.dart';
import 'package:equatable/equatable.dart';

export 'package:elara/core/enums/roadmap_module_status.dart';

/// One module / lesson on the group roadmap.
class GroupRoadmapModule extends Equatable {
  final String moduleLabel;
  final String title;
  final String description;
  final RoadmapModuleStatus status;

  /// UUID string returned by the backend (e.g. "7323677e-e1fc-...").
  /// Used as [moduleId] when generating a quiz.
  final String? moduleId;

  /// Legacy int id — kept for compatibility; prefer [moduleId].
  final int? lessonId;

  /// When non-null, shown instead of the default label for [status].
  final String? statusLabelOverride;

  const GroupRoadmapModule({
    required this.moduleLabel,
    required this.title,
    required this.description,
    required this.status,
    this.moduleId,
    this.lessonId,
    this.statusLabelOverride,
  });

  @override
  List<Object?> get props => [
    moduleLabel,
    title,
    description,
    status,
    moduleId,
    lessonId,
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

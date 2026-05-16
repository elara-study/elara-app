import 'package:elara/features/parent/data/home/models/parent_subject_group_progress_model.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';

/// DTO for a linked student row (API / mock).
class ParentChildProgressModel {
  const ParentChildProgressModel({
    required this.id,
    required this.displayName,
    required this.xpPoints,
    required this.streakDays,
    required this.currentLesson,
    required this.totalLessons,
    required this.progress,
    this.gradeLabel = '',
    this.level = 1,
    this.subjectGroups = const [],
  });

  final String id;
  final String displayName;
  final int xpPoints;
  final int streakDays;
  final int currentLesson;
  final int totalLessons;
  final double progress;
  final String gradeLabel;
  final int level;
  final List<ParentSubjectGroupProgressModel> subjectGroups;

  ParentChildProgressEntity toEntity() => ParentChildProgressEntity(
    id: id,
    displayName: displayName,
    xpPoints: xpPoints,
    streakDays: streakDays,
    currentLesson: currentLesson,
    totalLessons: totalLessons,
    progress: progress,
    gradeLabel: gradeLabel,
    level: level,
    subjectGroups: subjectGroups.map((e) => e.toEntity()).toList(),
  );
}

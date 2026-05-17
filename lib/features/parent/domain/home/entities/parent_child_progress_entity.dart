import 'package:elara/features/parent/domain/home/entities/parent_subject_group_progress_entity.dart';
import 'package:equatable/equatable.dart';

/// Linked student's progress snapshot for the parent home dashboard.
class ParentChildProgressEntity extends Equatable {
  const ParentChildProgressEntity({
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

  /// Inclusive overall progress in \[0, 1\].
  final double progress;

  /// e.g. `Grade 7` — empty on home-only previews.
  final String gradeLabel;

  /// Student level shown on Children Child Card.
  final int level;

  /// Subject rows under "SUBJECT GROUP PROGRESS".
  final List<ParentSubjectGroupProgressEntity> subjectGroups;

  int get progressPercentRounded => (progress * 100).clamp(0, 100).round();

  String get handle {
    final cleanName = displayName.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9_]'),
      '',
    );
    return '@$cleanName';
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    xpPoints,
    streakDays,
    currentLesson,
    totalLessons,
    progress,
    gradeLabel,
    level,
    subjectGroups,
  ];
}

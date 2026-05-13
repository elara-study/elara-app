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
  });

  final String id;
  final String displayName;
  final int xpPoints;
  final int streakDays;
  final int currentLesson;
  final int totalLessons;

  /// Inclusive overall progress in \[0, 1\].
  final double progress;

  int get progressPercentRounded => (progress * 100).clamp(0, 100).round();

  @override
  List<Object?> get props => [
    id,
    displayName,
    xpPoints,
    streakDays,
    currentLesson,
    totalLessons,
    progress,
  ];
}

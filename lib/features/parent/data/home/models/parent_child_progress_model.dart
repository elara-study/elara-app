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
    this.avatarUrl,
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
  final String? avatarUrl;

  factory ParentChildProgressModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    final progressMap = json['progress'] as Map<String, dynamic>?;

    final subjectProgressList = json['subject_progress'] as List? ?? json['subject_groups'] as List? ?? json['subjectGroups'] as List? ?? [];
    
    double avgProgress = 0.0;
    if (progressMap != null) {
      final completionPercentage = progressMap['completion_percentage'] as num? ?? 0;
      avgProgress = completionPercentage / 100.0;
    } else if (subjectProgressList.isNotEmpty) {
      double total = 0.0;
      for (final sp in subjectProgressList) {
        if (sp is Map<String, dynamic>) {
          total += (sp['progress_percentage'] as num? ?? sp['progress'] as num? ?? 0).toDouble();
        }
      }
      avgProgress = (total / subjectProgressList.length) / 100.0;
    }

    final lessonsCompleted = stats['lessons_completed'] as int? ?? 
                             progressMap?['current_lesson'] as int? ?? 
                             json['lessonsCompleted'] as int? ?? 0;

    final totalLessons = progressMap?['total_lessons'] as int? ?? lessonsCompleted;

    final xpPoints = stats['total_xp'] as int? ?? json['xpPoints'] as int? ?? json['xp_points'] as int? ?? 0;
    final streakDays = stats['day_streak'] as int? ?? json['streakDays'] as int? ?? json['streak_days'] as int? ?? 0;

    final gradeVal = json['grade'];
    final gradeLabel = gradeVal != null ? 'Grade $gradeVal' : (json['gradeLabel'] as String? ?? json['grade_label'] as String? ?? '');

    return ParentChildProgressModel(
      id: json['id'] as String? ?? '',
      displayName: json['name'] as String? ?? json['displayName'] as String? ?? '',
      xpPoints: xpPoints,
      streakDays: streakDays,
      currentLesson: lessonsCompleted,
      totalLessons: totalLessons,
      progress: avgProgress,
      gradeLabel: gradeLabel,
      level: json['level'] as int? ?? 1,
      subjectGroups: subjectProgressList
          .whereType<Map<String, dynamic>>()
          .map(ParentSubjectGroupProgressModel.fromJson)
          .toList(),
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
    );
  }

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
    avatarUrl: avatarUrl,
  );
}

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
    final progressMap = json['progress'] as Map<String, dynamic>?;
    final completionPercentage = progressMap?['completion_percentage'] as num? ?? 0;
    
    return ParentChildProgressModel(
      id: json['id'] as String? ?? '',
      displayName: json['name'] as String? ?? '',
      xpPoints: json['xp_points'] as int? ?? json['xpPoints'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? json['streakDays'] as int? ?? 0,
      currentLesson: progressMap?['current_lesson'] as int? ?? 0,
      totalLessons: progressMap?['total_lessons'] as int? ?? 0,
      progress: completionPercentage / 100.0,
      gradeLabel: json['grade_label'] as String? ?? json['gradeLabel'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      subjectGroups: json['subject_groups'] != null
          ? (json['subject_groups'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ParentSubjectGroupProgressModel.fromJson)
              .toList()
          : json['subjectGroups'] != null
              ? (json['subjectGroups'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map(ParentSubjectGroupProgressModel.fromJson)
                  .toList()
              : const [],
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

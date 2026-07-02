import 'package:elara/features/student/learn/domain/entities/student_learn_group.dart';

class StudentLearnGroupModel extends StudentLearnGroup {
  const StudentLearnGroupModel({
    required super.id,
    required super.name,
    required super.subject,
    required super.grade,
    required super.teacherName,
    required super.studentCount,
    required super.totalLessons,
    required super.completedLessons,
    required super.progressPercent,
    required super.colorKey,
  });

  factory StudentLearnGroupModel.fromJson(Map<String, dynamic> json) {
    final stats = _asMap(json['stats']);
    final lessons = _asMap(stats?['lessons']);
    final rawProgress = (json['progressPercentage'] as num?)?.toDouble() ?? 0;
    return StudentLearnGroupModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      grade: _formatGrade(json['grade']),
      teacherName: json['teacher'] as String? ?? '',
      studentCount: (stats?['studentsCount'] as num?)?.toInt() ?? 0,
      totalLessons: (lessons?['total'] as num?)?.toInt() ?? 0,
      completedLessons: (lessons?['completed'] as num?)?.toInt() ?? 0,
      progressPercent: rawProgress > 1 ? rawProgress / 100 : rawProgress,
      colorKey: _colorKeyForSubject(json['subject'] as String?),
    );
  }

  static Map<String, dynamic>? _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  static String _formatGrade(Object? value) {
    if (value == null) return '';
    final text = value.toString();
    return text.toLowerCase().startsWith('grade') ? text : 'Grade $text';
  }

  static String _colorKeyForSubject(String? subject) {
    switch (subject?.trim().toLowerCase()) {
      case 'english':
        return 'green';
      case 'physics':
      case 'science':
        return 'orange';
      case 'math':
      case 'mathematics':
        return 'blue';
      default:
        return 'blue';
    }
  }
}

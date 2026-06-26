import 'package:elara/features/student/domain/dashboard/entities/student_group_entity.dart';

class StudentGroupModel extends StudentGroupEntity {
  const StudentGroupModel({
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

  /// Parses the legacy flat JSON structure (mock / internal).
  factory StudentGroupModel.fromJson(Map<String, dynamic> json) {
    return StudentGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      grade: json['grade'] as String,
      teacherName: json['teacher_name'] as String,
      studentCount: json['student_count'] as int,
      totalLessons: json['total_lessons'] as int,
      completedLessons: json['completed_lessons'] as int,
      progressPercent: (json['progress_percent'] as num).toDouble(),
      colorKey: json['color_key'] as String? ?? 'blue',
    );
  }

  /// Parses the real API response envelope:
  /// ```json
  /// {
  ///   "id": "...", "name": "...", "subject": "...", "grade": 10,
  ///   "teacher": "...",
  ///   "stats": { "studentsCount": 1, "lessons": { "completed": 0, "total": 0 } },
  ///   "progressPercentage": 0
  /// }
  /// ```
  factory StudentGroupModel.fromApiJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    final lessons = stats['lessons'] as Map<String, dynamic>? ?? {};
    final gradeRaw = json['grade'];
    return StudentGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: (json['subject'] as String? ?? '').toUpperCase(),
      grade: 'Grade ${gradeRaw is int ? gradeRaw : gradeRaw}',
      teacherName: json['teacher'] as String? ?? '',
      studentCount: stats['studentsCount'] as int? ?? 0,
      totalLessons: lessons['total'] as int? ?? 0,
      completedLessons: lessons['completed'] as int? ?? 0,
      progressPercent:
          ((json['progressPercentage'] as num?) ?? 0).toDouble() / 100,
      colorKey: _colorKeyFromSubject(json['subject'] as String? ?? ''),
    );
  }

  /// Derives a stable color key from the subject name so cards get distinct
  /// colors even when the API doesn't return one.
  static String _colorKeyFromSubject(String subject) {
    final s = subject.toLowerCase();
    if (s.contains('math')) return 'blue';
    if (s.contains('english')) return 'green';
    if (s.contains('science') || s.contains('physics')) return 'orange';
    if (s.contains('history')) return 'purple';
    if (s.contains('art')) return 'pink';
    return 'blue';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subject': subject,
    'grade': grade,
    'teacher_name': teacherName,
    'student_count': studentCount,
    'total_lessons': totalLessons,
    'completed_lessons': completedLessons,
    'progress_percent': progressPercent,
    'color_key': colorKey,
  };
}

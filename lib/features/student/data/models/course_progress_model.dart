import 'package:elara/features/student/domain/entities/course_progress_entity.dart';

class CourseProgressModel extends CourseProgressEntity {
  const CourseProgressModel({
    required super.courseName,
    required super.lessonLabel,
    required super.currentLesson,
    required super.totalLessons,
    required super.progressPercent,
    super.lessonId,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    final current = json['current_lesson'] as int;
    final total = json['total_lessons'] as int;
    return CourseProgressModel(
      courseName: json['course_name'] as String,
      lessonLabel: 'Lesson $current of $total',
      currentLesson: current,
      totalLessons: total,
      progressPercent: (json['progress_percent'] as num).toDouble(),
      lessonId: json['lesson_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'course_name': courseName,
        'current_lesson': currentLesson,
        'total_lessons': totalLessons,
        'progress_percent': progressPercent,
        'lesson_id': lessonId,
      };
}

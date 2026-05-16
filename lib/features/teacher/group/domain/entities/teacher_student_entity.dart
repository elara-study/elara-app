import 'package:equatable/equatable.dart';

/// A student entry in the Teacher Group's student list.
class TeacherStudentEntity extends Equatable {
  final int rank;
  final String name;
  final String? avatarUrl;
  final int xp;

  /// e.g. "Lesson 15 of 20"
  final int completedLessons;
  final int totalLessons;

  const TeacherStudentEntity({
    required this.rank,
    required this.name,
    this.avatarUrl,
    required this.xp,
    required this.completedLessons,
    required this.totalLessons,
  });

  /// 0..1, derived from lesson counts.
  double get progress =>
      totalLessons == 0 ? 0.0 : completedLessons / totalLessons;

  String get lessonProgressLabel => 'Lesson $completedLessons of $totalLessons';

  @override
  List<Object?> get props => [rank, name, avatarUrl, xp, completedLessons, totalLessons];
}

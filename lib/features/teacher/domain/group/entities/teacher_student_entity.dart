import 'package:equatable/equatable.dart';

/// A student entry in the Teacher Group's student list.
class TeacherStudentEntity extends Equatable {
  final String id;
  final int rank;
  final String name;
  final String? avatarUrl;
  final int xp;
  final int streak;

  /// e.g. "Lesson 15 of 20"
  final int completedLessons;
  final int totalLessons;

  const TeacherStudentEntity({
    required this.id,
    required this.rank,
    required this.name,
    this.avatarUrl,
    required this.xp,
    required this.streak,
    required this.completedLessons,
    required this.totalLessons,
  });

  /// 0..1, derived from lesson counts.
  double get progress =>
      totalLessons == 0 ? 0.0 : completedLessons / totalLessons;

  String get lessonProgressLabel => 'Lesson $completedLessons of $totalLessons';

  @override
  List<Object?> get props => [id, rank, name, avatarUrl, xp, streak, completedLessons, totalLessons];
}

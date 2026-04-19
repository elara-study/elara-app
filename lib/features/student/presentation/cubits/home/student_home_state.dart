import 'package:elara/features/student/domain/entities/course_progress_entity.dart';
import 'package:elara/features/student/domain/entities/daily_goal_entity.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:elara/features/student/domain/entities/student_profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class StudentHomeState extends Equatable {
  const StudentHomeState();

  @override
  List<Object?> get props => [];
}

class StudentHomeInitial extends StudentHomeState {
  const StudentHomeInitial();
}

class StudentHomeLoading extends StudentHomeState {
  const StudentHomeLoading();
}

class StudentHomeLoaded extends StudentHomeState {
  final StudentProfileEntity profile;
  final CourseProgressEntity continuelearning;
  final List<DailyGoalEntity> dailyGoals;
  final List<StudentGroupEntity> groups;

  const StudentHomeLoaded({
    required this.profile,
    required this.continuelearning,
    required this.dailyGoals,
    required this.groups,
  });

  /// Convenience: count of completed daily goals
  int get completedGoalsCount => dailyGoals.where((g) => g.isCompleted).length;

  @override
  List<Object?> get props => [profile, continuelearning, dailyGoals, groups];
}

class StudentHomeError extends StudentHomeState {
  final String message;

  const StudentHomeError(this.message);

  @override
  List<Object?> get props => [message];
}

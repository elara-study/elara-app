import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:equatable/equatable.dart';

/// Complete child profile snapshot for Parent Child Profile view.
class ParentChildProfileEntity extends Equatable {
  const ParentChildProfileEntity({
    required this.child,
    required this.attendanceLabel,
    required this.insight,
    required this.homeworks,
  });

  final ParentChildProgressEntity child;
  final String attendanceLabel;
  final TeacherStudentInsightEntity? insight;
  final List<ParentHomeworkCardEntity> homeworks;

  @override
  List<Object?> get props => [child, attendanceLabel, insight, homeworks];
}

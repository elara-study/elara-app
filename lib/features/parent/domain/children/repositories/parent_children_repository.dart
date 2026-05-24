import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';

/// Repository interface for parent-linked children details.
abstract class ParentChildrenRepository {
  Future<ParentChildProfileEntity> getChildProfile(String childId);

  /// Retrieves all homework assignments for a specific child.
  Future<List<ParentHomeworkCardEntity>> getChildHomeworks(String childId);

  /// Retrieves all insights for a specific child.
  Future<List<TeacherStudentInsightEntity>> getChildInsights(String childId);
}

import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';

/// Data source interface for parent children detail queries.
abstract class ParentChildrenRemoteDataSource {
  Future<ParentChildProfileEntity> fetchChildProfile(String childId);

  /// Fetches all homework assignments for a specific child.
  Future<List<ParentHomeworkCardEntity>> fetchChildHomeworks(String childId);

  /// Fetches all insights for a specific child.
  Future<List<TeacherStudentInsightEntity>> fetchChildInsights(String childId);
}

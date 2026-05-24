import 'package:elara/features/parent/domain/children/repositories/parent_children_repository.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';

class GetParentChildInsightsUseCase {
  final ParentChildrenRepository _repository;

  const GetParentChildInsightsUseCase(this._repository);

  Future<List<TeacherStudentInsightEntity>> call(String childId) {
    return _repository.getChildInsights(childId);
  }
}

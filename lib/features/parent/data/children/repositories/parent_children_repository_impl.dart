import 'package:elara/features/parent/data/children/datasources/parent_children_remote_data_source.dart';
import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/parent/domain/children/repositories/parent_children_repository.dart';

/// Concrete implementation of ParentChildrenRepository.
class ParentChildrenRepositoryImpl implements ParentChildrenRepository {
  const ParentChildrenRepositoryImpl(this._dataSource);

  final ParentChildrenRemoteDataSource _dataSource;

  @override
  Future<ParentChildProfileEntity> getChildProfile(String childId) =>
      _dataSource.fetchChildProfile(childId);

  @override
  Future<List<ParentHomeworkCardEntity>> getChildHomeworks(String childId) =>
      _dataSource.fetchChildHomeworks(childId);

  @override
  Future<List<TeacherStudentInsightEntity>> getChildInsights(String childId) =>
      _dataSource.fetchChildInsights(childId);
}

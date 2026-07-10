import 'package:elara/features/student/data/homework/datasources/homework_data_source.dart';
import 'package:elara/features/student/domain/homework/entities/homework_entity.dart';
import 'package:elara/features/student/domain/homework/repositories/homework_repository.dart';

/// Concrete implementation of [HomeworkRepository].
///
/// Delegates entirely to [HomeworkDataSource].
/// Models extend entities, so no explicit mapping step is needed.
class HomeworkRepositoryImpl implements HomeworkRepository {
  final HomeworkDataSource _dataSource;

  const HomeworkRepositoryImpl(this._dataSource);

  @override
  Future<HomeworkEntity> getHomework({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  }) => _dataSource.getHomework(
    homeworkId: homeworkId,
    groupId: groupId,
    moduleId: moduleId,
  );

  @override
  Future<void> submitHomeworkAnswer({
    required String moduleId,
    required String problemId,
    required String groupId,
    required String answer,
  }) => _dataSource.submitHomeworkAnswer(
    moduleId: moduleId,
    problemId: problemId,
    groupId: groupId,
    answer: answer,
  );
}

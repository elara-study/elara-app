import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/domain/homework/repositories/i_teacher_homework_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddTeacherModuleResourceUseCase {
  final ITeacherHomeworkRepository _repository;

  const AddTeacherModuleResourceUseCase(this._repository);

  Future<ApiResult<TeacherResourceEntity>> call({
    required String moduleId,
    required String title,
    required String filePath,
  }) {
    return _repository.addModuleResource(
      moduleId: moduleId,
      title: title,
      filePath: filePath,
    );
  }
}

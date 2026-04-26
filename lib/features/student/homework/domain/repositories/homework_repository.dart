import 'package:elara/features/student/homework/domain/entities/homework_entity.dart';

/// Contract for the homework data layer.
///
/// When the backend is ready, swap [HomeworkRepositoryImpl] for a real
/// implementation — this interface and all callers above it stay unchanged.
abstract interface class HomeworkRepository {
  /// Fetches the homework assignment for the given [homeworkId].
  ///
  /// [groupId] and [moduleId] are optional identifiers that the remote API
  /// may need to scope the request (e.g. GET /groups/:groupId/modules/:moduleId/homework).
  Future<HomeworkEntity> getHomework({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  });
}

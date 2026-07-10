import 'package:elara/features/student/data/homework/models/homework_model.dart';

/// Abstract contract for the homework data source.
///
/// Swap [HomeworkDataSourceImpl] for a real Dio-based implementation
/// when the backend is ready — callers above this layer stay unchanged.
abstract interface class HomeworkDataSource {
  Future<HomeworkModel> getHomework({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  });

  Future<void> submitHomeworkAnswer({
    required String moduleId,
    required String problemId,
    required String groupId,
    required String answer,
  });
}

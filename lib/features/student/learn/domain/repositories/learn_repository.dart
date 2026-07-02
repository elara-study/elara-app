import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/learn/domain/entities/student_group.dart';

abstract class LearnRepository {
  Future<ApiResult<List<StudentGroup>>> getGroups();
}

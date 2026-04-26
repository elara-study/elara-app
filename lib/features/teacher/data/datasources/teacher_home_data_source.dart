import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';

/// Contract for fetching teacher home data.
///
/// Swap the implementation from [TeacherHomeDataSourceImpl] (mock) to a real
/// HTTP implementation once the backend is ready — no cubit or UI code changes.
abstract class TeacherHomeDataSource {
  Future<TeacherProfileEntity> getProfile();
  Future<List<TeacherGroupEntity>> getGroups();
  Future<List<TeacherActivityEntity>> getRecentActivity();
}

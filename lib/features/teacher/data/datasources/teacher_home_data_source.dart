import 'package:elara/features/teacher/domain/entities/teacher_dashboard_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';

/// Contract for fetching teacher home data.
///
/// Swap the implementation from [TeacherHomeDataSourceImpl] (mock) to a real
/// HTTP implementation once the backend is ready — no cubit or UI code changes.
abstract class TeacherHomeDataSource {
  Future<TeacherDashboardEntity> getDashboard();
  Future<List<TeacherGroupEntity>> getGroups();
  Future<List<TeacherGroupEntity>> getRoadmaps();

  Future<void> createGroup({
    required String title,
    required String subject,
    required String grade,
    required String roadmapName,
  });
  Future<void> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  });
}

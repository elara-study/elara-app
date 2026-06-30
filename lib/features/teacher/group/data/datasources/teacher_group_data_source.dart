import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/group/data/models/teacher_group_model.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_profile_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';

abstract class TeacherGroupDataSource {
  Future<TeacherGroupModel> createGroup({
    required String name,
    required int grade,
    required String subject,
    String? roadmap,
  });

  Future<TeacherGroupDetailEntity> getGroupDetail(String groupId);

  Future<void> deleteGroup(String groupId);

  Future<void> addStudent({
    required String groupId,
    required String username,
  });

  Future<TeacherStudentProfileEntity> getStudentProfile({
    required String groupId,
    required int studentRank,
  });

  Future<List<GroupAnnouncement>> getAnnouncements(String groupId);
  Future<void> addAnnouncement(String groupId, String title, String content);
  Future<void> deleteAnnouncement(String groupId, String announcementId);

  Future<TeacherRoadmapEntity> getRoadmap(String groupId);
  Future<TeacherStudentInsightEntity?> getStudentInsights(String studentId);
}

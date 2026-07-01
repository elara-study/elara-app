import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_profile_entity.dart';

abstract class TeacherGroupRepository {
  Future<Either<Failure, TeacherGroupEntity>> createGroup({
    required String name,
    required int grade,
    required String subject,
    String? roadmap,
  });

  Future<Either<Failure, TeacherGroupDetailEntity>> getGroupDetail(
    String groupId,
  );

  Future<Either<Failure, void>> deleteGroup(String groupId);

  Future<Either<Failure, void>> addStudent({
    required String groupId,
    required String username,
  });

  Future<Either<Failure, TeacherStudentProfileEntity>> getStudentProfile({
    required String groupId,
    required int studentRank,
  });

  Future<Either<Failure, List<GroupAnnouncement>>> getAnnouncements(
    String groupId,
  );

  Future<Either<Failure, void>> addAnnouncement(
    String groupId,
    String title,
    String content,
  );

  Future<Either<Failure, void>> deleteAnnouncement(
    String groupId,
    String announcementId,
  );

  Future<Either<Failure, TeacherRoadmapEntity>> getRoadmap(String groupId);

  Future<Either<Failure, TeacherStudentInsightEntity?>> getStudentInsights(
    String studentId,
  );
}

import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/entities/teacher_dashboard_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';

import 'package:elara/features/teacher/domain/entities/teacher_roadmap_entity.dart';

abstract class TeacherHomeRepository {
  Future<Either<Failure, TeacherDashboardEntity>> getDashboard();
  Future<Either<Failure, List<TeacherGroupEntity>>> getGroups();
  Future<Either<Failure, List<TeacherGroupEntity>>> getRoadmaps();
  Future<Either<Failure, TeacherRoadmapEntity>> getRoadmapDetails(String id);
  
  Future<Either<Failure, void>> createGroup({
    required String title,
    required String subject,
    required String grade,
    required String roadmapName,
  });
  
  Future<Either<Failure, void>> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  });
}

import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';

abstract class TeacherHomeRepository {
  Future<Either<Failure, TeacherProfileEntity>> getProfile();
  Future<Either<Failure, List<TeacherGroupEntity>>> getGroups();
  Future<Either<Failure, List<TeacherActivityEntity>>> getRecentActivity();
  
  Future<Either<Failure, void>> createGroup({
    required String title,
    required String subject,
    required String grade,
  });
  
  Future<Either<Failure, void>> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  });
}

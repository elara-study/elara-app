import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/data/group/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_profile_entity.dart';
import 'package:elara/features/teacher/domain/group/repositories/teacher_group_repository.dart';

class TeacherGroupRepositoryImpl implements TeacherGroupRepository {
  final TeacherGroupDataSource _remoteDataSource;

  TeacherGroupRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, TeacherGroupEntity>> createGroup({
    required String name,
    required int grade,
    required String subject,
    String? roadmap,
  }) async {
    try {
      final model = await _remoteDataSource.createGroup(
        name: name,
        grade: grade,
        subject: subject,
        roadmap: roadmap,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TeacherGroupDetailEntity>> getGroupDetail(
    String groupId,
  ) async {
    try {
      final detail = await _remoteDataSource.getGroupDetail(groupId);
      return Right(detail);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    try {
      await _remoteDataSource.deleteGroup(groupId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addStudent({
    required String groupId,
    required String username,
  }) async {
    try {
      await _remoteDataSource.addStudent(groupId: groupId, username: username);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TeacherStudentProfileEntity>> getStudentProfile({
    required String groupId,
    required int studentRank,
  }) async {
    try {
      final profile = await _remoteDataSource.getStudentProfile(
        groupId: groupId,
        studentRank: studentRank,
      );
      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupAnnouncement>>> getAnnouncements(
    String groupId,
  ) async {
    try {
      final announcements = await _remoteDataSource.getAnnouncements(groupId);
      return Right(announcements);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addAnnouncement(
    String groupId,
    String title,
    String content,
  ) async {
    try {
      await _remoteDataSource.addAnnouncement(groupId, title, content);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnnouncement(
    String groupId,
    String announcementId,
  ) async {
    try {
      await _remoteDataSource.deleteAnnouncement(groupId, announcementId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TeacherRoadmapEntity>> getRoadmap(
    String groupId,
  ) async {
    try {
      final roadmap = await _remoteDataSource.getRoadmap(groupId);
      return Right(roadmap);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRoadmap(String roadmapId) async {
    try {
      await _remoteDataSource.deleteRoadmap(roadmapId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TeacherStudentInsightEntity?>> getStudentInsights(
    String studentId,
  ) async {
    try {
      final insights = await _remoteDataSource.getStudentInsights(studentId);
      return Right(insights);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

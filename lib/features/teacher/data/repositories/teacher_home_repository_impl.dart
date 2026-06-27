import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';
import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';

class TeacherHomeRepositoryImpl implements TeacherHomeRepository {
  final TeacherHomeDataSource _remoteDataSource;

  TeacherHomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, TeacherProfileEntity>> getProfile() async {
    try {
      final profile = await _remoteDataSource.getProfile();
      return Right(profile);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TeacherGroupEntity>>> getGroups() async {
    try {
      final groups = await _remoteDataSource.getGroups();
      return Right(groups);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TeacherActivityEntity>>>
  getRecentActivity() async {
    try {
      final activity = await _remoteDataSource.getRecentActivity();
      return Right(activity);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createGroup({
    required String title,
    required String subject,
    required String grade,
  }) async {
    try {
      await _remoteDataSource.createGroup(
        title: title,
        subject: subject,
        grade: grade,
      );
      return Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  }) async {
    try {
      await _remoteDataSource.createRoadmap(
        title: title,
        subject: subject,
        grade: grade,
      );
      return Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

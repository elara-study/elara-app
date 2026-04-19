import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/student/data/datasources/student_remote_data_source.dart';
import 'package:elara/features/student/domain/entities/course_progress_entity.dart';
import 'package:elara/features/student/domain/entities/daily_goal_entity.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:elara/features/student/domain/entities/student_profile_entity.dart';
import 'package:elara/features/student/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource _remoteDataSource;

  StudentRepositoryImpl({required StudentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<StudentProfileEntity> getStudentProfile() async {
    try {
      return await _remoteDataSource.getStudentProfile();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CourseProgressEntity> getContinueLearning() async {
    try {
      return await _remoteDataSource.getContinueLearning();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<DailyGoalEntity>> getDailyGoals() async {
    try {
      return await _remoteDataSource.getDailyGoals();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<StudentGroupEntity>> getGroups() async {
    try {
      return await _remoteDataSource.getGroups();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> joinGroup(String code) async {
    try {
      await _remoteDataSource.joinGroup(code);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

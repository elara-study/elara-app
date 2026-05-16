import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_entity.dart';

/// Mock implementation — replace with HTTP calls when the API is ready.
class TeacherGroupDataSourceImpl implements TeacherGroupDataSource {
  const TeacherGroupDataSourceImpl();

  @override
  Future<TeacherGroupDetailEntity> getGroupDetail(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return TeacherGroupDetailEntity(
      studentCount: 28,
      avgCompletion: 0.87,
      presentToday: 23,
      students: _mockStudents,
    );
  }

  static final List<TeacherStudentEntity> _mockStudents = [
    const TeacherStudentEntity(
      rank: 1,
      name: 'Emma S.',
      xp: 3240,
      completedLessons: 15,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      rank: 2,
      name: 'Liam K.',
      xp: 2890,
      completedLessons: 15,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      rank: 3,
      name: 'Olivia M.',
      xp: 2650,
      completedLessons: 10,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      rank: 4,
      name: 'Noah A.',
      xp: 2410,
      completedLessons: 10,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      rank: 5,
      name: 'Sofia B.',
      xp: 2100,
      completedLessons: 9,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      rank: 6,
      name: 'James H.',
      xp: 1980,
      completedLessons: 8,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      rank: 7,
      name: 'Ava C.',
      xp: 1750,
      completedLessons: 7,
      totalLessons: 20,
    ),
  ];
}

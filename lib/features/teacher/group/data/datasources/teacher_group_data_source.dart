import 'package:elara/features/teacher/group/domain/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_profile_entity.dart';

abstract class TeacherGroupDataSource {
  Future<TeacherGroupDetailEntity> getGroupDetail(String groupId);

  Future<TeacherStudentProfileEntity> getStudentProfile({
    required String groupId,
    required int studentRank,
  });
}

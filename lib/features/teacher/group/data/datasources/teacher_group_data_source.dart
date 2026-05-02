import 'package:elara/features/teacher/group/domain/entities/teacher_group_detail_entity.dart';

abstract class TeacherGroupDataSource {
  Future<TeacherGroupDetailEntity> getGroupDetail(String groupId);
}

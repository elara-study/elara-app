import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_entity.dart';

/// Arguments for [AppRoutes.teacherStudentProfile].
class TeacherStudentProfileRouteArgs {
  const TeacherStudentProfileRouteArgs({
    required this.group,
    required this.student,
  });

  final TeacherGroupEntity group;
  final TeacherStudentEntity student;
}

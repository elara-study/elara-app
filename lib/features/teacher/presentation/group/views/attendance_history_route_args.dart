import 'package:elara/features/teacher/domain/group/entities/teacher_student_entity.dart';

/// Arguments for [AppRoutes.attendanceHistory].
class AttendanceHistoryRouteArgs {
  const AttendanceHistoryRouteArgs({
    required this.groupName,
    required this.presentToday,
    required this.totalStudents,
    required this.students,
  });

  final String groupName;
  final int presentToday;
  final int totalStudents;
  final List<TeacherStudentEntity> students;
}

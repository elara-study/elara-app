/// Route arguments for the Teacher Student Submission Detail screen.
class TeacherStudentSubmissionRouteArgs {
  const TeacherStudentSubmissionRouteArgs({
    required this.moduleId,
    required this.studentId,
    required this.studentName,
    required this.groupId,
    required this.totalXp,
  });

  /// Unique backend module identifier (typically a UUID).
  final String moduleId;

  /// Unique backend student identifier (typically a UUID).
  final String studentId;

  /// Display name shown in the app-bar.
  final String studentName;

  /// Group identifier for the submission query.
  final String groupId;

  /// Maximum XP for the homework (used for score input).
  final int totalXp;
}

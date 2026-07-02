/// Represents the logged-in teacher's profile summary shown on the home screen.
class TeacherProfileEntity {
  final String id;
  final String firstName;
  final String lastName;

  /// Total number of groups managed by this teacher.
  final int groupCount;

  /// Number of students who have been active in the last 7 days.
  final int activeStudentCount;

  /// Average completion percentage across all groups (0.0 – 1.0).
  final double avgCompletion;

  const TeacherProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.groupCount,
    required this.activeStudentCount,
    required this.avgCompletion,
  });

  String get fullName => '$firstName $lastName';
}

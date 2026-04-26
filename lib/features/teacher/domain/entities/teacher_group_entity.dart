/// A group managed by the teacher, as shown in the home screen preview list.
class TeacherGroupEntity {
  final String id;
  final String name;
  final String subject;

  /// Number of enrolled students.
  final int studentCount;

  /// Overall group progress (0.0 – 1.0).
  final double progressPercent;

  /// Colour key used to pick the gradient: 'purple' | 'orange' | 'green'.
  final String colorKey;

  const TeacherGroupEntity({
    required this.id,
    required this.name,
    required this.subject,
    required this.studentCount,
    required this.progressPercent,
    required this.colorKey,
  });
}

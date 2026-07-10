abstract class GroupEntity {
  const GroupEntity();

  String get id;
  String get name;
  String get subject;
  String get grade;
  int get studentCount;
  int get totalLessons;
  double get progressPercent;
  String get colorKey;

  // Optional — only student groups have these
  String get teacherName => '';
  int get completedLessons => 0;
  String get lessonProgressLabel => '$totalLessons lessons';
}

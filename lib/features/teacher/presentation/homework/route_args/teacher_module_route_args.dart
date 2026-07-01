/// Route arguments shared by both the Teacher Homework and Teacher Resources screens.
class TeacherModuleRouteArgs {
  const TeacherModuleRouteArgs({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleLabel,
    required this.groupId,
    required this.subject,
  });

  /// Unique module identifier (e.g. "MODULE 01" used as key until backend is ready).
  final String moduleId;

  /// Display title shown in the app-bar (e.g. "Introduction to Waves").
  final String moduleTitle;

  /// Short label shown as the app-bar subtitle prefix (e.g. "MODULE 01").
  final String moduleLabel;

  final String groupId;

  /// Group/course subject (e.g. "Physics 101").
  final String subject;
}

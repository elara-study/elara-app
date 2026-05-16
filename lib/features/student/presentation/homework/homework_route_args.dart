/// Arguments for [AppRoutes.homework].
///
/// Mirrors [QuizRouteArgs] — pass the IDs needed to scope the API request.
/// All fields except [homeworkId] are optional for backward compatibility.
class HomeworkRouteArgs {
  const HomeworkRouteArgs({
    required this.homeworkId,
    this.groupId,
    this.moduleId,
  });

  final String homeworkId;
  final String? groupId;
  final String? moduleId;
}

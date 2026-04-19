/// Arguments for [AppRoutes.quiz].
class QuizRouteArgs {
  const QuizRouteArgs({
    required this.quizId,
    this.groupId,
    this.moduleId,
  });

  final String quizId;
  final String? groupId;
  final String? moduleId;
}

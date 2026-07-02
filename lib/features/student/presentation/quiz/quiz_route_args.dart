/// Arguments for [AppRoutes.quiz].
class QuizRouteArgs {
  const QuizRouteArgs({
    required this.quizId,
    this.lessonId,
    this.groupId,
    this.moduleId,
  });

  final String quizId;

  /// Lesson ID used to generate a quiz via the live API.
  /// If null, the page falls back to the legacy mock [quizId] flow.
  final int? lessonId;

  final String? groupId;
  final String? moduleId;
}

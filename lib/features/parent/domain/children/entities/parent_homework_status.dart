/// Homework-level status derived from its problem statuses.
enum ParentHomeworkStatus {
  /// No problems submitted yet.
  active,

  /// At least one problem has been submitted but not all are graded.
  submitted,

  /// All problems have been graded.
  graded,
}

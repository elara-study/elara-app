/// The lifecycle state of a single homework problem.
enum HomeworkProblemStatus {
  /// Problem is open and the student has not yet answered.
  active,

  /// Student submitted an answer; awaiting teacher review.
  pending,

  /// Teacher acknowledged submission (transitional state before grading).
  submitted,

  /// Teacher has reviewed and scored the answer.
  graded,
}

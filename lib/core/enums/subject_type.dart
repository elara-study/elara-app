/// Subject enum — values must match the backend integer mapping exactly.
enum SubjectType {
  chemistry(1, 'Chemistry'),
  physics(2, 'Physics'),
  biology(3, 'Biology'),
  pureMathematics(4, 'Pure Mathematics'),
  appliedMathematics(5, 'Applied Mathematics'),
  arabic(6, 'Arabic'),
  english(7, 'English');

  const SubjectType(this.value, this.displayName);

  /// Integer value sent to / received from the backend.
  final int value;

  /// Human-readable label shown in the UI.
  final String displayName;

  /// Converts a backend integer to [SubjectType].
  /// Throws [ArgumentError] if the value is not recognised.
  static SubjectType fromValue(int value) {
    return SubjectType.values.firstWhere(
      (s) => s.value == value,
      orElse: () => throw ArgumentError('Unknown SubjectType value: $value'),
    );
  }

  /// All display names in order — used to populate the subject dropdown.
  static List<String> get displayNames =>
      SubjectType.values.map((s) => s.displayName).toList();

  /// All backend integer values in order.
  static List<int> get values_ => SubjectType.values.map((s) => s.value).toList();
}

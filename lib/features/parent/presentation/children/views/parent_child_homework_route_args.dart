/// Arguments for [AppRoutes.parentChildHomework].
class ParentChildHomeworkRouteArgs {
  const ParentChildHomeworkRouteArgs({
    required this.childId,
    required this.childHandle,
  });

  /// The child's unique ID used by the cubit to fetch homework data.
  final String childId;

  /// Child's display handle shown in the app bar, e.g. "@tylerthecreator".
  final String childHandle;
}

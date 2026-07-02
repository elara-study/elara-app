/// Relative API paths (joined with [ApiConstants.baseUrl] via Dio).
abstract final class ApiEndpoints {
  /// No leading slash — Dio appends this to [ApiConstants.baseUrl].
  static const String studentGroups = 'api/v1/student/groups';
}

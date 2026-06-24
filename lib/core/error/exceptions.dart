class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

/// Thrown by the repository when a Google-authenticated user has no role yet
/// and needs to complete registration.
class NeedsRoleException implements Exception {
  final String pendingToken;
  final String refreshToken;

  NeedsRoleException({required this.pendingToken, required this.refreshToken});
}

/// Thrown when login is blocked because the account email is not verified yet.
class EmailNotVerifiedException implements Exception {
  final String email;

  EmailNotVerifiedException({required this.email});
}

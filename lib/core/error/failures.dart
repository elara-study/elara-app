import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const ServerFailure('Connection error. Please check your internet connection.');
    }
    final response = e.response;
    if (response != null && response.data != null) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final detail = data['detail'] as String?;
        if (detail != null && detail.isNotEmpty) {
          return ServerFailure(detail);
        }
        final message = data['message'] as String?;
        if (message != null && message.isNotEmpty) {
          return ServerFailure(message);
        }
        final title = data['title'] as String?;
        if (title != null && title.isNotEmpty) {
          return ServerFailure(title);
        }
        final errors = data['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final first = errors.values.first;
          final detailStr = first is List && first.isNotEmpty
              ? first.first.toString()
              : first.toString();
          return ServerFailure(detailStr);
        }
      }
    }
    return ServerFailure(e.message ?? 'An unexpected server error occurred.');
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

import 'package:elara/core/error/failures.dart';

class ApiResult<T> {
  final T? data;
  final Failure? failure;
  final bool isSuccess;

  ApiResult._({this.data, this.failure, required this.isSuccess});

  factory ApiResult.success(T data) {
    return ApiResult._(data: data, isSuccess: true);
  }

  factory ApiResult.failure(Failure failure) {
    return ApiResult._(failure: failure, isSuccess: false);
  }

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    } else {
      return onFailure(failure!);
    }
  }
}

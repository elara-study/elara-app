import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

class RespondToRequestUseCase {
  const RespondToRequestUseCase(this._repository);

  final ParentHomeRepository _repository;

  Future<void> call({required String requestId, required bool accept}) =>
      _repository.respondToRequest(requestId, accept);
}

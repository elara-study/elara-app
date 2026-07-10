import 'package:elara/features/student/domain/profile/entities/student_profile_overview_entity.dart';
import 'package:elara/features/student/domain/profile/repositories/student_profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetStudentProfileOverviewUseCase {
  GetStudentProfileOverviewUseCase(this._repository);

  final StudentProfileRepository _repository;

  Future<StudentProfileOverviewEntity> call() =>
      _repository.getProfileOverview();
}

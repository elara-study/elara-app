import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';
import 'package:elara/features/student/domain/rewards/repositories/rewards_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateRewardsStatsUseCase {
  final RewardsRepository _repository;

  const UpdateRewardsStatsUseCase(this._repository);

  Future<List<BadgeEntity>> call({
    required int xpGained,
    required double quizAccuracy,
    String? subject,
    int lessonCompletedCount = 0,
    int practiceSeconds = 0,
  }) {
    return _repository.updateStats(
      xpGained: xpGained,
      quizAccuracy: quizAccuracy,
      subject: subject,
      lessonCompletedCount: lessonCompletedCount,
      practiceSeconds: practiceSeconds,
    );
  }
}

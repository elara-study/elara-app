import 'package:elara/features/parent/domain/home/entities/parent_activity_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_aggregate_stats_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';
import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

/// Mock data aligned with Figma parent Home (node 205:2146).
class MockParentHomeRepository implements ParentHomeRepository {
  @override
  Future<ParentHomeOverviewEntity> getHomeOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return const ParentHomeOverviewEntity(
      children: [
        ParentChildProgressEntity(
          id: 'c-1',
          displayName: 'Tyler',
          xpPoints: 1250,
          streakDays: 7,
          currentLesson: 15,
          totalLessons: 20,
          progress: 0.75,
        ),
        ParentChildProgressEntity(
          id: 'c-2',
          displayName: 'Drake',
          xpPoints: 67,
          streakDays: 1,
          currentLesson: 1,
          totalLessons: 20,
          progress: 0.05,
        ),
      ],
      stats: ParentAggregateStatsEntity(
        avgCompletionPercent: 87,
        avgAttendancePercent: 92,
      ),
      recentActivity: [
        ParentActivityEntity(
          id: 'a-1',
          title: 'Lesson Completion',
          subtitle: 'Tyler completed Quantum Physics Basics',
          timeLabel: 'Just now',
        ),
        ParentActivityEntity(
          id: 'a-2',
          title: 'Homework Submission',
          subtitle: 'Drake submitted Calculus Homework',
          timeLabel: '1h ago',
        ),
      ],
    );
  }
}

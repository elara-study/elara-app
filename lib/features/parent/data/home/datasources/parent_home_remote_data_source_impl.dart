import 'package:elara/features/parent/data/home/datasources/parent_home_remote_data_source.dart';
import 'package:elara/features/parent/data/home/models/parent_activity_model.dart';
import 'package:elara/features/parent/data/home/models/parent_aggregate_stats_model.dart';
import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/data/home/models/parent_children_dashboard_model.dart';
import 'package:elara/features/parent/data/home/models/parent_home_overview_model.dart';
import 'package:elara/features/parent/data/home/models/parent_pending_request_model.dart';
import 'package:elara/features/parent/data/home/models/parent_subject_group_progress_model.dart';

/// Mock remote parent home API — Home `205:2146`, Children `205:2260`.
///
/// Replace with HTTP [ParentHomeRemoteDataSource] when the backend exists.
class ParentHomeRemoteDataSourceImpl implements ParentHomeRemoteDataSource {
  const ParentHomeRemoteDataSourceImpl();

  static const List<ParentPendingRequestModel> _kPending = [
    ParentPendingRequestModel(
      id: 'pr-1',
      displayName: 'Tyler, The Creator',
      gradeLabel: 'Grade 7',
      requestedTimeLabel: 'Requested 2 hours ago',
    ),
  ];

  static const List<ParentChildProgressModel> _kChildren = [
    ParentChildProgressModel(
      id: 'c-1',
      displayName: 'Tyler, The Creator',
      xpPoints: 1250,
      streakDays: 7,
      currentLesson: 15,
      totalLessons: 20,
      progress: 0.75,
      gradeLabel: 'Grade 7',
      level: 12,
      subjectGroups: [
        ParentSubjectGroupProgressModel(name: 'Physics 101', progress: 0.65),
        ParentSubjectGroupProgressModel(name: 'Advanced Math', progress: 0.45),
        ParentSubjectGroupProgressModel(name: 'Biology Lab', progress: 0.80),
      ],
    ),
    ParentChildProgressModel(
      id: 'c-2',
      displayName: 'Drake',
      xpPoints: 67,
      streakDays: 1,
      currentLesson: 1,
      totalLessons: 20,
      progress: 0.05,
      gradeLabel: 'Grade 7',
      level: 12,
      subjectGroups: [
        ParentSubjectGroupProgressModel(name: 'Physics 101', progress: 0.65),
        ParentSubjectGroupProgressModel(name: 'Advanced Math', progress: 0.45),
        ParentSubjectGroupProgressModel(name: 'Biology Lab', progress: 0.80),
      ],
    ),
  ];

  @override
  Future<ParentHomeOverviewModel> fetchHomeOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return const ParentHomeOverviewModel(
      children: _kChildren,
      stats: ParentAggregateStatsModel(
        avgCompletionPercent: 87,
        avgAttendancePercent: 92,
      ),
      recentActivity: [
        ParentActivityModel(
          id: 'a-1',
          title: 'Lesson Completion',
          subtitle: 'Tyler completed Quantum Physics Basics',
          timeLabel: 'Just now',
        ),
        ParentActivityModel(
          id: 'a-2',
          title: 'Homework Submission',
          subtitle: 'Drake submitted Calculus Homework',
          timeLabel: '1h ago',
        ),
      ],
    );
  }

  @override
  Future<List<ParentChildProgressModel>> fetchLinkedChildren() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return _kChildren;
  }

  @override
  Future<ParentChildrenDashboardModel> fetchChildrenDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return const ParentChildrenDashboardModel(
      pendingRequests: _kPending,
      children: _kChildren,
    );
  }
}

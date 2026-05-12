import 'package:elara/features/student/data/profile/datasources/student_profile_remote_data_source.dart';
import 'package:elara/features/student/data/profile/models/student_profile_overview_model.dart';

/// MOCKED implementation — replace body of [getProfileOverview] with a real
/// Dio call once the backend is ready.
///
/// To switch to real API:
///   1. Inject [DioClient] via constructor.
///   2. Replace the mock block with `_dioClient.dio.get(ApiConstants...)` and
///      parse via [StudentProfileOverviewModel.fromJson].
///   3. Uncomment registration in [setupDependencyInjection] to pass [DioClient].
class StudentProfileRemoteDataSourceImpl
    implements StudentProfileRemoteDataSource {
  // Inject DioClient when backend is ready:
  // final DioClient _dioClient;
  // StudentProfileRemoteDataSourceImpl(this._dioClient);

  StudentProfileRemoteDataSourceImpl();

  @override
  Future<StudentProfileOverviewModel> getProfileOverview() async {
    // ── MOCK (Figma-aligned) ────────────────────────────────────────────────
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return const StudentProfileOverviewModel(
      gradeLabel: 'Grade 7 Student',
      level: 11,
      nextLevel: 12,
      xpCurrent: 1250,
      xpGoal: 1500,
      totalXp: 1250,
      streakDays: 7,
      lessonsCompleted: 24,
      linkedParents: [
        ProfileLinkedParentModel(id: 'p-1', displayName: 'Kanye West'),
        ProfileLinkedParentModel(id: 'p-2', displayName: 'Taylor Swift'),
      ],
      recentAchievements: [
        ProfileAchievementPreviewModel(label: 'Quiz Champion'),
        ProfileAchievementPreviewModel(label: 'Streak Master'),
        ProfileAchievementPreviewModel(label: 'Quick Learner'),
      ],
    );
    // ── REAL (uncomment when backend ready) ─────────────────────────────────
    // try {
    //   final response = await _dioClient.dio.get(
    //     ApiConstants.studentProfileOverview,
    //   );
    //   final data = response.data;
    //   if (data is! Map<String, dynamic>) {
    //     throw ServerException('Invalid profile overview response');
    //   }
    //   return StudentProfileOverviewModel.fromJson(data);
    // } on DioException catch (e) {
    //   throw ServerException(e.message ?? 'Failed to load profile');
    // }
  }
}

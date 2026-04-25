import 'package:elara/features/student/homework/data/datasources/homework_data_source.dart';
import 'package:elara/features/student/homework/data/models/homework_model.dart';
import 'package:elara/features/student/homework/data/models/homework_problem_model.dart';
import 'package:elara/features/student/homework/domain/entities/homework_problem_status.dart';

/// MOCKED implementation — realistic data matching the Figma design.
///
/// To switch to real API when backend is ready:
///   1. Inject [DioClient] via constructor.
///   2. Replace the [Future.delayed] block with the corresponding Dio call.
///   3. Parse the response using [HomeworkModel.fromJson].
///   4. Update [dependency_injection.dart] to pass [getIt<DioClient>()].
class HomeworkDataSourceImpl implements HomeworkDataSource {
  // TODO: inject DioClient when backend is ready
  // final DioClient _dioClient;
  // HomeworkDataSourceImpl(this._dioClient);

  HomeworkDataSourceImpl();

  @override
  Future<HomeworkModel> getHomework({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const HomeworkModel(
      id: 'hw-001',
      subject: 'Physics 101',
      moduleTitle: 'Kinematics',
      totalXp: 100,
      problems: [
        HomeworkProblemModel(
          id: 'prob-001',
          problemNumber: 1,
          questionText:
              "Define Newton's Second Law of Motion and provide a real-world example involving friction.",
          status: HomeworkProblemStatus.active,
        ),
        HomeworkProblemModel(
          id: 'prob-002',
          problemNumber: 2,
          questionText:
              'Calculate the velocity of a 2 kg object falling from a height of 10 meters just before it hits the ground. Ignore air resistance.',
          status: HomeworkProblemStatus.pending,
          submittedAnswer: 'Using v² = 2gh, v = √(2 × 10 × 10) = 14.14 m/s',
        ),
        HomeworkProblemModel(
          id: 'prob-003',
          problemNumber: 3,
          questionText:
              'Explain the difference between distance and displacement with a practical example.',
          status: HomeworkProblemStatus.graded,
          submittedAnswer:
              'Distance is the total path length while displacement is the straight-line change in position.',
          grade: 9,
          maxGrade: 10,
          feedback:
              'Great answer! You could also mention that displacement is a vector quantity.',
        ),
        HomeworkProblemModel(
          id: 'prob-004',
          problemNumber: 4,
          questionText:
              'A car accelerates from rest to 60 km/h in 5 seconds. What is its acceleration in m/s²?',
          status: HomeworkProblemStatus.active,
        ),
      ],
    );

    // ── REAL ──────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get(
    //   'groups/$groupId/modules/$moduleId/homework/$homeworkId',
    // );
    // return HomeworkModel.fromJson(response.data as Map<String, dynamic>);
  }
}

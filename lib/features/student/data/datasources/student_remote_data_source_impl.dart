import 'package:elara/features/student/data/datasources/student_remote_data_source.dart';
import 'package:elara/features/student/data/models/course_progress_model.dart';
import 'package:elara/features/student/data/models/daily_goal_model.dart';
import 'package:elara/features/student/data/models/student_group_model.dart';
import 'package:elara/features/student/data/models/student_profile_model.dart';

/// MOCKED implementation — realistic data matching the design screenshots.
///
/// To switch to real API when backend is ready:
///   1. Inject [DioClient] via constructor.
///   2. Replace each [Future.delayed] block with the corresponding Dio call.
///   3. Parse responses using the model [fromJson] factories.
///   4. Update [dependency_injection.dart] to pass [getIt<DioClient>()].
class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  // TODO: inject DioClient when backend is ready
  // final DioClient _dioClient;
  // StudentRemoteDataSourceImpl(this._dioClient);

  StudentRemoteDataSourceImpl();

  @override
  Future<StudentProfileModel> getStudentProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const StudentProfileModel(
      id: 'student-001',
      fullName: 'Tyler Johnson',
      firstName: 'Tyler',
      points: 1250,
      notificationCount: 7,
    );
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/profile');
    // return StudentProfileModel.fromJson(response.data);
  }

  @override
  Future<CourseProgressModel> getContinueLearning() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const CourseProgressModel(
      courseName: 'Algebra Basics',
      lessonLabel: 'Lesson 5 of 8',
      currentLesson: 5,
      totalLessons: 8,
      progressPercent: 0.62,
      lessonId: 'lesson-alg-005',
    );
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/continue-learning');
    // return CourseProgressModel.fromJson(response.data);
  }

  @override
  Future<List<DailyGoalModel>> getDailyGoals() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      DailyGoalModel(
        id: 'goal-001',
        label: 'Complete 3 lessons',
        iconKey: 'book',
        xpReward: 50,
        isCompleted: false,
      ),
      DailyGoalModel(
        id: 'goal-002',
        label: 'Score 80% on a quiz',
        iconKey: 'quiz',
        xpReward: 30,
        isCompleted: true,
      ),
      DailyGoalModel(
        id: 'goal-003',
        label: 'Practice for 15 mins',
        iconKey: 'timer',
        xpReward: 25,
        isCompleted: false,
      ),
    ];
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/daily-goals');
    // return (response.data as List).map(DailyGoalModel.fromJson).toList();
  }

  @override
  Future<List<StudentGroupModel>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      StudentGroupModel(
        id: 'group-001',
        name: 'Mathematics 7A',
        subject: 'MATHEMATICS',
        grade: 'Grade 7',
        teacherName: 'Ms. Dalia',
        studentCount: 28,
        totalLessons: 20,
        completedLessons: 13,
        progressPercent: 0.65,
        colorKey: 'blue',
      ),
      StudentGroupModel(
        id: 'group-002',
        name: 'Physics 101',
        subject: 'SCIENCE',
        grade: 'Grade 7',
        teacherName: 'Ms. Dalia',
        studentCount: 25,
        totalLessons: 18,
        completedLessons: 8,
        progressPercent: 0.45,
        colorKey: 'orange',
      ),
      StudentGroupModel(
        id: 'group-003',
        name: 'English Literature',
        subject: 'ENGLISH',
        grade: 'Grade 7',
        teacherName: 'Ms. Dalia',
        studentCount: 30,
        totalLessons: 20,
        completedLessons: 16,
        progressPercent: 0.80,
        colorKey: 'green',
      ),
    ];
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/groups');
    // return (response.data as List).map(StudentGroupModel.fromJson).toList();
  }

  @override
  Future<void> joinGroup(String code) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate invalid code validation
    if (code.trim().isEmpty || code.trim().length < 4) {
      throw Exception('Invalid group code. Please check and try again.');
    }
    // ── REAL ────────────────────────────────────────────────────────────────
    // await _dioClient.dio.post('student/groups/join', data: {'code': code});
  }
}

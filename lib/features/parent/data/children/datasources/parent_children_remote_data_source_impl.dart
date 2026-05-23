import 'package:elara/features/parent/data/children/datasources/parent_children_remote_data_source.dart';
import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_subject_group_progress_entity.dart';
import 'package:elara/features/student/domain/homework/entities/homework_entity.dart';
import 'package:elara/features/student/domain/homework/entities/homework_problem_entity.dart';
import 'package:elara/features/student/domain/homework/entities/homework_problem_status.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';

/// Mock remote datasource for parent children detail queries.
class ParentChildrenRemoteDataSourceImpl
    implements ParentChildrenRemoteDataSource {
  const ParentChildrenRemoteDataSourceImpl();

  /// Shared mock homework list builder.
  List<ParentHomeworkCardEntity> _buildMockHomeworks() {
    const homeworks = [
      HomeworkEntity(
        id: 'hw-1',
        subject: 'Mathematics 7A',
        moduleTitle: 'Introduction to Calculus',
        totalXp: 250,
        problems: [
          HomeworkProblemEntity(
            id: 'p-1',
            problemNumber: 1,
            questionText: 'Find the derivative of f(x) = x².',
            status: HomeworkProblemStatus.active,
            submittedAnswer: '',
          ),
        ],
      ),
      HomeworkEntity(
        id: 'hw-2',
        subject: 'Physics 101',
        moduleTitle: 'Kinematics',
        totalXp: 250,
        problems: [
          HomeworkProblemEntity(
            id: 'p-2',
            problemNumber: 1,
            questionText:
                'A car accelerates from rest at 2 m/s² for 5 seconds. Find its final velocity.',
            status: HomeworkProblemStatus.graded,
            submittedAnswer: '10 m/s',
            grade: 10,
            maxGrade: 10,
            feedback: 'Excellent work!',
          ),
          HomeworkProblemEntity(
            id: 'p-3',
            problemNumber: 2,
            questionText: 'Describe motion in one and two dimensions.',
            status: HomeworkProblemStatus.graded,
            submittedAnswer:
                'Motion along a straight line vs motion in a plane.',
            grade: 90,
            maxGrade: 90,
            feedback: 'Perfect!',
          ),
        ],
      ),
      HomeworkEntity(
        id: 'hw-3',
        subject: 'Physics 101',
        moduleTitle: 'Introduction to Waves',
        totalXp: 200,
        problems: [
          HomeworkProblemEntity(
            id: 'p-4',
            problemNumber: 1,
            questionText:
                'Explain the relationship between frequency and wavelength.',
            status: HomeworkProblemStatus.submitted,
            submittedAnswer:
                'Frequency and wavelength are inversely proportional.',
          ),
          HomeworkProblemEntity(
            id: 'p-5',
            problemNumber: 2,
            questionText: 'Define amplitude in the context of wave motion.',
            status: HomeworkProblemStatus.submitted,
            submittedAnswer:
                'Amplitude is the maximum displacement from the equilibrium position.',
          ),
        ],
      ),
    ];
    return homeworks
        .map((hw) => ParentHomeworkCardEntity.fromHomework(hw))
        .toList();
  }

  @override
  Future<ParentChildProfileEntity> fetchChildProfile(String childId) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));

    // Resolve which child profile to mock based on childId
    final String displayName = childId == 'c-2'
        ? 'Drake'
        : 'Tyler, The Creator';
    final int xp = childId == 'c-2' ? 67 : 1250;
    final int streak = childId == 'c-2' ? 1 : 7;
    final int currentLsn = childId == 'c-2' ? 1 : 15;

    final child = ParentChildProgressEntity(
      id: childId,
      displayName: displayName,
      xpPoints: xp,
      streakDays: streak,
      currentLesson: currentLsn,
      totalLessons: 20,
      progress: childId == 'c-2' ? 0.05 : 0.75,
      gradeLabel: 'Grade 7',
      level: 12,
      subjectGroups: const [
        ParentSubjectGroupProgressEntity(name: 'Physics 101', progress: 0.65),
        ParentSubjectGroupProgressEntity(name: 'Advanced Math', progress: 0.45),
        ParentSubjectGroupProgressEntity(name: 'Biology Lab', progress: 0.80),
      ],
    );

    final insight = TeacherStudentInsightEntity(
      updatedLabel: '5 min ago',
      paragraph1:
          '$displayName has shown exceptional growth in Quantum Mechanics this term. His ability to grasp complex theoretical concepts, particularly regarding ware-particle duality, is outstanding and frequently pushes classroom discussions to higher levels.',
      paragraph2:
          'However, we noticed a dip in his practical lab applications. While his mathematical foundations are strong, a renewed focus on consistent experiment documentation and safety protocol adherence could bridge the gap between his theoretical brilliance and practical execution.',
      isDraft: false,
    );

    return ParentChildProfileEntity(
      child: child,
      attendanceLabel: '96%',
      insight: insight,
      homeworks: _buildMockHomeworks(),
    );
  }

  @override
  Future<List<ParentHomeworkCardEntity>> fetchChildHomeworks(
    String childId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _buildMockHomeworks();
  }
}

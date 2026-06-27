import 'package:elara/features/student/domain/profile/entities/profile_linked_parent_entity.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/data/models/teacher_group_model.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_profile_entity.dart';

class MockTeacherGroupDataSource implements TeacherGroupDataSource {
  const MockTeacherGroupDataSource();

  @override
  Future<TeacherGroupModel> createGroup({
    required String name,
    required int grade,
    required String subject,
    String? roadmap,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TeacherGroupModel(
      id: 'mock-id-123',
      name: name,
      grade: grade.toString(),
      subject: subject,
      roadmapName: roadmap ?? 'Mock Roadmap',
      studentCount: 0,
    );
  }

  @override
  Future<TeacherGroupDetailEntity> getGroupDetail(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return TeacherGroupDetailEntity(
      name: 'Mock Group',
      subject: 'Science',
      grade: 10,
      joinCode: 'ABCXYZ',
      studentCount: 28,
      avgCompletion: 0.87,
      presentToday: 23,
      students: _mockStudents,
    );
  }

  @override
  Future<TeacherStudentProfileEntity> getStudentProfile({
    required String groupId,
    required int studentRank,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final student = _mockStudents.firstWhere(
      (s) => s.rank == studentRank,
      orElse: () => _mockStudents.first,
    );
    return _profileForStudent(student);
  }

  static TeacherStudentProfileEntity _profileForStudent(
    TeacherStudentEntity student,
  ) {
    const insight = TeacherStudentInsightEntity(
      updatedLabel: 'Last updated 5 min ago',
      paragraph1:
          'Tyler has shown exceptional growth in Quantum Mechanics this term. '
          'His ability to grasp complex theoretical concepts, particularly '
          'regarding wave-particle duality, is outstanding and frequently '
          'pushes classroom discussions to higher levels.',
      paragraph2:
          'However, we noticed a slight dip in his practical lab applications. '
          'While his mathematical foundations are strong, a renewed focus on '
          'consistent experiment documentation and safety protocol adherence '
          'could bridge the gap between his theoretical brilliance and '
          'practical execution.',
    );

    final handle = '@${_handleFromName(student.name)}';
    return TeacherStudentProfileEntity(
      student: student,
      handle: handle,
      gradeLabel: 'Grade 7 Student',
      level: 11,
      nextLevel: 12,
      xpCurrent: 1250,
      xpGoal: 1500,
      streakDays: 7,
      attendancePercent: 97,
      parents: const [
        ProfileLinkedParentEntity(id: 'p1', displayName: 'Kanye West'),
        ProfileLinkedParentEntity(id: 'p2', displayName: 'Taylor Swift'),
      ],
      insight: insight,
    );
  }

  static String _handleFromName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
    return cleaned.isEmpty ? 'student' : cleaned;
  }

  @override
  Future<List<GroupAnnouncement>> getAnnouncements(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      GroupAnnouncement(
        id: '1',
        title: 'Welcome to Science!',
        body: 'Welcome everyone to the new term. Please check the syllabus.',
        relativeTimeLabel: '2 days ago',
      ),
    ];
  }

  static final List<TeacherStudentEntity> _mockStudents = [
    const TeacherStudentEntity(
      id: 'student_1',
      rank: 1,
      name: 'Emma S.',
      xp: 3240,
      streak: 5,
      completedLessons: 15,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      id: 'student_2',
      rank: 2,
      name: 'Liam K.',
      xp: 2890,
      streak: 3,
      completedLessons: 15,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      id: 'student_3',
      rank: 3,
      name: 'Olivia M.',
      xp: 2650,
      streak: 0,
      completedLessons: 10,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      id: 'student_4',
      rank: 4,
      name: 'Noah A.',
      xp: 2410,
      streak: 1,
      completedLessons: 10,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      id: 'student_5',
      rank: 5,
      name: 'Sofia B.',
      xp: 2100,
      streak: 12,
      completedLessons: 9,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      id: 'student_6',
      rank: 6,
      name: 'James H.',
      xp: 1980,
      streak: 2,
      completedLessons: 8,
      totalLessons: 20,
    ),
    const TeacherStudentEntity(
      id: 'student_7',
      rank: 7,
      name: 'Ava C.',
      xp: 1750,
      streak: 0,
      completedLessons: 7,
      totalLessons: 20,
    ),
  ];
}

import 'package:elara/features/teacher/data/homework/datasources/teacher_homework_datasource.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_homework_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_homework_problem_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_rated_student_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_resource_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_student_answer_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_student_submission_model.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';

class MockTeacherHomeworkDatasource implements TeacherHomeworkDatasource {
  @override
  Future<TeacherHomeworkModel> getModuleHomework({
    required String moduleId,
    required String groupId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final moduleTitle = switch (moduleId) {
      'MODULE 01' => 'Introduction to Waves',
      'MODULE 02' => 'Kinematics',
      _ => 'Module',
    };

    return TeacherHomeworkModel(
      moduleId: moduleId,
      moduleTitle: moduleTitle,
      moduleLabel: moduleId,
      groupId: groupId,
      subject: 'Physics 101',
      totalXp: 100,
      problems: const [
        TeacherHomeworkProblemModel(
          id: 'prob-01',
          problemNumber: 1,
          questionText:
              "Define Newton's Second Law of Motion and provide a real-world example involving friction.",
          // Emma submitted a handwritten image answer
          hasImageSubmission: true,
        ),
        TeacherHomeworkProblemModel(
          id: 'prob-02',
          problemNumber: 2,
          questionText:
              'Calculate the velocity of a 2 kg object falling from a height of 10 meters just before it hits the ground. Ignore air resistance.',
          // Liam submitted a text answer — show a preview on the card
          sampleAnswerText: 'Velocity just before impact = 14 m/s downward',
        ),
      ],
      submissions: const [
        // Emma S. — submitted images for both problems
        TeacherStudentSubmissionModel(
          id: 'sub-emma',
          studentName: 'Emma S.',
          submittedCount: 2,
          totalProblems: 2,
          answers: [
            TeacherStudentAnswerModel(
              answerNumber: 1,
              questionText:
                  "Define Newton's Second Law of Motion and provide a real-world example involving friction.",
              imageUrl: 'mock',
              maxScore: 50,
            ),
            TeacherStudentAnswerModel(
              answerNumber: 2,
              questionText:
                  'Calculate the velocity of a 2 kg object falling from a height of 10 meters just before it hits the ground. Ignore air resistance.',
              imageUrl: 'mock',
              maxScore: 50,
            ),
          ],
        ),
        // Liam K. — typed text answers for both problems
        TeacherStudentSubmissionModel(
          id: 'sub-liam',
          studentName: 'Liam K.',
          submittedCount: 2,
          totalProblems: 2,
          answers: [
            TeacherStudentAnswerModel(
              answerNumber: 1,
              questionText:
                  "Define Newton's Second Law of Motion and provide a real-world example involving friction.",
              answerText:
                  "Newton's Second Law states that the acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its mass (F = ma). A real-world example is pushing a heavy box across a floor — the friction opposes the applied force, so a greater push is needed to achieve the same acceleration.",
              maxScore: 50,
            ),
            TeacherStudentAnswerModel(
              answerNumber: 2,
              questionText:
                  'Calculate the velocity of a 2 kg object falling from a height of 10 meters just before it hits the ground. Ignore air resistance.',
              answerText:
                  'Using energy conservation: v = sqrt(2gh) = sqrt(2 × 9.8 × 10) = sqrt(196) ≈ 14 m/s. The object hits the ground at approximately 14 m/s.',
              maxScore: 50,
            ),
          ],
        ),
        // Olivia M. — typed text answers for both problems
        TeacherStudentSubmissionModel(
          id: 'sub-olivia',
          studentName: 'Olivia M.',
          submittedCount: 2,
          totalProblems: 2,
          answers: [
            TeacherStudentAnswerModel(
              answerNumber: 1,
              questionText:
                  "Define Newton's Second Law of Motion and provide a real-world example involving friction.",
              answerText:
                  "Newton's Second Law (F = ma) describes how a net force causes acceleration proportional to that force and inversely proportional to the object's mass. A practical example: when braking a car, friction between the tyres and road decelerates the vehicle — a heavier car requires a greater braking force to achieve the same deceleration.",
              maxScore: 50,
            ),
            TeacherStudentAnswerModel(
              answerNumber: 2,
              questionText:
                  'Calculate the velocity of a 2 kg object falling from a height of 10 meters just before it hits the ground. Ignore air resistance.',
              answerText:
                  'Applying kinematics: v² = u² + 2as = 0 + 2(9.8)(10) = 196, so v = 14 m/s. The velocity just before impact is 14 m/s downward.',
              maxScore: 50,
            ),
          ],
        ),
      ],
      ratedStudents: const [
        TeacherRatedStudentModel(
          id: 'rated-emma',
          studentName: 'Emma S.',
          totalXp: 100,
          maxXp: 100,
        ),
        TeacherRatedStudentModel(
          id: 'rated-liam',
          studentName: 'Liam K.',
          totalXp: 85,
          maxXp: 100,
        ),
        TeacherRatedStudentModel(
          id: 'rated-olivia',
          studentName: 'Olivia M.',
          totalXp: 90,
          maxXp: 100,
        ),
      ],
    );
  }

  @override
  Future<TeacherHomeworkProblemModel> addModuleProblem({
    required String moduleId,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return TeacherHomeworkProblemModel(
      id: 'prob-${DateTime.now().millisecondsSinceEpoch}',
      problemNumber: 0,
      questionText: description,
    );
  }

  @override
  Future<TeacherHomeworkProblemModel> updateProblem({
    required String problemId,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return TeacherHomeworkProblemModel(
      id: problemId,
      problemNumber: 0,
      questionText: description,
    );
  }

  @override
  Future<void> deleteProblem({required String problemId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<List<TeacherResourceModel>> getModuleResources({
    required String moduleId,
    required String groupId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      TeacherResourceModel(
        id: 'res-v1',
        title: 'Introduction to Kinematics',
        description:
            'A comprehensive video walkthrough of kinematics concepts including displacement, velocity, and acceleration with worked examples.',
        type: TeacherResourceType.video,
        url: 'https://example.com/kinematics-intro.mp4',
        duration: '12:45',
        addedAtLabel: '2 days ago',
      ),
      TeacherResourceModel(
        id: 'res-p1',
        title: 'Course Syllabus',
        description:
            'Full course syllabus covering all modules, assessment criteria, and recommended reading for Physics 101.',
        type: TeacherResourceType.pdf,
        url: 'https://example.com/course-syllabus.pdf',
        fileSize: '1.2 MB',
        addedAtLabel: '1 week ago',
      ),
      TeacherResourceModel(
        id: 'res-i1',
        title: 'Palette_01.jpg',
        fileName: 'Palette_01.jpg',
        description: '',
        type: TeacherResourceType.image,
        url: 'https://example.com/images/palette_01.jpg',
        fileSize: '234 KB',
        addedAtLabel: '3 days ago',
      ),
      TeacherResourceModel(
        id: 'res-i2',
        title: 'Palette_02.jpg',
        fileName: 'Palette_02.jpg',
        description: '',
        type: TeacherResourceType.image,
        url: 'https://example.com/images/palette_02.jpg',
        fileSize: '198 KB',
        addedAtLabel: '3 days ago',
      ),
      TeacherResourceModel(
        id: 'res-i3',
        title: 'Palette_03.jpg',
        fileName: 'Palette_03.jpg',
        description: '',
        type: TeacherResourceType.image,
        url: 'https://example.com/images/palette_03.jpg',
        fileSize: '211 KB',
        addedAtLabel: '3 days ago',
      ),
    ];
  }

  @override
  Future<TeacherResourceModel> addModuleResource({
    required String moduleId,
    required String title,
    required String filePath,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return TeacherResourceModel(
      id: 'res-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: '',
      type: filePath.startsWith('http')
          ? TeacherResourceType.link
          : TeacherResourceType.document,
      url: filePath,
      addedAtLabel: 'Just now',
    );
  }
}

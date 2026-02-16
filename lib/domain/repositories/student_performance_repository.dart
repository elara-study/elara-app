import 'package:elara/domain/models/student_performance.dart';

class StudentPerformanceRepository {
  // Mock data for demonstration
  final Map<String, StudentPerformance> _mockData = {};

  StudentPerformanceRepository() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Ahmed - Strong in quizzes, weaker in essays
    _mockData['ahmed'] = StudentPerformance(
      studentId: 'ahmed',
      studentName: 'Ahmed Hassan',
      email: 'ahmed.hassan@student.edu',
      avatarUrl: null,
      overallGrade: 82.5,
      totalQuizzes: 5,
      totalEssays: 3,
      averageQuizScore: 88.4,
      averageEssayScore: 73.3,
      quizAttempts: [
        QuizAttempt(
          id: 'q1',
          quizTitle: 'Algebra Basics Quiz',
          score: 18,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          timeSpentMinutes: 25,
          questionResults: [
            const QuestionResult(questionText: 'What is 2+2?', isCorrect: true, studentAnswer: '4', correctAnswer: '4'),
            const QuestionResult(questionText: 'Solve: x + 5 = 10', isCorrect: true, studentAnswer: 'x=5', correctAnswer: 'x=5'),
            const QuestionResult(questionText: 'Factor: x² - 4', isCorrect: false, studentAnswer: 'x-2', correctAnswer: '(x+2)(x-2)'),
          ],
        ),
        QuizAttempt(
          id: 'q2',
          quizTitle: 'Geometry Fundamentals',
          score: 17,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 7)),
          timeSpentMinutes: 30,
          questionResults: [],
        ),
        QuizAttempt(
          id: 'q3',
          quizTitle: 'Calculus Quiz 1',
          score: 19,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 14)),
          timeSpentMinutes: 28,
          questionResults: [],
        ),
        QuizAttempt(
          id: 'q4',
          quizTitle: 'Statistics Basics',
          score: 16,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 21)),
          timeSpentMinutes: 22,
          questionResults: [],
        ),
        QuizAttempt(
          id: 'q5',
          quizTitle: 'Probability Quiz',
          score: 18,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 28)),
          timeSpentMinutes: 26,
          questionResults: [],
        ),
      ],
      essayAttempts: [
        EssayAttempt(
          id: 'e1',
          essayTitle: 'Impact of Technology',
          score: 75,
          maxScore: 100,
          submittedAt: DateTime.now().subtract(const Duration(days: 5)),
          rubricName: 'Argumentative Essay Rubric',
          criteriaScores: const [
            CriterionScore(criterionName: 'Thesis', score: 20, maxScore: 25, feedback: 'Clear thesis but needs stronger argumentation'),
            CriterionScore(criterionName: 'Evidence', score: 25, maxScore: 35, feedback: 'Good use of sources but needs more depth'),
            CriterionScore(criterionName: 'Analysis', score: 18, maxScore: 25, feedback: 'Analysis could be more critical'),
            CriterionScore(criterionName: 'Grammar', score: 12, maxScore: 15, feedback: 'Minor grammar issues'),
          ],
        ),
        EssayAttempt(
          id: 'e2',
          essayTitle: 'Climate Change Essay',
          score: 70,
          maxScore: 100,
          submittedAt: DateTime.now().subtract(const Duration(days: 15)),
          rubricName: 'Argumentative Essay Rubric',
          criteriaScores: const [
            CriterionScore(criterionName: 'Thesis', score: 18, maxScore: 25, feedback: 'Thesis needs more focus'),
            CriterionScore(criterionName: 'Evidence', score: 24, maxScore: 35, feedback: 'Solid evidence provided'),
            CriterionScore(criterionName: 'Analysis', score: 16, maxScore: 25, feedback: 'Needs deeper analysis'),
            CriterionScore(criterionName: 'Grammar', score: 12, maxScore: 15, feedback: 'Good grammar overall'),
          ],
        ),
        EssayAttempt(
          id: 'e3',
          essayTitle: 'Digital Privacy',
          score: 75,
          maxScore: 100,
          submittedAt: DateTime.now().subtract(const Duration(days: 25)),
          rubricName: 'Argumentative Essay Rubric',
          criteriaScores: const [
            CriterionScore(criterionName: 'Thesis', score: 20, maxScore: 25, feedback: 'Strong thesis statement'),
            CriterionScore(criterionName: 'Evidence', score: 26, maxScore: 35, feedback: 'Excellent use of sources'),
            CriterionScore(criterionName: 'Analysis', score: 17, maxScore: 25, feedback: 'Good critical thinking'),
            CriterionScore(criterionName: 'Grammar', score: 12, maxScore: 15, feedback: 'Minor punctuation issues'),
          ],
        ),
      ],
      strengths: const [
        PerformanceMetric(criterionName: 'Problem Solving', averageScore: 90.0, description: 'Excellent analytical skills in quizzes'),
        PerformanceMetric(criterionName: 'Evidence Use', averageScore: 85.7, description: 'Strong use of sources in essays'),
      ],
      weaknesses: const [
        PerformanceMetric(criterionName: 'Critical Analysis', averageScore: 68.3, description: 'Needs to develop deeper analytical thinking in essays'),
        PerformanceMetric(criterionName: 'Thesis Development', averageScore: 72.0, description: 'Thesis statements could be more focused'),
      ],
      activityLog: [
        ActivityLogEntry(
          id: 'a1',
          title: 'Algebra Basics Quiz',
          type: 'quiz',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          status: 'graded',
        ),
        ActivityLogEntry(
          id: 'a2',
          title: 'Impact of Technology Essay',
          type: 'essay',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          status: 'graded',
        ),
        ActivityLogEntry(
          id: 'a3',
          title: 'Geometry Fundamentals',
          type: 'quiz',
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          status: 'graded',
        ),
      ],
    );

    // Sara - Balanced performance, improving trend
    _mockData['sara'] = StudentPerformance(
      studentId: 'sara',
      studentName: 'Sara Mohamed',
      email: 'sara.mohamed@student.edu',
      avatarUrl: null,
      overallGrade: 87.2,
      totalQuizzes: 5,
      totalEssays: 3,
      averageQuizScore: 85.0,
      averageEssayScore: 90.0,
      quizAttempts: [
        QuizAttempt(
          id: 'q1',
          quizTitle: 'Algebra Basics Quiz',
          score: 17,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 2)),
          timeSpentMinutes: 28,
          questionResults: [],
        ),
        QuizAttempt(
          id: 'q2',
          quizTitle: 'Geometry Fundamentals',
          score: 18,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 7)),
          timeSpentMinutes: 32,
          questionResults: [],
        ),
        QuizAttempt(
          id: 'q3',
          quizTitle: 'Calculus Quiz 1',
          score: 16,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 14)),
          timeSpentMinutes: 30,
          questionResults: [],
        ),
        QuizAttempt(
          id: 'q4',
          quizTitle: 'Statistics Basics',
          score: 17,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 21)),
          timeSpentMinutes: 27,
          questionResults: [],
        ),
        QuizAttempt(
          id: 'q5',
          quizTitle: 'Probability Quiz',
          score: 17,
          maxScore: 20,
          submittedAt: DateTime.now().subtract(const Duration(days: 28)),
          timeSpentMinutes: 29,
          questionResults: [],
        ),
      ],
      essayAttempts: [
        EssayAttempt(
          id: 'e1',
          essayTitle: 'Impact of Technology',
          score: 92,
          maxScore: 100,
          submittedAt: DateTime.now().subtract(const Duration(days: 5)),
          rubricName: 'Argumentative Essay Rubric',
          criteriaScores: const [
            CriterionScore(criterionName: 'Thesis', score: 23, maxScore: 25, feedback: 'Excellent thesis statement'),
            CriterionScore(criterionName: 'Evidence', score: 32, maxScore: 35, feedback: 'Outstanding use of sources'),
            CriterionScore(criterionName: 'Analysis', score: 23, maxScore: 25, feedback: 'Deep critical analysis'),
            CriterionScore(criterionName: 'Grammar', score: 14, maxScore: 15, feedback: 'Excellent writing quality'),
          ],
        ),
        EssayAttempt(
          id: 'e2',
          essayTitle: 'Climate Change Essay',
          score: 88,
          maxScore: 100,
          submittedAt: DateTime.now().subtract(const Duration(days: 15)),
          rubricName: 'Argumentative Essay Rubric',
          criteriaScores: const [
            CriterionScore(criterionName: 'Thesis', score: 22, maxScore: 25, feedback: 'Strong thesis'),
            CriterionScore(criterionName: 'Evidence', score: 30, maxScore: 35, feedback: 'Well-researched evidence'),
            CriterionScore(criterionName: 'Analysis', score: 22, maxScore: 25, feedback: 'Thoughtful analysis'),
            CriterionScore(criterionName: 'Grammar', score: 14, maxScore: 15, feedback: 'Polished writing'),
          ],
        ),
        EssayAttempt(
          id: 'e3',
          essayTitle: 'Digital Privacy',
          score: 90,
          maxScore: 100,
          submittedAt: DateTime.now().subtract(const Duration(days: 25)),
          rubricName: 'Argumentative Essay Rubric',
          criteriaScores: const [
            CriterionScore(criterionName: 'Thesis', score: 23, maxScore: 25, feedback: 'Clear, focused thesis'),
            CriterionScore(criterionName: 'Evidence', score: 31, maxScore: 35, feedback: 'Comprehensive evidence'),
            CriterionScore(criterionName: 'Analysis', score: 22, maxScore: 25, feedback: 'Insightful analysis'),
            CriterionScore(criterionName: 'Grammar', score: 14, maxScore: 15, feedback: 'Excellent grammar'),
          ],
        ),
      ],
      strengths: const [
        PerformanceMetric(criterionName: 'Critical Analysis', averageScore: 89.3, description: 'Outstanding analytical and critical thinking skills'),
        PerformanceMetric(criterionName: 'Evidence Use', averageScore: 91.4, description: 'Exceptional research and source integration'),
        PerformanceMetric(criterionName: 'Thesis Development', averageScore: 90.7, description: 'Consistently strong thesis statements'),
      ],
      weaknesses: const [
        PerformanceMetric(criterionName: 'Time Management', averageScore: 75.0, description: 'Takes longer on quizzes, could improve speed'),
      ],
      activityLog: [
        ActivityLogEntry(
          id: 'a1',
          title: 'Algebra Basics Quiz',
          type: 'quiz',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          status: 'graded',
        ),
        ActivityLogEntry(
          id: 'a2',
          title: 'Impact of Technology Essay',
          type: 'essay',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          status: 'graded',
        ),
        ActivityLogEntry(
          id: 'a3',
          title: 'Geometry Fundamentals',
          type: 'quiz',
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          status: 'graded',
        ),
      ],
    );
  }

  Future<StudentPerformance?> getStudentPerformance(String studentId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockData[studentId.toLowerCase()];
  }

  Future<List<StudentPerformance>> getAllStudents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockData.values.toList();
  }
}

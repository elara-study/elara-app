import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_option.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_question.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_question_kind.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_results.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_session.dart';
import 'package:elara/features/student/quiz/domain/repositories/quiz_repository.dart';

/// Local preview data — replace with API client when backend is ready.
class MockQuizRepository implements QuizRepository {
  @override
  Future<ApiResult<QuizSession>> getSession({
    required String quizId,
    String? groupId,
    String? moduleId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ApiResult.success(
      QuizSession(
        id: quizId,
        title: 'Quiz',
        subtitle: 'Physics 101 • Kinematics',
        moduleLabel: 'MODULE 02',
        questions: [
          QuizQuestion(
            id: '${quizId}_q1',
            kind: QuizQuestionKind.mcq,
            prompt:
                'Calculate the wavelength of a photon with an energy of 3.3 x 10⁻¹⁹ Joules.',
            hintMessage: 'Hint: E = hc / λ',
            options: const [
              QuizOption(id: 'opt_a', label: '600 nm'),
              QuizOption(id: 'opt_b', label: '400 nm'),
              QuizOption(id: 'opt_c', label: '800 nm'),
              QuizOption(id: 'opt_d', label: '200 nm'),
            ],
          ),
          QuizQuestion(
            id: '${quizId}_q2',
            kind: QuizQuestionKind.written,
            prompt:
                'Explain in your own words how wave–particle duality applies to photons.',
            hintMessage:
                'Hint: Think about interference and photoelectric effect.',
            options: const [],
          ),
        ],
      ),
    );
  }

  @override
  Future<ApiResult<QuizResults>> submitAnswers({
    required String quizId,
    required List<QuizAnswerSubmission> answers,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (answers.isEmpty) {
      return ApiResult.failure(const UnknownFailure('No answers to submit'));
    }
    return ApiResult.success(
      const QuizResults(
        scorePercent: 90,
        correctCount: 18,
        totalCount: 20,
        unansweredCount: 1,
        wrongCount: 1,
        celebrationSubtitle: 'You’ve mastered the Kinematics!',
        xpEarned: 250,
        totalScoreXp: 1250,
        level: 11,
        levelProgress: 0.72,
        streakDays: 7,
        insightMessage:
            'You’re struggling with Position and Displacement concept.',
      ),
    );
  }
}

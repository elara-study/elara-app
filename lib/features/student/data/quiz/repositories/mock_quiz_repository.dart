import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/answer_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_hint.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_option.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_question.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_question_kind.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

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
        celebrationSubtitle: 'You\u2019ve mastered the Kinematics!',
        xpEarned: 250,
        totalScoreXp: 1250,
        level: 11,
        levelProgress: 0.72,
        streakDays: 7,
        insightMessage:
            'You\u2019re struggling with Position and Displacement concept.',
      ),
    );
  }

  // ── Live API stubs (not used in mock flow) ─────────────────────────────────

  @override
  Future<ApiResult<QuizSession>> generateQuiz({
    required String groupId,
    required String moduleId,
    required int questionCount,
    required String difficultyLevel,
    required List<String> questionTypes,
  }) async {
    return ApiResult.failure(
      const UnknownFailure('generateQuiz not implemented in mock'),
    );
  }

  @override
  Future<ApiResult<QuizHint>> getHint({
    required int sessionId,
    required int questionNumber,
  }) async {
    return ApiResult.failure(
      const UnknownFailure('getHint not implemented in mock'),
    );
  }

  @override
  Future<ApiResult<AnswerResult>> submitAnswer({
    required int sessionId,
    required int questionNumber,
    required String questionType,
    String? selectedOptionText,
    String? answerContent,
    required bool hintUsed,
  }) async {
    return ApiResult.failure(
      const UnknownFailure('submitAnswer not implemented in mock'),
    );
  }

  @override
  Future<ApiResult<QuizResults>> completeQuiz(int sessionId) async {
    return ApiResult.failure(
      const UnknownFailure('completeQuiz not implemented in mock'),
    );
  }
}

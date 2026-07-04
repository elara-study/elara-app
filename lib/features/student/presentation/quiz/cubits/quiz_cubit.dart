import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/student/domain/quiz/entities/answer_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_hint.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_question.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_question_kind.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';
import 'package:elara/features/student/domain/quiz/usecases/complete_quiz_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/generate_quiz_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/get_hint_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/get_quiz_session_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/submit_answer_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/submit_quiz_answers_use_case.dart';
import 'package:elara/features/student/presentation/rewards/cubits/rewards_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quiz_state.dart';

/// Orchestrates the full quiz lifecycle:
/// generate → per-question (hint, answer) → complete.
///
/// Legacy [loadSession] / [advanceOrSubmit] flow is preserved for the demo route.
class QuizCubit extends Cubit<QuizState> {
  QuizCubit({
    required GetQuizSessionUseCase getQuizSessionUseCase,
    required SubmitQuizAnswersUseCase submitQuizAnswersUseCase,
    required GenerateQuizUseCase generateQuizUseCase,
    required GetHintUseCase getHintUseCase,
    required SubmitAnswerUseCase submitAnswerUseCase,
    required CompleteQuizUseCase completeQuizUseCase,
  }) : _getQuizSessionUseCase = getQuizSessionUseCase,
       _submitQuizAnswersUseCase = submitQuizAnswersUseCase,
       _generateQuizUseCase = generateQuizUseCase,
       _getHintUseCase = getHintUseCase,
       _submitAnswerUseCase = submitAnswerUseCase,
       _completeQuizUseCase = completeQuizUseCase,
       super(const QuizState.initial());

  final GetQuizSessionUseCase _getQuizSessionUseCase;
  final SubmitQuizAnswersUseCase _submitQuizAnswersUseCase;
  final GenerateQuizUseCase _generateQuizUseCase;
  final GetHintUseCase _getHintUseCase;
  final SubmitAnswerUseCase _submitAnswerUseCase;
  final CompleteQuizUseCase _completeQuizUseCase;

  DateTime? _quizStartTime;

  // Live API flow

  /// Generates a new quiz session from the backend.
  Future<void> generateQuiz({
    required String groupId,
    required String moduleId,
    required String difficultyLevel,
    required int questionCount,
  }) async {
    emit(const QuizState.generating());
    final result = await _generateQuizUseCase(
      groupId: groupId,
      moduleId: moduleId,
      questionCount: questionCount,
      difficultyLevel: difficultyLevel,
      questionTypes: const ['MCQ', 'Essay'],
    );
    result.fold(
      onSuccess: (session) {
        _quizStartTime = DateTime.now();
        emit(
          QuizState.inProgress(
            session: session,
            currentQuestionIndex: 0,
            mcqSelectionByQuestionId: const {},
            writtenTextByQuestionId: const {},
          ),
        );
      },
      onFailure: (f) => emit(QuizState.failure(f.message)),
    );
  }

  /// Fetches a hint for the given question number in the active session.
  Future<void> getHint({
    required int sessionId,
    required int questionNumber,
  }) async {
    final result = await _getHintUseCase(
      sessionId: sessionId,
      questionNumber: questionNumber,
    );
    result.fold(
      onSuccess: (hint) => emit(state.copyWith(
        status: QuizStatus.hintLoaded,
        hint: hint,
      )),
      onFailure: (f) => emit(QuizState.failure(f.message)),
    );
  }

  /// Submits a single answer and emits [QuizStatus.answerSubmitted] with feedback.
  Future<void> submitAnswer({
    required int sessionId,
    required int questionNumber,
    required String questionType,
    String? selectedOptionText,
    String? answerContent,
    required bool hintUsed,
  }) async {
    emit(state.copyWith(status: QuizStatus.submitting));
    final result = await _submitAnswerUseCase(
      sessionId: sessionId,
      questionNumber: questionNumber,
      questionType: questionType,
      selectedOptionText: selectedOptionText,
      answerContent: answerContent,
      hintUsed: hintUsed,
    );
    result.fold(
      onSuccess: (answerResult) {
        final q = _currentQuestion;
        final nextResults = Map<String, AnswerResult>.from(
          state.answerResultsByQuestionId,
        );
        if (q != null) {
          nextResults[q.id] = answerResult;
        }
        
        emit(
          state.copyWith(
            status: QuizStatus.answerSubmitted,
            answerResult: answerResult,
            answerResultsByQuestionId: nextResults,
          ),
        );
      },
      onFailure: (f) => emit(QuizState.failure(f.message)),
    );
  }

  /// Completes the quiz session and emits [QuizStatus.completed] with results.
  Future<void> completeQuiz(int sessionId) async {
    emit(state.copyWith(status: QuizStatus.submitting));
    final result = await _completeQuizUseCase(sessionId);
    result.fold(
      onSuccess: (results) {
        final elapsedSeconds = _quizStartTime != null
            ? DateTime.now().difference(_quizStartTime!).inSeconds
            : 0;
        getIt<RewardsCubit>().completeActivity(
          xpGained: results.xpEarned,
          quizAccuracy: results.scorePercent.toDouble(),
          subject: state.session?.moduleLabel,
          practiceSeconds: elapsedSeconds,
        );
        emit(
          QuizState.completed(
            session: state.session!,
            results: results,
            mcqSelectionByQuestionId: state.mcqSelectionByQuestionId,
            writtenTextByQuestionId: state.writtenTextByQuestionId,
            answerResultsByQuestionId: state.answerResultsByQuestionId,
          ),
        );
      },
      onFailure: (f) => emit(QuizState.failure(f.message)),
    );
  }

  // Legacy demo flow (mock-compatible)

  String? _quizId;
  String? _groupId;
  String? _moduleId;

  Future<void> retry() async {
    final id = _quizId;
    if (id == null) return;
    await loadSession(quizId: id, groupId: _groupId, moduleId: _moduleId);
  }

  Future<void> loadSession({
    required String quizId,
    String? groupId,
    String? moduleId,
  }) async {
    _quizId = quizId;
    _groupId = groupId;
    _moduleId = moduleId;
    emit(const QuizState.loading());
    final result = await _getQuizSessionUseCase(
      quizId: quizId,
      groupId: groupId,
      moduleId: moduleId,
    );
    result.fold(
      onSuccess: (session) {
        _quizStartTime = DateTime.now();
        emit(
          QuizState.inProgress(
            session: session,
            currentQuestionIndex: 0,
            mcqSelectionByQuestionId: const {},
            writtenTextByQuestionId: const {},
          ),
        );
      },
      onFailure: (f) => emit(QuizState.failure(f.message)),
    );
  }

  QuizQuestion? get _currentQuestion {
    final s = state.session;
    final i = state.currentQuestionIndex;
    if (s == null || i < 0 || i >= s.questions.length) return null;
    return s.questions[i];
  }

  void selectMcqOption(String optionId) {
    final q = _currentQuestion;
    if (q == null || q.kind != QuizQuestionKind.mcq) return;
    final next = Map<String, String>.from(state.mcqSelectionByQuestionId)
      ..[q.id] = optionId;
    emit(state.copyWith(mcqSelectionByQuestionId: next));
  }

  void updateWrittenAnswer(String text) {
    final q = _currentQuestion;
    if (q == null || q.kind != QuizQuestionKind.written) return;
    final next = Map<String, String>.from(state.writtenTextByQuestionId)
      ..[q.id] = text;
    emit(state.copyWith(writtenTextByQuestionId: next));
  }

  String? writtenAnswerForCurrentQuestion() {
    final q = _currentQuestion;
    if (q == null) return null;
    return state.writtenTextByQuestionId[q.id];
  }

  bool get canAdvanceCurrentQuestion {
    final q = _currentQuestion;
    final session = state.session;
    if (q == null || session == null) return false;
    if (q.kind == QuizQuestionKind.mcq) {
      return state.mcqSelectionByQuestionId.containsKey(q.id);
    }
    final text = state.writtenTextByQuestionId[q.id]?.trim() ?? '';
    return text.isNotEmpty;
  }

  bool get isLastQuestion {
    final session = state.session;
    final q = _currentQuestion;
    if (session == null || q == null) return false;
    return state.currentQuestionIndex >= session.questions.length - 1;
  }

  /// Starts the review mode, showing the user's answers and feedback.
  void startReview() {
    emit(
      state.copyWith(
        status: QuizStatus.reviewing,
        currentQuestionIndex: 0,
      ),
    );
  }

  /// Moves to the next question.
  /// If in review mode and on the last question, finishes review and returns to completed state.
  void advanceQuestion() {
    if (isLastQuestion) {
      if (state.status == QuizStatus.reviewing) {
        // Finish review
        emit(state.copyWith(status: QuizStatus.completed));
      }
    } else {
      emit(
        state.copyWith(
          status: state.status == QuizStatus.reviewing 
              ? QuizStatus.reviewing 
              : QuizStatus.inProgress,
          currentQuestionIndex: state.currentQuestionIndex + 1,
        ),
      );
    }
  }

  /// Moves to the previous question if not on the first question.
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      emit(
        state.copyWith(
          status: state.status == QuizStatus.reviewing 
              ? QuizStatus.reviewing 
              : QuizStatus.inProgress,
          currentQuestionIndex: state.currentQuestionIndex - 1,
        ),
      );
    }
  }

  /// Next step: move to following question or submit when on the last one.
  Future<void> advanceOrSubmit() async {
    if (!canAdvanceCurrentQuestion) return;
    if (!isLastQuestion) {
      emit(
        state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1),
      );
      return;
    }
    await _submit();
  }

  Future<void> _submit() async {
    final session = state.session;
    if (session == null) return;

    final snapshot = state;
    emit(state.copyWith(status: QuizStatus.submitting));

    final answers = <QuizAnswerSubmission>[];
    for (final q in session.questions) {
      if (q.kind == QuizQuestionKind.mcq) {
        final optionId = state.mcqSelectionByQuestionId[q.id];
        if (optionId != null) {
          answers.add(
            QuizAnswerSubmission(questionId: q.id, selectedOptionId: optionId),
          );
        }
      } else {
        final text = state.writtenTextByQuestionId[q.id]?.trim();
        if (text != null && text.isNotEmpty) {
          answers.add(
            QuizAnswerSubmission(questionId: q.id, writtenText: text),
          );
        }
      }
    }

    final result = await _submitQuizAnswersUseCase(
      quizId: session.id,
      answers: answers,
    );

    result.fold(
      onSuccess: (r) {
        final elapsedSeconds = _quizStartTime != null
            ? DateTime.now().difference(_quizStartTime!).inSeconds
            : 0;
        getIt<RewardsCubit>().completeActivity(
          xpGained: r.xpEarned,
          quizAccuracy: r.scorePercent.toDouble(),
          subject: session.moduleLabel,
          practiceSeconds: elapsedSeconds,
        );
        emit(
          QuizState.completed(
            session: session,
            results: r,
            mcqSelectionByQuestionId: snapshot.mcqSelectionByQuestionId,
            writtenTextByQuestionId: snapshot.writtenTextByQuestionId,
            answerResultsByQuestionId: snapshot.answerResultsByQuestionId,
          ),
        );
      },
      onFailure: (f) => emit(snapshot),
    );
  }
}

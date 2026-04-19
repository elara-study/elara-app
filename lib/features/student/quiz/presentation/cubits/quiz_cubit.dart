import 'package:elara/features/student/quiz/domain/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_question.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_question_kind.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_results.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_session.dart';
import 'package:elara/features/student/quiz/domain/usecases/get_quiz_session_use_case.dart';
import 'package:elara/features/student/quiz/domain/usecases/submit_quiz_answers_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quiz_state.dart';

/// Orchestrates load → per-question answers → submit. UI reads [QuizState] only.
class QuizCubit extends Cubit<QuizState> {
  QuizCubit({
    required GetQuizSessionUseCase getQuizSessionUseCase,
    required SubmitQuizAnswersUseCase submitQuizAnswersUseCase,
  })  : _getQuizSessionUseCase = getQuizSessionUseCase,
        _submitQuizAnswersUseCase = submitQuizAnswersUseCase,
        super(const QuizState.initial());

  final GetQuizSessionUseCase _getQuizSessionUseCase;
  final SubmitQuizAnswersUseCase _submitQuizAnswersUseCase;

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

  /// Next step: move to following question or submit when on the last one.
  Future<void> advanceOrSubmit() async {
    if (!canAdvanceCurrentQuestion) return;
    if (!isLastQuestion) {
      emit(state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      ));
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
          answers.add(QuizAnswerSubmission(questionId: q.id, writtenText: text));
        }
      }
    }

    final result = await _submitQuizAnswersUseCase(
      quizId: session.id,
      answers: answers,
    );

    result.fold(
      onSuccess: (r) => emit(QuizState.completed(session: session, results: r)),
      onFailure: (f) => emit(snapshot),
    );
  }
}

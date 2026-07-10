part of 'quiz_cubit.dart';

enum QuizStatus {
  initial,
  loading,
  generating,
  inProgress,
  submitting,
  hintLoaded,
  answerSubmitted,
  completed,
  reviewing,
  failure,
}

class QuizState extends Equatable {
  const QuizState._({
    required this.status,
    this.session,
    this.currentQuestionIndex = 0,
    this.mcqSelectionByQuestionId = const {},
    this.writtenTextByQuestionId = const {},
    this.answerResultsByQuestionId = const {},
    this.results,
    this.hint,
    this.answerResult,
    this.message,
  });

  const QuizState.initial() : this._(status: QuizStatus.initial);

  const QuizState.loading() : this._(status: QuizStatus.loading);

  const QuizState.generating() : this._(status: QuizStatus.generating);

  const QuizState.inProgress({
    required QuizSession session,
    required int currentQuestionIndex,
    required Map<String, String> mcqSelectionByQuestionId,
    required Map<String, String> writtenTextByQuestionId,
  }) : this._(
         status: QuizStatus.inProgress,
         session: session,
         currentQuestionIndex: currentQuestionIndex,
         mcqSelectionByQuestionId: mcqSelectionByQuestionId,
         writtenTextByQuestionId: writtenTextByQuestionId,
         answerResultsByQuestionId: const {},
       );

  const QuizState.completed({
    required QuizSession session,
    required QuizResults results,
    required Map<String, String> mcqSelectionByQuestionId,
    required Map<String, String> writtenTextByQuestionId,
    required Map<String, AnswerResult> answerResultsByQuestionId,
  }) : this._(
         status: QuizStatus.completed,
         session: session,
         results: results,
         mcqSelectionByQuestionId: mcqSelectionByQuestionId,
         writtenTextByQuestionId: writtenTextByQuestionId,
         answerResultsByQuestionId: answerResultsByQuestionId,
       );

  const QuizState.failure(String message)
    : this._(status: QuizStatus.failure, message: message);

  final QuizStatus status;
  final QuizSession? session;
  final int currentQuestionIndex;
  final Map<String, String> mcqSelectionByQuestionId;
  final Map<String, String> writtenTextByQuestionId;
  final Map<String, AnswerResult> answerResultsByQuestionId;
  final QuizResults? results;

  /// Set when state is [QuizStatus.hintLoaded].
  final QuizHint? hint;

  /// Set when state is [QuizStatus.answerSubmitted].
  final AnswerResult? answerResult;

  final String? message;

  QuizState copyWith({
    QuizStatus? status,
    QuizSession? session,
    int? currentQuestionIndex,
    Map<String, String>? mcqSelectionByQuestionId,
    Map<String, String>? writtenTextByQuestionId,
    Map<String, AnswerResult>? answerResultsByQuestionId,
    QuizResults? results,
    QuizHint? hint,
    AnswerResult? answerResult,
    String? message,
  }) {
    return QuizState._(
      status: status ?? this.status,
      session: session ?? this.session,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      mcqSelectionByQuestionId:
          mcqSelectionByQuestionId ?? this.mcqSelectionByQuestionId,
      writtenTextByQuestionId:
          writtenTextByQuestionId ?? this.writtenTextByQuestionId,
      answerResultsByQuestionId:
          answerResultsByQuestionId ?? this.answerResultsByQuestionId,
      results: results ?? this.results,
      hint: hint ?? this.hint,
      answerResult: answerResult ?? this.answerResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    session,
    currentQuestionIndex,
    mcqSelectionByQuestionId,
    writtenTextByQuestionId,
    answerResultsByQuestionId,
    results,
    hint,
    answerResult,
    message,
  ];
}

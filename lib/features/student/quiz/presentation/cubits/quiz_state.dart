part of 'quiz_cubit.dart';

enum QuizStatus { initial, loading, inProgress, submitting, completed, failure }

class QuizState extends Equatable {
  const QuizState._({
    required this.status,
    this.session,
    this.currentQuestionIndex = 0,
    this.mcqSelectionByQuestionId = const {},
    this.writtenTextByQuestionId = const {},
    this.results,
    this.message,
  });

  const QuizState.initial() : this._(status: QuizStatus.initial);

  const QuizState.loading() : this._(status: QuizStatus.loading);

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
       );

  const QuizState.completed({
    required QuizSession session,
    required QuizResults results,
  }) : this._(
         status: QuizStatus.completed,
         session: session,
         results: results,
       );

  const QuizState.failure(String message)
    : this._(status: QuizStatus.failure, message: message);

  final QuizStatus status;
  final QuizSession? session;
  final int currentQuestionIndex;
  final Map<String, String> mcqSelectionByQuestionId;
  final Map<String, String> writtenTextByQuestionId;
  final QuizResults? results;
  final String? message;

  QuizState copyWith({
    QuizStatus? status,
    QuizSession? session,
    int? currentQuestionIndex,
    Map<String, String>? mcqSelectionByQuestionId,
    Map<String, String>? writtenTextByQuestionId,
    QuizResults? results,
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
      results: results ?? this.results,
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
    results,
    message,
  ];
}

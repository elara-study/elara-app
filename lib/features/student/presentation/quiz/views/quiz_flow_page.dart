import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/features/student/presentation/quiz/cubits/quiz_cubit.dart';
import 'package:elara/features/student/presentation/quiz/quiz_route_args.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_difficulty_sheet.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_load_error_view.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_results_body.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_session_body.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Quiz route: provides [QuizCubit], shows the difficulty sheet on first load,
/// then maps cubit state to UI.
///
/// When [lessonId] is provided the live API flow is used;
/// otherwise falls back to the legacy mock [quizId] flow.
class QuizFlowPage extends StatefulWidget {
  const QuizFlowPage({
    super.key,
    required this.quizId,
    this.lessonId,
    this.groupId,
    this.moduleId,
  });

  final String quizId;
  final int? lessonId;
  final String? groupId;
  final String? moduleId;

  factory QuizFlowPage.fromArgs(QuizRouteArgs args) {
    return QuizFlowPage(
      quizId: args.quizId,
      lessonId: args.lessonId,
      groupId: args.groupId,
      moduleId: args.moduleId,
    );
  }

  @override
  State<QuizFlowPage> createState() => _QuizFlowPageState();
}

class _QuizFlowPageState extends State<QuizFlowPage> {
  late final QuizCubit _cubit;
  bool _difficultySheetShown = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<QuizCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _showDifficultySheetIfNeeded(BuildContext context) async {
    if (_difficultySheetShown) return;
    _difficultySheetShown = true;

    final groupId = widget.groupId;
    final moduleId = widget.moduleId;

    if (groupId == null || moduleId == null) {
      // Legacy mock flow — load immediately without difficulty selection.
      _cubit.loadSession(
        quizId: widget.quizId,
        groupId: groupId,
        moduleId: moduleId,
      );
      return;
    }

    // Live API flow — ask the student to pick difficulty + question count.
    final settings = await showDifficultySheet(context);
    if (!context.mounted) return;

    if (settings == null) {
      // User dismissed — go back.
      Navigator.of(context).maybePop();
      return;
    }

    _cubit.generateQuiz(
      groupId: groupId,
      moduleId: moduleId,
      difficultyLevel: settings.difficultyLevel,
      questionCount: settings.questionCount,
    );
  }

  void _onAnswerSubmitted(BuildContext context, QuizState state) {
    final result = state.answerResult;
    if (result == null) return;

    // Small delay to allow the button ripple/animation to complete
    // before instantly jumping to the next screen.
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;
      final cubit = context.read<QuizCubit>();
      
      if (cubit.isLastQuestion) {
        final sessionId = int.tryParse(cubit.state.session?.id ?? '') ?? 0;
        cubit.completeQuiz(sessionId);
      } else {
        cubit.advanceQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<QuizCubit, QuizState>(
        listenWhen: (p, c) =>
            c.status == QuizStatus.failure ||
            c.status == QuizStatus.hintLoaded ||
            c.status == QuizStatus.answerSubmitted,
        listener: (context, state) {
          switch (state.status) {
            case QuizStatus.failure:
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? context.l10n.commonSomethingWentWrong),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
               AppSnackBar.error(context, state.message ?? 'Something went wrong');
             case QuizStatus.hintLoaded:
              final hint = state.hint;
              if (hint != null) {
                AppSnackBar.info(
                  context,
                  hint.content,
                  duration: const Duration(seconds: 5),
                );
              }
            case QuizStatus.answerSubmitted:
              _onAnswerSubmitted(context, state);
            default:
              break;
          }
        },
        builder: (context, state) {
          // Show difficulty sheet once when initial state is reached.
          if (state.status == QuizStatus.initial) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _showDifficultySheetIfNeeded(context),
            );
            return const Scaffold(
              body: Center(child: SizedBox.shrink()),
            );
          }

          return switch (state.status) {
            QuizStatus.loading ||
            QuizStatus.generating => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            QuizStatus.failure => QuizLoadErrorView(
              message: state.message ?? context.l10n.commonSomethingWentWrong,
              onRetry: () => context.read<QuizCubit>().retry(),
            ),
            QuizStatus.inProgress ||
            QuizStatus.submitting ||
            QuizStatus.hintLoaded ||
            QuizStatus.answerSubmitted ||
            QuizStatus.reviewing => QuizSessionBody(state: state),
            QuizStatus.completed => QuizResultsBody(state: state),
            QuizStatus.initial => const Scaffold(
              body: Center(child: SizedBox.shrink()),
            ),
          };
        },
      ),
    );
  }
}

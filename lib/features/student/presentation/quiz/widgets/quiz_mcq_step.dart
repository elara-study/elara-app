import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_question.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';
import 'package:elara/features/student/presentation/quiz/cubits/quiz_cubit.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_footer_actions.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_hint_sheet.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_mcq_option_tile.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_session_layout.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_leave_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizMcqStep extends StatelessWidget {
  const QuizMcqStep({super.key, required this.session, required this.question});

  final QuizSession session;
  final QuizQuestion question;

  void _showHint(BuildContext context) {
    final hint = question.hintMessage;
    if (hint == null || hint.isEmpty) return;
    showHintSheet(context, hint);
  }

  void _onSubmit(BuildContext context, QuizCubit cubit, QuizState state) {
    final selectedId = state.mcqSelectionByQuestionId[question.id];
    final selectedLabel = question.options
        .firstWhere(
          (o) => o.id == selectedId,
          orElse: () => question.options.first,
        )
        .label;
    final sessionId = int.tryParse(session.id) ?? 0;
    cubit.submitAnswer(
      sessionId: sessionId,
      questionNumber: state.currentQuestionIndex + 1,
      questionType: 'MCQ',
      selectedOptionText: selectedLabel,
      hintUsed: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (p, c) =>
          p.mcqSelectionByQuestionId != c.mcqSelectionByQuestionId ||
          p.currentQuestionIndex != c.currentQuestionIndex ||
          p.status != c.status ||
          p.answerResult != c.answerResult,
      builder: (context, state) {
        final cubit = context.read<QuizCubit>();
        final selectedId = state.mcqSelectionByQuestionId[question.id];
        final submitting = state.status == QuizStatus.submitting || state.status == QuizStatus.answerSubmitted;
        final isReviewing = state.status == QuizStatus.reviewing;

        final primaryLabel = isReviewing 
            ? (cubit.isLastQuestion ? 'Finish Review' : 'Next')
            : (cubit.isLastQuestion ? 'Submit' : 'Next Question');
        
        final primaryEnabled = isReviewing || (cubit.canAdvanceCurrentQuestion && !submitting);

        return QuizSessionLayout(
          quizTitle: session.title,
          quizSubtitle: session.subtitle,
          moduleLabel: session.moduleLabel,
          pointsLabel: question.pointsLabel,
          currentQuestion: state.currentQuestionIndex + 1,
          totalQuestions: session.effectiveTotal,
          progressSegmentTotal: session.questions.length,
          questionText: question.prompt,
          onHint: (question.hintMessage == null || question.hintMessage!.isEmpty) 
              ? null 
              : () => _showHint(context),
          answerArea: Column(
            children: [
              for (var i = 0; i < question.options.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.spacingMd),
                _buildOptionTile(
                  context: context,
                  cubit: cubit,
                  state: state,
                  index: i,
                  selectedId: selectedId,
                  isReviewing: isReviewing,
                ),
              ],
            ],
          ),
          footer: QuizFooterActions(
            secondaryLabel: state.currentQuestionIndex > 0 ? 'Prev' : 'Leave',
            onSecondary: () {
              if (state.currentQuestionIndex > 0) {
                cubit.previousQuestion();
              } else {
                showQuizLeaveDialog(context, quizTitle: session.title);
              }
            },
            primaryLabel: primaryLabel,
            primaryEnabled: primaryEnabled,
            onPrimary: isReviewing 
                ? () => cubit.advanceQuestion()
                : () => _onSubmit(context, cubit, state),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required QuizCubit cubit,
    required QuizState state,
    required int index,
    required String? selectedId,
    required bool isReviewing,
  }) {
    final option = question.options[index];
    final isSelected = selectedId == option.id;
    final result = state.answerResultsByQuestionId[question.id];

    McqOptionFeedback feedback = McqOptionFeedback.none;
    if (isReviewing && result != null) {
      final correctText = result.correctAnswerText;
      final isCorrectOption = option.label == correctText;

      if (isSelected) {
        feedback = result.isCorrect
            ? McqOptionFeedback.correct
            : McqOptionFeedback.wrong;
      } else if (isCorrectOption && !result.isCorrect) {
        feedback = McqOptionFeedback.correctUnselected;
      }
    }

    return QuizMcqOptionTile(
      label: option.label,
      selected: isSelected,
      feedback: feedback,
      onTap: isReviewing ? () {} : () => cubit.selectMcqOption(option.id),
    );
  }
}

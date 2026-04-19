import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_question.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_session.dart';
import 'package:elara/features/student/quiz/presentation/cubits/quiz_cubit.dart';
import 'package:elara/shared/widgets/quiz/quiz_footer_actions.dart';
import 'package:elara/shared/widgets/quiz/quiz_mcq_option_tile.dart';
import 'package:elara/shared/widgets/quiz/quiz_session_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizMcqStep extends StatelessWidget {
  const QuizMcqStep({
    super.key,
    required this.session,
    required this.question,
  });

  final QuizSession session;
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (p, c) =>
          p.mcqSelectionByQuestionId != c.mcqSelectionByQuestionId ||
          p.currentQuestionIndex != c.currentQuestionIndex ||
          p.status != c.status,
      builder: (context, state) {
        final cubit = context.read<QuizCubit>();
        final selectedId = state.mcqSelectionByQuestionId[question.id];
        final submitting = state.status == QuizStatus.submitting;
        return QuizSessionLayout(
          quizTitle: session.title,
          quizSubtitle: session.subtitle,
          moduleLabel: session.moduleLabel,
          pointsLabel: question.pointsLabel,
          currentQuestion: state.currentQuestionIndex + 1,
          totalQuestions: session.effectiveTotal,
          progressSegmentTotal: session.questions.length,
          questionText: question.prompt,
          onHint: question.hintMessage == null
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(question.hintMessage!)),
                  );
                },
          answerArea: Column(
            children: [
              for (var i = 0; i < question.options.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.spacingMd),
                QuizMcqOptionTile(
                  label: question.options[i].label,
                  selected: selectedId == question.options[i].id,
                  onTap: () => cubit.selectMcqOption(question.options[i].id),
                ),
              ],
            ],
          ),
          footer: QuizFooterActions(
            onLeave: () => Navigator.of(context).maybePop(),
            primaryLabel: cubit.isLastQuestion ? 'Submit' : 'Next Question',
            primaryEnabled: cubit.canAdvanceCurrentQuestion && !submitting,
            onPrimary: () => cubit.advanceOrSubmit(),
          ),
        );
      },
    );
  }
}

import 'package:elara/features/student/domain/quiz/entities/quiz_question.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';
import 'package:elara/features/student/presentation/quiz/cubits/quiz_cubit.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_footer_actions.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_hint_sheet.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_leave_dialog.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_session_layout.dart';
import 'package:elara/features/student/presentation/quiz/widgets/quiz_written_field.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizWrittenStep extends StatefulWidget {
  const QuizWrittenStep({
    super.key,
    required this.session,
    required this.question,
  });

  final QuizSession session;
  final QuizQuestion question;

  @override
  State<QuizWrittenStep> createState() => _QuizWrittenStepState();
}

class _QuizWrittenStepState extends State<QuizWrittenStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<QuizCubit>();
    _controller = TextEditingController(
      text: cubit.writtenAnswerForCurrentQuestion() ?? '',
    );
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(QuizWrittenStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      final cubit = context.read<QuizCubit>();
      _controller.text = cubit.writtenAnswerForCurrentQuestion() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    context.read<QuizCubit>().updateWrittenAnswer(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizCubit>();
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (p, c) =>
          p.writtenTextByQuestionId != c.writtenTextByQuestionId ||
          p.currentQuestionIndex != c.currentQuestionIndex ||
          p.status != c.status ||
          p.answerResult != c.answerResult,
      builder: (context, state) {
        final submitting = state.status == QuizStatus.submitting || state.status == QuizStatus.answerSubmitted;
        final isReviewing = state.status == QuizStatus.reviewing;
        final result = state.answerResultsByQuestionId[widget.question.id];

        final primaryLabel = isReviewing 
            ? (cubit.isLastQuestion ? 'Finish Review' : 'Next')
            : (cubit.isLastQuestion ? 'Submit' : 'Next Question');
        
        final primaryEnabled = isReviewing || (cubit.canAdvanceCurrentQuestion && !submitting);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: QuizSessionLayout(
            quizTitle: widget.session.title,
            quizSubtitle: widget.session.subtitle,
            moduleLabel: widget.session.moduleLabel,
            pointsLabel: widget.question.pointsLabel,
            currentQuestion: state.currentQuestionIndex + 1,
            totalQuestions: widget.session.effectiveTotal,
            progressSegmentTotal: widget.session.questions.length,
            questionText: widget.question.prompt,
            onHint: (widget.question.hintMessage == null || widget.question.hintMessage!.isEmpty) 
                ? null 
                : () {
                    final hint = widget.question.hintMessage;
                    if (hint != null && hint.isNotEmpty) {
                      showHintSheet(context, hint);
                    }
                  },
            answerArea: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                QuizWrittenField(
                  key: ValueKey(widget.question.id),
                  controller: _controller,
                  readOnly: isReviewing,
                ),
                if (isReviewing && result != null) ...[
                  const SizedBox(height: AppSpacing.spacingMd),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.spacingMd),
                    decoration: BoxDecoration(
                      color: result.isCorrect 
                          ? AppColors.success500.withValues(alpha: 0.1)
                          : AppColors.error500.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                      border: Border.all(
                        color: result.isCorrect 
                            ? AppColors.success500 
                            : AppColors.error500,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          result.isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: result.isCorrect ? AppColors.success500 : AppColors.error500,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.spacingSm),
                        Expanded(
                          child: Text(
                            result.isCorrect 
                                ? 'Correct!' 
                                : 'Incorrect. Correct Answer: ${result.correctAnswerText}',
                            style: AppTypography.labelMedium(
                              color: result.isCorrect ? AppColors.success500 : AppColors.error500,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  showQuizLeaveDialog(context, quizTitle: widget.session.title);
                }
              },
              primaryLabel: primaryLabel,
              primaryEnabled: primaryEnabled,
              onPrimary: isReviewing
                  ? () => cubit.advanceQuestion()
                  : () {
                      final sessionId = int.tryParse(widget.session.id) ?? 0;
                      cubit.submitAnswer(
                        sessionId: sessionId,
                        questionNumber: state.currentQuestionIndex + 1,
                        questionType: 'Essay',
                        answerContent: cubit.writtenAnswerForCurrentQuestion(),
                        hintUsed: false,
                      );
                    },
            ),
          ),
        ); // GestureDetector
      },
    );
  }
}

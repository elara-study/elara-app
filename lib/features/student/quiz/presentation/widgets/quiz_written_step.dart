import 'package:elara/features/student/quiz/domain/entities/quiz_question.dart';
import 'package:elara/features/student/quiz/domain/entities/quiz_session.dart';
import 'package:elara/features/student/quiz/presentation/cubits/quiz_cubit.dart';
import 'package:elara/shared/widgets/quiz/quiz_footer_actions.dart';
import 'package:elara/shared/widgets/quiz/quiz_session_layout.dart';
import 'package:elara/shared/widgets/quiz/quiz_written_field.dart';
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
    final initial = context.read<QuizCubit>().state
            .writtenTextByQuestionId[widget.question.id] ??
        '';
    _controller = TextEditingController(text: initial);
    _controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant QuizWrittenStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      final text = context.read<QuizCubit>().state
              .writtenTextByQuestionId[widget.question.id] ??
          '';
      _controller.removeListener(_onChanged);
      _controller.text = text;
      _controller.addListener(_onChanged);
    }
  }

  void _onChanged() {
    context.read<QuizCubit>().updateWrittenAnswer(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizCubit>();
    return BlocBuilder<QuizCubit, QuizState>(
      buildWhen: (p, c) =>
          p.writtenTextByQuestionId != c.writtenTextByQuestionId ||
          p.currentQuestionIndex != c.currentQuestionIndex ||
          p.status != c.status,
      builder: (context, state) {
        final submitting = state.status == QuizStatus.submitting;
        return QuizSessionLayout(
          quizTitle: widget.session.title,
          quizSubtitle: widget.session.subtitle,
          moduleLabel: widget.session.moduleLabel,
          pointsLabel: widget.question.pointsLabel,
          currentQuestion: state.currentQuestionIndex + 1,
          totalQuestions: widget.session.effectiveTotal,
          progressSegmentTotal: widget.session.questions.length,
          questionText: widget.question.prompt,
          onHint: widget.question.hintMessage == null
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(widget.question.hintMessage!)),
                  );
                },
          answerArea: QuizWrittenField(
            key: ValueKey(widget.question.id),
            controller: _controller,
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

import 'package:elara/features/student/quiz/domain/entities/quiz_question_kind.dart';
import 'package:elara/features/student/quiz/presentation/cubits/quiz_cubit.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_mcq_step.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_written_step.dart';
import 'package:flutter/material.dart';

/// Picks MCQ vs written UI and shows a blocking overlay while submitting.
class QuizSessionBody extends StatelessWidget {
  const QuizSessionBody({super.key, required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final session = state.session!;
    final question = session.questions[state.currentQuestionIndex];
    final submitting = state.status == QuizStatus.submitting;

    final body = switch (question.kind) {
      QuizQuestionKind.mcq => QuizMcqStep(
          session: session,
          question: question,
        ),
      QuizQuestionKind.written => QuizWrittenStep(
          session: session,
          question: question,
        ),
    };

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: submitting,
          child: body,
        ),
        if (submitting)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

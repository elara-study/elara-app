import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/shared/widgets/quiz/quiz_frosted_app_bar.dart';
import 'package:elara/shared/widgets/quiz/quiz_progress_block.dart';
import 'package:elara/shared/widgets/quiz/quiz_question_card.dart';
import 'package:flutter/material.dart';

/// Shared shell for MCQ and written quiz steps: app bar, progress, question card, answer slot, footer.
class QuizSessionLayout extends StatelessWidget {
  const QuizSessionLayout({
    super.key,
    required this.quizTitle,
    required this.quizSubtitle,
    required this.moduleLabel,
    required this.currentQuestion,
    required this.totalQuestions,
    this.progressSegmentTotal,
    required this.questionText,
    required this.answerArea,
    required this.footer,
    this.pointsLabel = '+10',
    this.onBack,
    this.onHint,
  });

  final String quizTitle;
  final String quizSubtitle;
  final String moduleLabel;
  final int currentQuestion;
  final int totalQuestions;
  /// See [QuizProgressBlock.progressSegmentTotal].
  final int? progressSegmentTotal;
  final String questionText;
  final Widget answerArea;
  final Widget footer;
  final String pointsLabel;
  final VoidCallback? onBack;
  final VoidCallback? onHint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuizFrostedAppBar(
            title: quizTitle,
            subtitle: quizSubtitle,
            onBack: onBack,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacingLg,
                AppSpacing.spacing2xl,
                AppSpacing.spacingLg,
                AppSpacing.spacing2xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuizProgressBlock(
                    moduleLabel: moduleLabel,
                    currentQuestion: currentQuestion,
                    totalQuestions: totalQuestions,
                    progressSegmentTotal: progressSegmentTotal,
                  ),
                  const SizedBox(height: AppSpacing.spacing2xl),
                  QuizQuestionCard(
                    questionText: questionText,
                    pointsLabel: pointsLabel,
                    onHint: onHint,
                  ),
                  const SizedBox(height: AppSpacing.spacing2xl),
                  answerArea,
                  const SizedBox(height: AppSpacing.spacing2xl),
                  footer,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

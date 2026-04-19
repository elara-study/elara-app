import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/quiz/presentation/cubits/quiz_cubit.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_results_accuracy_card.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_results_hero.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_results_insight_card.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_results_reward_card.dart';
import 'package:elara/shared/widgets/quiz/quiz_frosted_app_bar.dart';
import 'package:flutter/material.dart';

class QuizResultsBody extends StatelessWidget {
  const QuizResultsBody({super.key, required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final session = state.session!;
    final results = state.results!;

    final celebration =
        results.celebrationSubtitle ??
        'Great work — keep building your streak.';
    final insight = results.insightMessage ?? results.caption;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuizFrostedAppBar(
            title: session.title,
            subtitle: session.subtitle,
            showBackButton: false,
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
                  QuizResultsHero(celebrationSubtitle: celebration),
                  const SizedBox(height: AppSpacing.spacing2xl),
                  QuizResultsRewardCard(
                    xpEarned: results.xpEarned,
                    totalScoreXp: results.totalScoreXp,
                    level: results.level,
                    levelProgress: results.levelProgress,
                    streakDays: results.streakDays,
                  ),
                  const SizedBox(height: AppSpacing.spacing2xl),
                  QuizResultsAccuracyCard(
                    accuracyPercent: results.scorePercent,
                    correctCount: results.correctCount,
                    unansweredCount: results.unansweredCount,
                    wrongCount: results.wrongCount,
                  ),
                  const SizedBox(height: AppSpacing.spacing2xl),
                  QuizResultsInsightCard(message: insight),
                  const SizedBox(height: AppSpacing.spacing2xl),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        (route) =>
                            route.settings.name == AppRoutes.studentGroup ||
                            route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonColors.primaryDefault,
                      foregroundColor: ButtonColors.primaryText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingLg,
                        vertical: AppSpacing.spacingSm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppRadius.radiusFull,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Back to Roadmap',
                          style: AppTypography.labelLarge(
                            color: ButtonColors.primaryText,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spacingSm),
                        const Icon(Icons.map_rounded, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:equatable/equatable.dart';

/// Server payload after quiz submit — maps to [Quiz - Results](https://www.figma.com/design/vAUbpSk5HoQBA0yUt6S8Rj/Elara?node-id=1097-5373).
class QuizResults extends Equatable {
  const QuizResults({
    required this.scorePercent,
    required this.correctCount,
    required this.totalCount,
    this.celebrationSubtitle,
    this.xpEarned = 0,
    this.totalScoreXp = 0,
    this.level = 1,
    /// 0–1 progress within current level (level-up bar).
    this.levelProgress = 0,
    this.streakDays = 0,
    this.unansweredCount = 0,
    this.wrongCount = 0,
    this.insightMessage,
    this.caption = 'Keep practicing to improve your streak.',
  });

  final int scorePercent;
  final int correctCount;
  final int totalCount;

  /// e.g. "You've mastered the Kinematics!"
  final String? celebrationSubtitle;

  final int xpEarned;
  final int totalScoreXp;
  final int level;

  /// 0.0–1.0
  final double levelProgress;
  final int streakDays;
  final int unansweredCount;
  final int wrongCount;

  /// ELARA INSIGHT body copy.
  final String? insightMessage;

  /// Legacy fallback line (if [insightMessage] is null).
  final String caption;

  String get scorePercentLabel => '$scorePercent%';

  String get correctLabel => '$correctCount of $totalCount correct';

  @override
  List<Object?> get props => [
        scorePercent,
        correctCount,
        totalCount,
        celebrationSubtitle,
        xpEarned,
        totalScoreXp,
        level,
        levelProgress,
        streakDays,
        unansweredCount,
        wrongCount,
        insightMessage,
        caption,
      ];
}

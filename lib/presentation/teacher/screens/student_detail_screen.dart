import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/domain/models/student_performance.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/teacher/bloc/student_detail_bloc.dart';
import 'package:elara/presentation/teacher/bloc/student_detail_event.dart';
import 'package:elara/presentation/teacher/bloc/student_detail_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elara/core/localization/student_detail_translations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentDetailBloc>()..add(LoadStudentDetails(studentId)),
      child: Scaffold(
        appBar: AppAppBar.detail(title: 'teacher.studentInsights'.tr),
        body: BlocBuilder<StudentDetailBloc, StudentDetailState>(
          builder: (context, state) {
            if (state is StudentDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else             if (state is StudentDetailError) {
              return Center(child: Text('${'common.error'.tr}: ${state.message}'));
            } else if (state is StudentDetailLoaded) {
              return _StudentDetailContent(performance: state.performance);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _StudentDetailContent extends StatelessWidget {
  final StudentPerformance performance;

  const _StudentDetailContent({required this.performance});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          _buildHeader(),
          TabBar(
            tabs: [
              Tab(text: 'teacher.overview'.tr),
              Tab(text: 'teacher.quizzesTab'.tr),
              Tab(text: 'teacher.essaysTab'.tr),
              Tab(text: 'teacher.analysis'.tr),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOverviewTab(),
                _buildQuizzesTab(),
                _buildEssaysTab(),
                _buildAnalysisTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue[100],
            child: Text(
              performance.studentName.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSpacing.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(performance.studentName, style: AppTypography.h5()),
                Text(performance.email, style: AppTypography.bodyMedium()),
                const SizedBox(height: AppSpacing.spacingSm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getGradeColor(performance.overallGrade),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${'teacher.overall'.tr}: ${performance.overallGrade.toStringAsFixed(1)}% (${_getGradeLetter(performance.overallGrade)})',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('teacher.totalQuizzes'.tr, performance.totalQuizzes.toString(), Icons.quiz)),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(child: _buildStatCard('teacher.totalEssays'.tr, performance.totalEssays.toString(), Icons.article)),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          Row(
            children: [
              Expanded(child: _buildStatCard('teacher.quizAvg'.tr, '${performance.averageQuizScore.toStringAsFixed(1)}%', Icons.analytics)),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(child: _buildStatCard('teacher.essayAvg'.tr, '${performance.averageEssayScore.toStringAsFixed(1)}%', Icons.analytics_outlined)),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingXl),
          Text('teacher.recentActivity'.tr, style: AppTypography.h6()),
          const SizedBox(height: AppSpacing.spacingMd),
          ...performance.activityLog.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildQuizzesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      itemCount: performance.quizAttempts.length,
      itemBuilder: (context, index) {
        final quiz = performance.quizAttempts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getGradeColor(quiz.percentage),
              child: Text(
                '${quiz.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            title: Text(StudentDetailTranslations.translate(quiz.quizTitle), style: AppTypography.labelLarge()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${'teacher.score'.tr}: ${quiz.score}/${quiz.maxScore}'),
                Text('${'teacher.time'.tr}: ${quiz.timeSpentMinutes} ${'teacher.min'.tr} • ${DateFormat('MMM d, y', Get.locale?.languageCode ?? 'en').format(quiz.submittedAt)}'),
              ],
            ),
            isThreeLine: true,
            trailing: quiz.questionResults.isNotEmpty
                ? const Icon(Icons.chevron_right)
                : null,
            onTap: quiz.questionResults.isNotEmpty
                ? () => _showQuizDetails(context, quiz)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildEssaysTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      itemCount: performance.essayAttempts.length,
      itemBuilder: (context, index) {
        final essay = performance.essayAttempts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: _getGradeColor(essay.percentage),
              child: Text(
                '${essay.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            title: Text(StudentDetailTranslations.translate(essay.essayTitle), style: AppTypography.labelLarge()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${'teacher.score'.tr}: ${essay.score}/${essay.maxScore}'),
                Text('${'teacher.rubric'.tr}: ${StudentDetailTranslations.translate(essay.rubricName)}'),
                Text(DateFormat('MMM d, y', Get.locale?.languageCode ?? 'en').format(essay.submittedAt)),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('${'teacher.criteriaBreakdown'.tr}:', style: AppTypography.h6()),
                    const SizedBox(height: AppSpacing.spacingSm),
                    ...essay.criteriaScores.map((cs) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.spacingSm),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(StudentDetailTranslations.translate(cs.criterionName)),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: cs.score / cs.maxScore,
                                            backgroundColor: Colors.grey[200],
                                            color: _getGradeColor((cs.score / cs.maxScore) * 100),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('${cs.score}/${cs.maxScore}'),
                                      ],
                                    ),
                                    Text(StudentDetailTranslations.translate(cs.feedback), style: AppTypography.bodySmall()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('teacher.performanceTrend'.tr, style: AppTypography.h6()),
          const SizedBox(height: AppSpacing.spacingMd),
          SizedBox(
            height: 200,
            child: _buildPerformanceChart(),
          ),
          const SizedBox(height: AppSpacing.spacingXl),
          Text('teacher.strengths'.tr, style: AppTypography.h6()),
          const SizedBox(height: AppSpacing.spacingMd),
          ...performance.strengths.map((s) => _buildMetricCard(s, Colors.green)),
          const SizedBox(height: AppSpacing.spacingXl),
          Text('teacher.areasForImprovement'.tr, style: AppTypography.h6()),
          const SizedBox(height: AppSpacing.spacingMd),
          ...performance.weaknesses.map((w) => _buildMetricCard(w, Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingMd),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(value, style: AppTypography.h5()),
            Text(label, style: AppTypography.bodySmall()),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(ActivityLogEntry activity) {
    return ListTile(
      leading: Icon(
        activity.type == 'quiz' ? Icons.quiz : Icons.article,
        color: activity.status == 'graded' ? Colors.green : Colors.orange,
      ),
      title: Text(StudentDetailTranslations.translate(activity.title)),
      subtitle: Text('${StudentDetailTranslations.translate(activity.type)} • ${DateFormat('MMM d, h:mm a', Get.locale?.languageCode ?? 'en').format(activity.timestamp)}'),
      trailing: Chip(
        label: Text(StudentDetailTranslations.translate(activity.status)),
        backgroundColor: activity.status == 'graded' ? Colors.green[50] : Colors.orange[50],
      ),
    );
  }

  Widget _buildMetricCard(PerformanceMetric metric, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingMd),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${metric.averageScore.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(StudentDetailTranslations.translate(metric.criterionName), style: AppTypography.labelLarge()),
                  Text(StudentDetailTranslations.translate(metric.description), style: AppTypography.bodySmall()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    final allScores = [
      ...performance.quizAttempts.map((q) => q.percentage),
      ...performance.essayAttempts.map((e) => e.percentage),
    ];

    if (allScores.isEmpty) {
      return Center(child: Text('teacher.noDataAvailable'.tr));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}%', style: const TextStyle(fontSize: 10)),
            ),
          ),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              allScores.length,
              (i) => FlSpot(i.toDouble(), allScores[i]),
            ),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }

  String _getGradeLetter(double percentage) {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  void _showQuizDetails(BuildContext context, QuizAttempt quiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(StudentDetailTranslations.translate(quiz.quizTitle)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: quiz.questionResults.map((qr) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      qr.isCorrect ? Icons.check_circle : Icons.cancel,
                      color: qr.isCorrect ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(qr.questionText)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.close'.tr),
          ),
        ],
      ),
    );
  }
}

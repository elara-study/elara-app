import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/domain/models/rubric.dart';
import 'package:elara/domain/repositories/rubric_repository.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/presentation/teacher/bloc/essay_grading_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EssayGradingScreen extends StatefulWidget {
  final Rubric? rubric;

  const EssayGradingScreen({super.key, this.rubric});

  @override
  State<EssayGradingScreen> createState() => _EssayGradingScreenState();
}

class _EssayGradingScreenState extends State<EssayGradingScreen> {
  final TextEditingController _essayController = TextEditingController();
  List<Rubric> _rubrics = [];
  Rubric? _selectedRubric;
  bool _isLoadingRubrics = true;

  @override
  void initState() {
    super.initState();
    _loadRubrics();
  }

  Future<void> _loadRubrics() async {
    final repository = getIt<RubricRepository>();
    final rubrics = await repository.getRubrics();
    
    if (mounted) {
      setState(() {
        _rubrics = rubrics;
        if (widget.rubric != null) {
           _selectedRubric = widget.rubric;
        } else if (_rubrics.isNotEmpty) {
          _selectedRubric = _rubrics.first;
        }
        _isLoadingRubrics = false;
      });
    }
  }

  @override
  void dispose() {
    _essayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EssayGradingBloc>(),
      child: Scaffold(
        appBar: AppAppBar.detail(title: 'AI Essay Grader'),
        body: BlocBuilder<EssayGradingBloc, EssayGradingState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state is! EssayGradingSuccess) ...[
                      if (_isLoadingRubrics)
                         const Center(child: LinearProgressIndicator())
                      else if (_rubrics.isEmpty)
                         Text('No rubrics found. Create one first.', style: AppTypography.bodyLarge().copyWith(color: Colors.red))
                      else
                        DropdownButtonFormField<Rubric>(
                          decoration: const InputDecoration(labelText: 'Select Rubric'),
                          value: _selectedRubric,
                          items: _rubrics.map((r) => DropdownMenuItem(value: r, child: Text(r.title))).toList(),
                          onChanged: (val) => setState(() => _selectedRubric = val),
                        ),
                      const SizedBox(height: AppSpacing.spacingMd),
                      TextField(
                        controller: _essayController,
                        decoration: const InputDecoration(
                          labelText: 'Paste Student Essay',
                          hintText: 'Paste the essay content here...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 10,
                        enabled: state is! EssayGradingLoading,
                      ),
                      const SizedBox(height: AppSpacing.spacingLg),
                      if (state is EssayGradingLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        AppPrimaryButton(
                          text: 'Grade Essay with AI',
                          icon: Icons.analytics,
                          onPressed: (_selectedRubric == null) ? null : () {
                            if (_essayController.text.length < 50) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Essay looks too short. Please add more content.',
                                  ),
                                ),
                              );
                              return;
                            }
                            context.read<EssayGradingBloc>().add(
                              GradeEssayRequested(
                                essayContent: _essayController.text,
                                rubric: _selectedRubric!,
                              ),
                            );
                          },
                        ),
                    ],
                    if (state is EssayGradingSuccess) ...[
                      _buildResults(context, state),
                      const SizedBox(height: AppSpacing.spacingLg),
                      AppSecondaryButton(
                        text: 'Grade Another Essay',
                        onPressed: () {
                          // Reset state (simple way is to just pop and push, or add ResetEvent)
                          // Here we just use Navigator for simplicity or implement ResetEvent
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EssayGradingScreen(rubric: _selectedRubric),
                            ),
                          );
                        },
                      ),
                    ],
                    if (state is EssayGradingFailure)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.spacingLg,
                        ),
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context, EssayGradingSuccess state) {
    final result = state.result;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Overall Score',
                style: AppTypography.labelLarge().copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '${result.totalScore.toStringAsFixed(1)} / 4.0',
                style: AppTypography.h3().copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingXs),
              Text(result.overallFeedback),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spacingLg),
        Text('Detailed Breakdown', style: AppTypography.h6()),
        const SizedBox(height: AppSpacing.spacingMd),
        ...result.criterionScores.map((score) {
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          score.criterionTitle,
                          style: AppTypography.h6(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: score.score >= 3
                              ? Colors.green[100]
                              : Colors.amber[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${score.score}/4',
                          style: AppTypography.labelLarge(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  Text(score.feedback, style: AppTypography.bodyMedium()),
                  if (score.quote != null) ...[
                    const SizedBox(height: AppSpacing.spacingSm),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border(
                          left: BorderSide(color: Colors.grey, width: 4),
                        ),
                      ),
                      child: Text(
                        '"${score.quote}"',
                        style: AppTypography.bodySmall().copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/presentation/teacher/bloc/quiz_generation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Create quiz with AI + options for number, type, difficulty.
class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _titleController = TextEditingController();
  final _topicController = TextEditingController();
  int _questionCount = 10;
  String _questionType = 'Mixed';
  String _difficulty = 'Medium';

  @override
  void dispose() {
    _titleController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Scaffold(
      appBar: AppAppBar.detail(title: 'Create Quiz', showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Quiz title',
                  hintText: 'e.g. Chapter 5 Quiz',
=======
    return BlocProvider(
      create: (context) => getIt<QuizGenerationBloc>(),
      child: Scaffold(
        appBar: AppAppBar.detail(title: 'Create Quiz'),
        body: BlocConsumer<QuizGenerationBloc, QuizGenerationState>(
          listener: (context, state) {
            if (state is QuizGenerationSuccess) {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.teacherQuizEditor, arguments: state.quiz);
            } else if (state is QuizGenerationFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
            }
          },
          builder: (context, state) {
            final isLoading = state is QuizGenerationLoading;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.spacing2xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Quiz title',
                        hintText: 'e.g. Chapter 5 Quiz',
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.spacingLg),
                    TextField(
                      controller: _topicController,
                      decoration: const InputDecoration(
                        labelText: 'Topic / Subject',
                        hintText: 'What should the quiz cover?',
                      ),
                      maxLines: 2,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.spacing2xl),
                    Text('Generate with AI', style: AppTypography.h6()),
                    const SizedBox(height: AppSpacing.spacingMd),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Number of Questions',
                      ),
                      value: _questionCount,
                      items: [5, 10, 15, 20]
                          .map(
                            (n) =>
                                DropdownMenuItem(value: n, child: Text('$n')),
                          )
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (v) => setState(() => _questionCount = v!),
                    ),
                    const SizedBox(height: AppSpacing.spacingLg),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Question Type',
                      ),
                      value: _questionType,
                      items: ['MCQ only', 'Written only', 'Mixed']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (v) => setState(() => _questionType = v!),
                    ),
                    const SizedBox(height: AppSpacing.spacingLg),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                      ),
                      value: _difficulty,
                      items: ['Easy', 'Medium', 'Hard']
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (v) => setState(() => _difficulty = v!),
                    ),
                    const SizedBox(height: AppSpacing.spacing2xl),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      AppPrimaryButton(
                        text: 'Generate Questions with AI',
                        icon: Icons.auto_awesome,
                        onPressed: () {
                          if (_topicController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a topic'),
                              ),
                            );
                            return;
                          }
                          context.read<QuizGenerationBloc>().add(
                            GenerateQuizRequested(
                              topic: _topicController.text,
                              count: _questionCount,
                              difficulty: _difficulty,
                              type: _questionType,
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: AppSpacing.spacingLg),
                    TextButton.icon(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.teacherRubricBuilder),
                      icon: const Icon(Icons.playlist_add),
                      label: const Text('Create Custom Rubric'),
                    ),
                    const SizedBox(height: AppSpacing.spacingMd),
                    TextButton.icon(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.teacherEssayGrading),
                      icon: const Icon(Icons.analytics),
                      label: const Text('AI Essay Grading'),
                    ),
                  ],
>>>>>>> Stashed changes
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

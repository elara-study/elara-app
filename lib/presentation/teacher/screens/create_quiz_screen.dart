import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/presentation/teacher/bloc/quiz_generation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
    return BlocProvider(
      create: (context) => getIt<QuizGenerationBloc>(),
      child: Scaffold(
        appBar: AppAppBar.detail(title: 'teacher.createQuiz'.tr),
        body: BlocConsumer<QuizGenerationBloc, QuizGenerationState>(
          listener: (context, state) {
            if (state is QuizGenerationSuccess) {
              Navigator.of(context).pushNamed(
                AppRoutes.teacherQuizEditor,
                arguments: state.quiz,
              );
            } else if (state is QuizGenerationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
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
                      decoration: InputDecoration(
                        labelText: 'teacher.quizTitle'.tr,
                        hintText: 'teacher.quizTitleHint'.tr,
                      ),
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.spacingLg),
                    TextField(
                      controller: _topicController,
                      decoration: InputDecoration(
                        labelText: 'teacher.topicSubject'.tr,
                        hintText: 'teacher.topicHint'.tr,
                      ),
                      maxLines: 2,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.spacing2xl),
                    Text('teacher.generateWithAi'.tr, style: AppTypography.h6()),
                    const SizedBox(height: AppSpacing.spacingMd),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'teacher.numberOfQuestions'.tr,
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
                      decoration: InputDecoration(
                        labelText: 'teacher.questionType'.tr,
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
                      decoration: InputDecoration(
                        labelText: 'teacher.difficulty'.tr,
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
                        text: 'teacher.generateQuestions'.tr,
                        icon: Icons.auto_awesome,
                        onPressed: () {
                          if (_topicController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('teacher.enterTopic'.tr),
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
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRoutes.teacherRubricBuilder),
                      icon: const Icon(Icons.playlist_add),
                      label: Text('teacher.createCustomRubric'.tr),
                    ),
                    const SizedBox(height: AppSpacing.spacingMd),
                    TextButton.icon(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRoutes.teacherEssayGrading),
                      icon: const Icon(Icons.analytics),
                      label: Text('teacher.aiEssayGrading'.tr),
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
}

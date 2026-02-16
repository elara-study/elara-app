import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/domain/models/question.dart';
import 'package:elara/domain/models/quiz.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

class QuizEditorScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizEditorScreen({super.key, required this.quiz});

  @override
  State<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends State<QuizEditorScreen> {
  late Quiz _quiz;

  @override
  void initState() {
    super.initState();
    _quiz = widget.quiz;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'Edit Quiz: ${_quiz.title}'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.spacingLg),
                itemCount: _quiz.questions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.spacingLg),
                itemBuilder: (context, index) {
                  final question = _quiz.questions[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.spacingMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Q${index + 1}', style: AppTypography.h6()),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editQuestion(index),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.spacingSm),
                          Text(question.text, style: AppTypography.bodyLarge()),
                          if (question.options != null) ...[
                            const SizedBox(height: AppSpacing.spacingMd),
                            ...question.options!.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.spacingXs,
                                ),
                                child: Row(
                                  children: [
                                    Radio<int>(
                                      value: entry.key,
                                      groupValue: question.correctOptionIndex,
                                      onChanged: (val) {
                                        setState(() {
                                          final updatedQuestion = question
                                              .copyWith(
                                                correctOptionIndex: val,
                                              );
                                          final updatedQuestions =
                                              List<Question>.from(
                                                _quiz.questions,
                                              )..[index] = updatedQuestion;
                                          _quiz = _quiz.copyWith(
                                            questions: updatedQuestions,
                                          );
                                        });
                                      },
                                    ),
                                    Expanded(child: Text(entry.value)),
                                  ],
                                ),
                              );
                            }),
                          ],
                          if (question.gradingCriteria != null) ...[
                            const SizedBox(height: AppSpacing.spacingMd),
                            Text(
                              'Grading Criteria:',
                              style: AppTypography.labelMedium(),
                            ),
                            Text(
                              question.gradingCriteria!,
                              style: AppTypography.bodyMedium(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.spacingLg),
              child: AppPrimaryButton(text: 'Save Quiz', onPressed: _saveQuiz),
            ),
          ],
        ),
      ),
    );
  }

  void _editQuestion(int index) {
    final question = _quiz.questions[index];
    final controller = TextEditingController(text: question.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Question'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Question Text'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final updatedQuestion = question.copyWith(
                    text: controller.text,
                  );
                  final updatedQuestions = List<Question>.from(_quiz.questions)
                    ..[index] = updatedQuestion;
                  _quiz = _quiz.copyWith(questions: updatedQuestions);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveQuiz() {
    // TODO: Implement actual persistence (e.g., save to Hive or DB)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Quiz Saved Successfully!')));
    // Navigate back to the previous screen (CreateQuizScreen)
    Navigator.of(context).pop();
  }
}

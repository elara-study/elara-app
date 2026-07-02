import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_student_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_insight_manual_sheet.dart';

/// Manual insight form overlay dialog for editing an existing insight.
Future<void> showEditInsightManualSheet(
  BuildContext context, {
  required String studentName,
  required TeacherStudentInsightEntity initialInsight,
}) {
  final profileCubit = context.read<TeacherStudentProfileCubit>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => BlocProvider.value(
      value: profileCubit,
      child: EditInsightManualDialog(
        studentName: studentName,
        initialInsight: initialInsight,
        parentContext: context,
      ),
    ),
  );
}

class EditInsightManualDialog extends StatelessWidget {
  const EditInsightManualDialog({
    super.key,
    required this.studentName,
    required this.initialInsight,
    required this.parentContext,
  });

  final String studentName;
  final TeacherStudentInsightEntity initialInsight;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    // Collect the existing paragraph texts to pre-populate the Cubit
    final initialParagraphs = <String>[];
    if (initialInsight.paragraph1.isNotEmpty) {
      initialParagraphs.add(initialInsight.paragraph1);
    }
    if (initialInsight.paragraph2.isNotEmpty) {
      initialParagraphs.add(initialInsight.paragraph2);
    }

    return BlocProvider(
      create: (_) => InsightFormCubit(initialParagraphs: initialParagraphs),
      child: Builder(
        builder: (dialogContext) {
          return InsightFormDialogShell(
            title: 'Edit Insight',
            submitButtonLabel: 'Save Changes',
            onSubmit: () {
              final paragraphs = dialogContext
                  .read<InsightFormCubit>()
                  .state
                  .map((c) => c.text.trim())
                  .toList();
              dialogContext.read<TeacherStudentProfileCubit>().saveInsight(
                paragraphs,
              );
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(content: Text('Insight updated successfully')),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:elara/core/localization/localization_extension.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_student_profile_cubit.dart';
import 'package:elara/shared/widgets/app_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Cubit to manage the dynamic list of TextEditingControllers for the insight form.
class InsightFormCubit extends Cubit<List<TextEditingController>> {
  InsightFormCubit({List<String>? initialParagraphs}) : super([]) {
    if (initialParagraphs != null && initialParagraphs.isNotEmpty) {
      for (final p in initialParagraphs) {
        state.add(TextEditingController(text: p));
      }
    } else {
      state.add(TextEditingController());
    }
  }

  void addField() {
    final updated = List<TextEditingController>.from(state)
      ..add(TextEditingController());
    emit(updated);
  }

  void notifyChanged() {
    emit(List<TextEditingController>.from(state));
  }

  bool get canSubmit =>
      state.any((controller) => controller.text.trim().isNotEmpty);

  @override
  Future<void> close() {
    for (final controller in state) {
      controller.dispose();
    }
    return super.close();
  }
}

/// Shared stateless dialog shell layout for adding/editing manual insights.
class InsightFormDialogShell extends StatelessWidget {
  const InsightFormDialogShell({
    super.key,
    required this.title,
    required this.submitButtonLabel,
    required this.onSubmit,
  });

  final String title;
  final String submitButtonLabel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final controllers = context.watch<InsightFormCubit>().state;
    final cubit = context.read<InsightFormCubit>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.spacingLg.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    title,
                    style: AppTypography.h4(
                      color: cs.onSurface,
                    ).copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  AppFormDialogCloseButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.spacingLg.h),

              // Scrollable container for text fields to avoid screen overflow
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 280.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(controllers.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == controllers.length - 1 ? 0 : 12.h,
                        ),
                        child: AppFormDialogTextField(
                          controller: controllers[index],
                          hintText: context.l10n.teacherEnterReport,
                          maxLines: 4,
                          onChanged: (_) => cubit.notifyChanged(),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Add text field plus button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_rounded,
                      color: AppColors.brandPrimary500,
                      size: 20.sp,
                    ),
                    onPressed: cubit.addField,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spacingMd.h),

              // Save button
              AppFormDialogPrimaryButton(
                label: submitButtonLabel,
                onPressed: cubit.canSubmit ? onSubmit : () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Manual insight form overlay dialog (Figma 1417:8100) for adding a new insight.
Future<void> showAddInsightManualSheet(
  BuildContext context, {
  required String studentName,
}) {
  final profileCubit = context.read<TeacherStudentProfileCubit>();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => BlocProvider.value(
      value: profileCubit,
      child: AddInsightManualDialog(
        studentName: studentName,
        parentContext: context,
      ),
    ),
  );
}

class AddInsightManualDialog extends StatelessWidget {
  const AddInsightManualDialog({
    super.key,
    required this.studentName,
    required this.parentContext,
  });

  final String studentName;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsightFormCubit(),
      child: Builder(
        builder: (dialogContext) {
          return InsightFormDialogShell(
            title: context.l10n.teacherAddInsightTitle,
            submitButtonLabel: context.l10n.teacherSaveInsight,
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
                SnackBar(content: Text(context.l10n.teacherInsightSavedDraft)),
              );
            },
          );
        },
      ),
    );
  }
}

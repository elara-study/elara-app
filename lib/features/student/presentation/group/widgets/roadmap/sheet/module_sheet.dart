import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/features/student/presentation/chatbot/chatbot_route_args.dart';
import 'package:elara/features/student/presentation/quiz/quiz_route_args.dart';
import 'package:elara/features/student/presentation/homework/homework_route_args.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/presentation/group/widgets/roadmap/sheet/module_outline_row.dart';
import 'package:elara/features/student/presentation/group/widgets/roadmap/sheet/module_outline_tile.dart';
import 'package:elara/features/student/presentation/group/widgets/roadmap/sheet/module_primary_tile.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_module_route_args.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';

/// Opens the module interaction bottom sheet (Figma: Interaction Options).
Future<void> showModuleSheet(
  BuildContext context, {
  required String moduleTitle,
  String? groupId,
  String? moduleId,
  int? lessonId,
  String? subject,
}) {
  final theme = Theme.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.radiusLg),
      ),
    ),
    builder: (ctx) => ModuleSheet(
      moduleTitle: moduleTitle,
      groupId: groupId,
      moduleId: moduleId,
      lessonId: lessonId,
      subject: subject,
    ),
  );
}

/// Body: header, quiz/homework tiles, chat, resources.
class ModuleSheet extends StatelessWidget {
  final String moduleTitle;
  final String? groupId;
  final String? moduleId;
  final int? lessonId;
  final String? subject;

  const ModuleSheet({
    super.key,
    required this.moduleTitle,
    this.groupId,
    this.moduleId,
    this.lessonId,
    this.subject,
  });

  void _pop(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cs = theme.colorScheme;

    final titleStyle = textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w800,
    );
    final subtitleStyle = textTheme.bodySmall;
    final optionLabelStyle = textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 16,
      height: 24 / 16,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacingLg,
        AppSpacing.spacingSm,
        AppSpacing.spacingLg,
        AppSpacing.spacingLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(context.l10n.roadmapInteractionOptions, style: titleStyle)),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                onPressed: () => _pop(context),
                style: IconButton.styleFrom(foregroundColor: cs.onSurface),
              ),
            ],
          ),
          Text(moduleTitle, style: subtitleStyle),
          const SizedBox(height: AppSpacing.spacingLg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ModuleOutlineTile(
                  icon: Icons.quiz_outlined,
                  label: context.l10n.roadmapTakeAQuiz,
                  labelStyle: optionLabelStyle?.copyWith(
                    color: ButtonColors.outlineText,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    AppNavigation.pushNamed(
                      context,
                      AppRoutes.quiz,
                      arguments: QuizRouteArgs(
                        quizId: 'demo-quiz',
                        lessonId: lessonId,
                        groupId: groupId,
                        moduleId: moduleId,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(
                child: ModuleOutlineTile(
                  icon: Icons.assignment_outlined,
                  label: context.l10n.homeworkTitle,
                  labelStyle: optionLabelStyle?.copyWith(
                    color: ButtonColors.outlineText,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    AppNavigation.pushNamed(
                      context,
                      AppRoutes.homework,
                      arguments: HomeworkRouteArgs(
                        homeworkId: 'demo-homework',
                        groupId: groupId,
                        moduleId: moduleId,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          ModulePrimaryTile(
            label: context.l10n.roadmapChatWithElara,
            foreground: cs.onPrimary,
            labelStyle: optionLabelStyle?.copyWith(color: cs.onPrimary),
            background: cs.primary,
            onTap: () {
              Navigator.of(context).pop();
              AppNavigation.pushNamed(
                context,
                AppRoutes.chatbot,
                arguments: ChatbotRouteArgs(
                  sessionTitle: moduleTitle,
                  startNew: true,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          ModuleOutlineRow(
            label: context.l10n.resourcesTitle,
            labelStyle: optionLabelStyle?.copyWith(
              color: ButtonColors.outlineText,
            ),
            onTap: () {
              Navigator.of(context).pop();
              AppNavigation.pushNamed(
                context,
                AppRoutes.studentModuleResources,
                arguments: TeacherModuleRouteArgs(
                  moduleId: moduleId ?? '',
                  moduleTitle: moduleTitle,
                  moduleLabel: context.l10n.commonModule.toUpperCase(),
                  groupId: groupId ?? '',
                  subject: subject ?? '',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

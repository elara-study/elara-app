import 'package:elara/config/routes.dart';
import 'package:elara/features/student/quiz/presentation/quiz_route_args.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/sheet/module_outline_row.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/sheet/module_outline_tile.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/sheet/module_primary_tile.dart';
import 'package:flutter/material.dart';

/// Opens the module interaction bottom sheet (Figma: Interaction Options).
Future<void> showModuleSheet(
  BuildContext context, {
  required String moduleTitle,
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
    builder: (ctx) => ModuleSheet(moduleTitle: moduleTitle),
  );
}

/// Body: header, quiz/homework tiles, chat, resources.
class ModuleSheet extends StatelessWidget {
  final String moduleTitle;

  const ModuleSheet({super.key, required this.moduleTitle});

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
              Expanded(
                child: Text(
                  'Interaction Options',
                  style: titleStyle,
                ),
              ),
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
                  label: 'Take a Quiz',
                  labelStyle: optionLabelStyle?.copyWith(
                    color: ButtonColors.outlineText,
                  ),
                  onTap: () {
                    final nav = Navigator.of(context);
                    nav.pop();
                    nav.pushNamed(
                      AppRoutes.quiz,
                      arguments: const QuizRouteArgs(quizId: 'demo-quiz'),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(
                child: ModuleOutlineTile(
                  icon: Icons.assignment_outlined,
                  label: 'Homework',
                  labelStyle: optionLabelStyle?.copyWith(
                    color: ButtonColors.outlineText,
                  ),
                  onTap: () => _pop(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          ModulePrimaryTile(
            label: 'Chat with elara',
            foreground: cs.onPrimary,
            labelStyle: optionLabelStyle?.copyWith(color: cs.onPrimary),
            background: cs.primary,
            onTap: () => _pop(context),
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          ModuleOutlineRow(
            label: 'Resources',
            labelStyle: optionLabelStyle?.copyWith(
              color: ButtonColors.outlineText,
            ),
            onTap: () => _pop(context),
          ),
        ],
      ),
    );
  }
}

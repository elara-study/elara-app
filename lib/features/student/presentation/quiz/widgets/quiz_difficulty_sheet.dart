import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Result returned by [showDifficultySheet].
class QuizSettings {
  const QuizSettings({
    required this.difficultyLevel,
    required this.questionCount,
  });

  final String difficultyLevel;
  final int questionCount;
}

/// Shows a bottom sheet where the student picks difficulty and question count.
/// Returns [QuizSettings] or null if dismissed.
Future<QuizSettings?> showDifficultySheet(BuildContext context) {
  final theme = Theme.of(context);
  return showModalBottomSheet<QuizSettings>(
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
    builder: (_) => const _DifficultySheet(),
  );
}

// Data

class _DifficultyOption {
  const _DifficultyOption({required this.label, required this.value});
  final String label;
  final String value;
}

const _difficultyOptions = [
  _DifficultyOption(label: 'Easy', value: 'Easy'),
  _DifficultyOption(label: 'Medium', value: 'Medium'),
  _DifficultyOption(label: 'Hard', value: 'Hard'),
];

const _countOptions = [5, 10, 15, 20];

// Sheet

class _DifficultySheet extends StatefulWidget {
  const _DifficultySheet();

  @override
  State<_DifficultySheet> createState() => _DifficultySheetState();
}

class _DifficultySheetState extends State<_DifficultySheet> {
  String? _selectedDifficulty;
  int _selectedCount = 10; // sensible default

  bool get _canStart => _selectedDifficulty != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w800,
    );
    final subtitleStyle = Theme.of(context).textTheme.bodySmall;
    final optionLabelStyle = Theme.of(context).textTheme.headlineSmall
        ?.copyWith(fontWeight: FontWeight.w800, fontSize: 16, height: 24 / 16);
    final sectionLabelStyle = AppTypography.labelSmall(
      color: cs.onSurfaceVariant,
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
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text('Quiz Settings', style: titleStyle)),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(foregroundColor: cs.onSurface),
              ),
            ],
          ),
          Text('Customise your quiz before you start', style: subtitleStyle),
          const SizedBox(height: AppSpacing.spacingLg),

          // Difficulty
          Text('DIFFICULTY', style: sectionLabelStyle),
          const SizedBox(height: AppSpacing.spacingSm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _difficultyOptions.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.spacingMd),
                Expanded(
                  child: _DifficultyTile(
                    option: _difficultyOptions[i],
                    selected: _selectedDifficulty == _difficultyOptions[i].value,
                    labelStyle: optionLabelStyle,
                    onTap: () => setState(
                      () => _selectedDifficulty = _difficultyOptions[i].value,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.spacingLg),

          // Question Count
          Text('NUMBER OF QUESTIONS', style: sectionLabelStyle),
          const SizedBox(height: AppSpacing.spacingSm),
          Row(
            children: [
              for (var i = 0; i < _countOptions.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.spacingMd),
                Expanded(
                  child: _CountChip(
                    count: _countOptions[i],
                    selected: _selectedCount == _countOptions[i],
                    labelStyle: optionLabelStyle,
                    onTap: () =>
                        setState(() => _selectedCount = _countOptions[i]),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.spacingLg),

          // Start Quiz
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              boxShadow: _canStart ? AppShadows.elevation(brightness) : [],
            ),
            child: Material(
              color: _canStart
                  ? ButtonColors.primaryDefault
                  : ButtonColors.primaryDefault.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _canStart
                    ? () => Navigator.of(context).pop(
                          QuizSettings(
                            difficultyLevel: _selectedDifficulty!,
                            questionCount: _selectedCount,
                          ),
                        )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spacingLg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start Quiz',
                        style: optionLabelStyle?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Difficulty Tile

class _DifficultyTile extends StatelessWidget {
  const _DifficultyTile({
    required this.option,
    required this.selected,
    required this.labelStyle,
    required this.onTap,
  });

  final _DifficultyOption option;
  final bool selected;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? ButtonColors.primaryDefault
        : AppColors.brandPrimary500Alpha10;
    final textColor = selected ? AppColors.white : ButtonColors.outlineText;
    final brightness = Theme.of(context).brightness;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        boxShadow: selected ? AppShadows.elevation(brightness) : [],
      ),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              border: selected
                  ? null
                  : Border.all(color: ButtonColors.outlineBorder),
            ),
            child: SizedBox(
              height: 84,
              width: double.infinity,
              child: Center(
                child: Text(
                  option.label,
                  textAlign: TextAlign.center,
                  style: labelStyle?.copyWith(color: textColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Count Chip

/// Compact selectable chip for the question count row.
class _CountChip extends StatelessWidget {
  const _CountChip({
    required this.count,
    required this.selected,
    required this.labelStyle,
    required this.onTap,
  });

  final int count;
  final bool selected;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? ButtonColors.primaryDefault
        : AppColors.brandPrimary500Alpha10;
    final textColor = selected ? AppColors.white : ButtonColors.outlineText;
    final brightness = Theme.of(context).brightness;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        boxShadow: selected ? AppShadows.elevation(brightness) : [],
      ),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              border: selected
                  ? null
                  : Border.all(color: ButtonColors.outlineBorder),
            ),
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: Center(
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: labelStyle?.copyWith(color: textColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

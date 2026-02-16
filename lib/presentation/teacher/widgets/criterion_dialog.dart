import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/domain/models/rubric.dart';
import 'package:flutter/material.dart';

class CriterionDialog extends StatefulWidget {
  final RubricCriterion? criterion;

  const CriterionDialog({super.key, this.criterion});

  @override
  State<CriterionDialog> createState() => _CriterionDialogState();
}

class _CriterionDialogState extends State<CriterionDialog> {
  late TextEditingController _titleController;
  late double _weight;
  late TextEditingController _excellentController;
  late TextEditingController _goodController;
  late TextEditingController _averageController;
  late TextEditingController _poorController;

  @override
  void initState() {
    super.initState();
    final criterion = widget.criterion ?? RubricCriterion.initial();
    _titleController = TextEditingController(text: criterion.title);
    _weight = criterion.weight;
    
    _excellentController = TextEditingController(
      text: _getDescription(criterion, 4),
    );
    _goodController = TextEditingController(
      text: _getDescription(criterion, 3),
    );
    _averageController = TextEditingController(
      text: _getDescription(criterion, 2),
    );
    _poorController = TextEditingController(
      text: _getDescription(criterion, 1),
    );
  }

  String _getDescription(RubricCriterion criterion, int score) {
    return criterion.levels
        .firstWhere(
          (l) => l.score == score,
          orElse: () => RubricLevel(score: score, description: ''),
        )
        .description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excellentController.dispose();
    _goodController.dispose();
    _averageController.dispose();
    _poorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.criterion == null ? 'Add Criterion' : 'Edit Criterion'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Criterion Title'),
            ),
            const SizedBox(height: AppSpacing.spacingMd),
            Text('Weight: ${_weight.round()}%', style: AppTypography.labelLarge()),
            Slider(
              value: _weight,
              min: 0,
              max: 100,
              divisions: 20, // 5% increments
              label: '${_weight.round()}%',
              onChanged: (val) => setState(() => _weight = val),
            ),
            const Divider(),
            Text('Performance Levels', style: AppTypography.h6()),
            const SizedBox(height: AppSpacing.spacingSm),
            _buildLevelField('Excellent (4 pts)', _excellentController),
            _buildLevelField('Good (3 pts)', _goodController),
            _buildLevelField('Average (2 pts)', _averageController),
            _buildLevelField('Poor (1 pt)', _poorController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppPrimaryButton(
          text: 'Save',
          onPressed: _save,
        ),
      ],
    );
  }

  Widget _buildLevelField(String label, TextEditingController controller) {
    return Paddle(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacingSm),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        maxLines: 2,
        minLines: 1,
      ),
    );
  }

  void _save() {
    if (_titleController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final newLevels = [
      RubricLevel(score: 4, description: _excellentController.text),
      RubricLevel(score: 3, description: _goodController.text),
      RubricLevel(score: 2, description: _averageController.text),
      RubricLevel(score: 1, description: _poorController.text),
    ];

    final newCriterion = (widget.criterion ?? RubricCriterion.initial()).copyWith(
      title: _titleController.text,
      weight: _weight,
      levels: newLevels,
    );

    Navigator.of(context).pop(newCriterion);
  }
}

class Paddle extends StatelessWidget {
    final EdgeInsetsGeometry padding;
    final Widget child;
    const Paddle({super.key, required this.padding, required this.child});
    @override
    Widget build(BuildContext context) {
        return Padding(padding: padding, child: child);
    }
}

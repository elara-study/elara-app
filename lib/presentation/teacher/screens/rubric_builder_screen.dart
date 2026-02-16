import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/domain/models/rubric.dart';
import 'package:elara/domain/repositories/rubric_repository.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/presentation/teacher/widgets/criterion_dialog.dart';
import 'package:flutter/material.dart';

class RubricBuilderScreen extends StatefulWidget {
  const RubricBuilderScreen({super.key});

  @override
  State<RubricBuilderScreen> createState() => _RubricBuilderScreenState();
}

class _RubricBuilderScreenState extends State<RubricBuilderScreen> {
  late Rubric _rubric;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rubric = Rubric.empty();
    _titleController.text = _rubric.title;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addCriterion() async {
    final RubricCriterion? result = await showDialog<RubricCriterion>(
      context: context,
      builder: (context) => const CriterionDialog(),
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          _rubric = _rubric.copyWith(criteria: [..._rubric.criteria, result]);
        });
      }
    }
  }

  Future<void> _editCriterion(int index) async {
    final criterion = _rubric.criteria[index];
    final RubricCriterion? result = await showDialog<RubricCriterion>(
      context: context,
      builder: (context) => CriterionDialog(criterion: criterion),
    );

    if (result != null) {
      if (mounted) {
        setState(() {
          final newCriteria = List<RubricCriterion>.from(_rubric.criteria);
          newCriteria[index] = result;
          _rubric = _rubric.copyWith(criteria: newCriteria);
        });
      }
    }
  }

  void _removeCriterion(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Criterion?'),
        content: const Text('Are you sure you want to remove this criterion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
               setState(() {
                final newCriteria = List<RubricCriterion>.from(_rubric.criteria);
                newCriteria.removeAt(index);
                _rubric = _rubric.copyWith(criteria: newCriteria);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final newCriteria = List<RubricCriterion>.from(_rubric.criteria);
      final item = newCriteria.removeAt(oldIndex);
      newCriteria.insert(newIndex, item);
      _rubric = _rubric.copyWith(criteria: newCriteria);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double totalWeight = _rubric.totalWeight;
    final bool isValid = _rubric.isValid;

    return Scaffold(
      appBar: AppAppBar.detail(title: 'Rubric Builder'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.spacingLg),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Rubric Name',
                  hintText: 'e.g. Argumentative Essay Rubric',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => _rubric = _rubric.copyWith(title: val),
              ),
            ),
            Expanded(
              child: _rubric.criteria.isEmpty 
                  ? Center(child: Text('Add criteria to build your rubric', style: AppTypography.bodyLarge()))
                  : ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingLg,
                ),
                itemCount: _rubric.criteria.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final criterion = _rubric.criteria[index];
                  return Card(
                    key: ValueKey(criterion.id),
                    margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingMd, vertical: AppSpacing.spacingSm),
                      leading: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                      title: Text(criterion.title, style: AppTypography.h6()),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weight: ${criterion.weight.toStringAsFixed(0)}%', style: AppTypography.bodySmall()),
                          Text('${criterion.levels.length} levels defined', style: AppTypography.bodySmall()),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editCriterion(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeCriterion(index),
                          ),
                        ],
                      ),
                      onTap: () => _editCriterion(index),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacingLg),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Weight:', style: AppTypography.h6()),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isValid ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isValid ? Colors.green : Colors.red),
                        ),
                        child: Text(
                          '${totalWeight.toStringAsFixed(0)}% / 100%',
                          style: AppTypography.h6().copyWith(
                            color: isValid ? Colors.green[800] : Colors.red[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacingMd),
                  SizedBox(
                    width: double.infinity,
                    child: AppSecondaryButton(
                      text: 'Add Criterion',
                      icon: Icons.add,
                      onPressed: _addCriterion,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  AppPrimaryButton(
                    text: 'Save Rubric',
                    onPressed: isValid
                        ? () async {
                            if (_titleController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a rubric name')),
                              );
                              return;
                            }
                            
                            final repository = getIt<RubricRepository>();
                            await repository.saveRubric(_rubric);
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Rubric Saved Successfully!')),
                              );
                              Navigator.of(context).pop();
                            }
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

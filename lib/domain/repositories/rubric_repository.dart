import 'package:elara/domain/models/rubric.dart';

class RubricRepository {
  final List<Rubric> _rubrics = [];

  RubricRepository() {
    // Add a default rubric for testing
    _rubrics.add(
      const Rubric(
        id: 'default',
        title: 'Default Argumentative Rubric',
        criteria: [
          RubricCriterion(
            id: 'c1',
            title: 'Thesis Statement',
            weight: 25,
            levels: [],
          ),
          RubricCriterion(
            id: 'c2',
            title: 'Evidence & Support',
            weight: 35,
            levels: [],
          ),
          RubricCriterion(
            id: 'c3',
            title: 'Analysis',
            weight: 25,
            levels: [],
          ),
          RubricCriterion(
            id: 'c4',
            title: 'Grammar & Mechanics',
            weight: 15,
            levels: [],
          ),
        ],
      ),
    );
  }

  Future<void> saveRubric(Rubric rubric) async {
    // Simulate DB delay
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _rubrics.indexWhere((r) => r.id == rubric.id);
    if (index >= 0) {
      _rubrics[index] = rubric;
    } else {
      _rubrics.add(rubric);
    }
  }

  Future<List<Rubric>> getRubrics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_rubrics);
  }

  Future<Rubric?> getRubric(String id) async {
    try {
      return _rubrics.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteRubric(String id) async {
     _rubrics.removeWhere((r) => r.id == id);
  }
}

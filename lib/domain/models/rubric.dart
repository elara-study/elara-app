import 'package:equatable/equatable.dart';

class Rubric extends Equatable {
  final String id;
  final String title;
  final List<RubricCriterion> criteria;

  const Rubric({
    required this.id,
    required this.title,
    required this.criteria,
  });

  factory Rubric.empty() {
    return Rubric(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Rubric',
      criteria: [],
    );
  }

  double get totalWeight => criteria.fold(0, (sum, c) => sum + c.weight);

  bool get isValid => (totalWeight - 100).abs() < 0.1;

  Rubric copyWith({String? title, List<RubricCriterion>? criteria}) {
    return Rubric(
      id: id,
      title: title ?? this.title,
      criteria: criteria ?? this.criteria,
    );
  }

  @override
  List<Object?> get props => [id, title, criteria];
}

class RubricCriterion extends Equatable {
  final String id;
  final String title;
  final double weight; // Percentage 0-100
  final List<RubricLevel> levels;

  const RubricCriterion({
    required this.id,
    required this.title,
    required this.weight,
    required this.levels,
  });

  factory RubricCriterion.initial() {
    return RubricCriterion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Criterion',
      weight: 0,
      levels: const [
        RubricLevel(score: 4, description: 'Excellent performance'),
        RubricLevel(score: 3, description: 'Good performance'),
        RubricLevel(score: 2, description: 'Average performance'),
        RubricLevel(score: 1, description: 'Poor performance'),
      ],
    );
  }

  RubricCriterion copyWith({String? title, double? weight, List<RubricLevel>? levels}) {
    return RubricCriterion(
      id: id,
      title: title ?? this.title,
      weight: weight ?? this.weight,
      levels: levels ?? this.levels,
    );
  }

  @override
  List<Object?> get props => [id, title, weight, levels];
}

class RubricLevel extends Equatable {
  final int score;
  final String description;

  const RubricLevel({required this.score, required this.description});

  @override
  List<Object?> get props => [score, description];
}

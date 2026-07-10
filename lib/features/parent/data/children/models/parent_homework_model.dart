import 'package:elara/features/parent/data/children/models/parent_homework_problem_model.dart';
import 'package:elara/features/student/domain/homework/entities/homework_entity.dart';

class ParentHomeworkModel extends HomeworkEntity {
  const ParentHomeworkModel({
    required super.id,
    required super.subject,
    required super.moduleTitle,
    required super.totalXp,
    required super.problems,
  });

  factory ParentHomeworkModel.fromJson(Map<String, dynamic> json) {
    final problemsList = json['problems'] as List? ?? [];
    return ParentHomeworkModel(
      id: (json['id'] ?? '').toString(),
      subject: json['subject'] as String? ?? '',
      moduleTitle: json['module_title'] as String? ?? json['moduleTitle'] as String? ?? '',
      totalXp: json['total_xp'] as int? ?? json['totalXp'] as int? ?? 100,
      problems: problemsList
          .whereType<Map<String, dynamic>>()
          .map(ParentHomeworkProblemModel.fromJson)
          .toList(),
    );
  }
}

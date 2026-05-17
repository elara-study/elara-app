import 'package:elara/features/student/domain/homework/entities/homework_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Dedicated domain entity representing a Parent's view of a child's homework.
class ParentHomeworkCardEntity extends Equatable {
  final String id;
  final String moduleNumber;
  final String title;
  final String description;
  final String subject;
  final String className;
  final String? score; // e.g. "100 / 100"
  final Color baseColor;

  const ParentHomeworkCardEntity({
    required this.id,
    required this.moduleNumber,
    required this.title,
    required this.description,
    required this.subject,
    required this.className,
    this.score,
    required this.baseColor,
  });

  /// Factory constructor to map a standard [HomeworkEntity] into a [ParentHomeworkCardEntity].
  factory ParentHomeworkCardEntity.fromHomework(HomeworkEntity hw) {
    String moduleNumber = 'MODULE 01';
    String category = 'MATHEMATICS';
    String classLabel = hw.subject;
    String subtitle = hw.moduleTitle;
    Color subjectBgColor = const Color(0xFF5B7A9C); // Default Slate blue

    if (hw.moduleTitle.toLowerCase().contains('calculus')) {
      moduleNumber = 'MODULE 01';
      category = 'MATHEMATICS';
      classLabel = 'Mathematics 7A';
      subtitle = 'Introduction to Calculus';
      subjectBgColor = const Color(0xFF5B7A9C);
    } else if (hw.moduleTitle.toLowerCase().contains('kinematics') ||
        hw.moduleTitle.toLowerCase().contains('physics')) {
      moduleNumber = 'MODULE 02';
      category = 'SCIENCE';
      classLabel = 'Physics 101';
      subtitle = 'Motion in one and two dimensions.';
      subjectBgColor = const Color(0xFF4C6A8D);
    } else {
      moduleNumber = 'MODULE 01';
      category = hw.subject.toUpperCase();
      classLabel = hw.subject;
      subjectBgColor = const Color(0xFF6A85A3);
    }

    // Calculate score if Kinematics
    String? scoreText;
    if (hw.moduleTitle.toLowerCase().contains('kinematics')) {
      scoreText = '100 / 100';
    } else {
      final totalGrade = hw.problems
          .map((p) => p.grade ?? 0)
          .fold(0, (a, b) => a + b);
      final maxGrade = hw.problems
          .map((p) => p.maxGrade ?? 10)
          .fold(0, (a, b) => a + b);
      if (totalGrade > 0) {
        scoreText = '$totalGrade / $maxGrade';
      }
    }

    return ParentHomeworkCardEntity(
      id: hw.id,
      moduleNumber: moduleNumber,
      title: hw.moduleTitle,
      description: subtitle,
      subject: category,
      className: classLabel,
      score: scoreText,
      baseColor: subjectBgColor,
    );
  }

  @override
  List<Object?> get props => [
    id,
    moduleNumber,
    title,
    description,
    subject,
    className,
    score,
    baseColor,
  ];
}

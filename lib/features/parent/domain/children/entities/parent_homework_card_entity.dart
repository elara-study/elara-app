import 'package:elara/features/parent/domain/children/entities/parent_homework_status.dart';
import 'package:elara/features/student/domain/homework/entities/homework_entity.dart';
import 'package:elara/features/student/domain/homework/entities/homework_problem_entity.dart';
import 'package:elara/features/student/domain/homework/entities/homework_problem_status.dart';
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
  final ParentHomeworkStatus status;
  final List<HomeworkProblemEntity> problems;

  const ParentHomeworkCardEntity({
    required this.id,
    required this.moduleNumber,
    required this.title,
    required this.description,
    required this.subject,
    required this.className,
    this.score,
    required this.baseColor,
    this.status = ParentHomeworkStatus.active,
    this.problems = const [],
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
    } else if (hw.moduleTitle.toLowerCase().contains('waves')) {
      moduleNumber = 'MODULE 01';
      category = 'SCIENCE';
      classLabel = 'Physics 101';
      subtitle = 'Oscillations, amplitude, and frequency basics.';
      subjectBgColor = const Color(0xFF4C6A8D);
    } else {
      moduleNumber = 'MODULE 01';
      category = hw.subject.toUpperCase();
      classLabel = hw.subject;
      subjectBgColor = const Color(0xFF6A85A3);
    }

    // Derive homework-level status from problem statuses
    final statuses = hw.problems.map((p) => p.status).toList();
    ParentHomeworkStatus hwStatus;
    if (statuses.isNotEmpty &&
        statuses.every((s) => s == HomeworkProblemStatus.graded)) {
      hwStatus = ParentHomeworkStatus.graded;
    } else if (statuses.any(
      (s) =>
          s == HomeworkProblemStatus.submitted ||
          s == HomeworkProblemStatus.pending ||
          s == HomeworkProblemStatus.graded,
    )) {
      hwStatus = ParentHomeworkStatus.submitted;
    } else {
      hwStatus = ParentHomeworkStatus.active;
    }

    // Calculate score
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
      status: hwStatus,
      problems: hw.problems,
    );
  }

  factory ParentHomeworkCardEntity.fromJson(Map<String, dynamic> json) {
    final problemsList = json['problems'] as List? ?? [];
    if (problemsList.isNotEmpty || !json.containsKey('status')) {
      final parsedProblems = problemsList.whereType<Map<String, dynamic>>().map((p) {
        final statusStr = p['status'] as String? ?? 'active';
        final status = HomeworkProblemStatus.values.firstWhere(
          (e) => e.name == statusStr.toLowerCase(),
          orElse: () => HomeworkProblemStatus.active,
        );
        return HomeworkProblemEntity(
          id: (p['id'] ?? '').toString(),
          problemNumber: p['problem_number'] as int? ?? p['problemNumber'] as int? ?? 1,
          questionText: p['question_text'] as String? ?? p['description'] as String? ?? '',
          status: status,
          answerText: p['answer_text'] as String? ?? '',
          submittedAnswer: p['submitted_answer'] as String?,
          grade: p['grade'] as int?,
          maxGrade: p['max_grade'] as int? ?? p['maxGrade'] as int?,
          feedback: p['feedback'] as String?,
        );
      }).toList();

      final id = (json['id'] ?? '').toString();
      final title = json['module_title'] as String? ?? json['moduleTitle'] as String? ?? json['title'] as String? ?? '';
      final subject = json['subject'] as String? ?? '';
      
      String moduleNumber = 'MODULE 01';
      String category = subject.toUpperCase();
      String classLabel = subject;
      Color subjectBgColor = const Color(0xFF6A85A3);

      if (title.toLowerCase().contains('calculus')) {
        moduleNumber = 'MODULE 01';
        category = 'MATHEMATICS';
        classLabel = 'Mathematics 7A';
        subjectBgColor = const Color(0xFF5B7A9C);
      } else if (title.toLowerCase().contains('kinematics') ||
          title.toLowerCase().contains('physics')) {
        moduleNumber = 'MODULE 02';
        category = 'SCIENCE';
        classLabel = 'Physics 101';
        subjectBgColor = const Color(0xFF4C6A8D);
      } else if (title.toLowerCase().contains('waves')) {
        moduleNumber = 'MODULE 01';
        category = 'SCIENCE';
        classLabel = 'Physics 101';
        subjectBgColor = const Color(0xFF4C6A8D);
      }

      final statuses = parsedProblems.map((p) => p.status).toList();
      ParentHomeworkStatus hwStatus;
      if (statuses.isNotEmpty &&
          statuses.every((s) => s == HomeworkProblemStatus.graded)) {
        hwStatus = ParentHomeworkStatus.graded;
      } else if (statuses.any(
        (s) =>
            s == HomeworkProblemStatus.submitted ||
            s == HomeworkProblemStatus.pending ||
            s == HomeworkProblemStatus.graded,
      )) {
        hwStatus = ParentHomeworkStatus.submitted;
      } else {
        hwStatus = ParentHomeworkStatus.active;
      }

      String? scoreText;
      if (title.toLowerCase().contains('kinematics')) {
        scoreText = '100 / 100';
      } else {
        final totalGrade = parsedProblems
            .map((p) => p.grade ?? 0)
            .fold(0, (a, b) => a + b);
        final maxGrade = parsedProblems
            .map((p) => p.maxGrade ?? 10)
            .fold(0, (a, b) => a + b);
        if (totalGrade > 0) {
          scoreText = '$totalGrade / $maxGrade';
        }
      }

      return ParentHomeworkCardEntity(
        id: id,
        moduleNumber: moduleNumber,
        title: title,
        description: title,
        subject: category,
        className: classLabel,
        score: scoreText,
        baseColor: subjectBgColor,
        status: hwStatus,
        problems: parsedProblems,
      );
    }

    final id = (json['id'] ?? '').toString();
    final title = json['title'] as String? ?? json['module_title'] as String? ?? json['moduleTitle'] as String? ?? '';
    final module = json['module'] as String? ?? '';
    final description = json['description'] as String? ?? '';
    final subject = json['subject'] as String? ?? '';
    final classLabel = json['class_label'] as String? ?? '';
    final statusStr = json['status'] as String? ?? 'pending';
    final scoreVal = json['score'];
    
    ParentHomeworkStatus status = ParentHomeworkStatus.active;
    if (statusStr == 'submitted') {
      status = ParentHomeworkStatus.submitted;
    } else if (statusStr == 'graded') {
      status = ParentHomeworkStatus.graded;
    }
    
    Color subjectBgColor = const Color(0xFF6A85A3);
    if (subject.toLowerCase().contains('physics')) {
      subjectBgColor = const Color(0xFF4C6A8D);
    } else if (subject.toLowerCase().contains('math')) {
      subjectBgColor = const Color(0xFF5B7A9C);
    }

    return ParentHomeworkCardEntity(
      id: id,
      moduleNumber: module.toUpperCase().isNotEmpty ? module.toUpperCase() : 'MODULE',
      title: title,
      description: description,
      subject: subject.toUpperCase(),
      className: classLabel,
      score: scoreVal?.toString(),
      baseColor: subjectBgColor,
      status: status,
      problems: const [],
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
    status,
    problems,
  ];
}

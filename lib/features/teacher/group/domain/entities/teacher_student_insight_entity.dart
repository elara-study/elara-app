import 'package:equatable/equatable.dart';

/// Teacher-authored insight shown on the group student profile (Figma Insight).
class TeacherStudentInsightEntity extends Equatable {
  const TeacherStudentInsightEntity({
    required this.updatedLabel,
    required this.paragraph1,
    required this.paragraph2,
    this.isDraft = true,
  });

  final String updatedLabel;
  final String paragraph1;
  final String paragraph2;
  final bool isDraft;

  @override
  List<Object?> get props => [
    updatedLabel,
    paragraph1,
    paragraph2,
    isDraft,
  ];
}

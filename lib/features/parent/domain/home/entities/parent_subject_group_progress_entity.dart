import 'package:equatable/equatable.dart';

/// One subject/course progress row on the parent Child Card (Figma).
class ParentSubjectGroupProgressEntity extends Equatable {
  const ParentSubjectGroupProgressEntity({
    required this.name,
    required this.progress,
  });

  final String name;

  /// \[0, 1\]
  final double progress;

  int get progressPercentRounded => (progress * 100).clamp(0, 100).round();

  @override
  List<Object?> get props => [name, progress];
}

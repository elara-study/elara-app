import 'package:equatable/equatable.dart';

/// A compact badge label for the profile "recent achievements" row.
class ProfileAchievementPreviewEntity extends Equatable {
  const ProfileAchievementPreviewEntity({required this.label});

  final String label;

  @override
  List<Object?> get props => [label];
}

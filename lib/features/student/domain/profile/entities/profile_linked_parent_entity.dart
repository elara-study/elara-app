import 'package:equatable/equatable.dart';

/// A parent/guardian linked to the student profile.
class ProfileLinkedParentEntity extends Equatable {
  const ProfileLinkedParentEntity({
    required this.id,
    required this.displayName,
  });

  final String id;
  final String displayName;

  @override
  List<Object?> get props => [id, displayName];
}

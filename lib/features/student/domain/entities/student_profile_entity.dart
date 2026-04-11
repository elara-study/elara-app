import 'package:equatable/equatable.dart';

/// Represents the authenticated student's profile summary
/// shown in the Home screen header.
class StudentProfileEntity extends Equatable {
  final String id;
  final String fullName;

  /// Display name used in the greeting (e.g. "Tyler")
  final String firstName;

  /// Total accumulated XP / points
  final int points;

  /// Count shown on the notification bell badge
  final int notificationCount;

  const StudentProfileEntity({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.points,
    required this.notificationCount,
  });

  @override
  List<Object?> get props => [id, fullName, firstName, points, notificationCount];
}

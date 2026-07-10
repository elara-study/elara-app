import 'package:elara/features/parent/domain/profile/entities/parent_profile_entity.dart';

class ParentProfileModel extends ParentProfileEntity {
  const ParentProfileModel({
    required super.phoneNumber,
    required super.averageCompletionPercentage,
    required super.averageAttendancePercentage,
  });

  factory ParentProfileModel.fromJson(Map<String, dynamic> json) {
    return ParentProfileModel(
      phoneNumber: json['phoneNumber'] as String? ?? '',
      averageCompletionPercentage: json['averageCompletionPercentage'] as int? ?? 0,
      averageAttendancePercentage: json['averageAttendancePercentage'] as int? ?? 0,
    );
  }
}

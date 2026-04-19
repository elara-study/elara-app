import 'package:elara/features/student/domain/entities/student_profile_entity.dart';

class StudentProfileModel extends StudentProfileEntity {
  const StudentProfileModel({
    required super.id,
    required super.fullName,
    required super.firstName,
    required super.points,
    required super.notificationCount,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    final fullName = json['full_name'] as String;
    return StudentProfileModel(
      id: json['id'] as String,
      fullName: fullName,
      firstName: json['first_name'] as String? ?? fullName.split(' ').first,
      points: json['points'] as int? ?? 0,
      notificationCount: json['notification_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'first_name': firstName,
        'points': points,
        'notification_count': notificationCount,
      };
}

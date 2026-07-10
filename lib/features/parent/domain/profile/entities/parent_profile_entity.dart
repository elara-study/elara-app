import 'package:equatable/equatable.dart';

class ParentProfileEntity extends Equatable {
  const ParentProfileEntity({
    required this.phoneNumber,
    required this.averageCompletionPercentage,
    required this.averageAttendancePercentage,
  });

  final String phoneNumber;
  final int averageCompletionPercentage;
  final int averageAttendancePercentage;

  @override
  List<Object?> get props => [
        phoneNumber,
        averageCompletionPercentage,
        averageAttendancePercentage,
      ];
}

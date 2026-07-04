import 'package:elara/features/notifications/domain/entities/notification_entity.dart';

/// Data model extending [NotificationEntity] with JSON serialization.
///
/// Adds [fromJson] / [toJson] for network layer use.
/// The domain entity stays clean — no JSON code leaks into the domain.
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.message,
    required super.isRead,
    required super.type,
    required super.notificationDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      notificationDate: json['notificationDate'] != null
          ? DateTime.tryParse(json['notificationDate'] as String) ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'isRead': isRead,
    'type': type,
    'notificationDate': notificationDate.toIso8601String(),
  };
}

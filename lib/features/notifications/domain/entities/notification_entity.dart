import 'package:equatable/equatable.dart';

/// Domain entity representing a single notification from the notification center.
///
/// Maps directly to the API response schema:
/// ```json
/// {
///   "id": "uuid",
///   "message": "string",
///   "isRead": true,
///   "type": "Announcement",
///   "notificationDate": "2026-07-04T00:26:03.130Z"
/// }
/// ```
class NotificationEntity extends Equatable {
  final String id;
  final String message;
  final bool isRead;
  final String type;
  final DateTime notificationDate;

  const NotificationEntity({
    required this.id,
    required this.message,
    required this.isRead,
    required this.type,
    required this.notificationDate,
  });

  @override
  List<Object?> get props => [id, message, isRead, type, notificationDate];
}

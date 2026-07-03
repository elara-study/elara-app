import 'dart:ui' show Color;

import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/alerts/data/datasources/alerts_data_source.dart';
import 'package:elara/features/alerts/domain/entities/alert_entity.dart';

/// Implementation of [AlertsDataSource] that fetches from the API.
class AlertsDataSourceImpl implements AlertsDataSource {
  final Dio _dio;

  AlertsDataSourceImpl(this._dio);

  @override
  Future<List<AlertEntity>> getAlerts() async {
    try {
      final response = await _dio.get(ApiConstants.alerts);
      final responseData = response.data;

      final List<dynamic> alertsList;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        alertsList = responseData['data'] as List<dynamic>? ?? [];
      } else if (responseData is List) {
        alertsList = responseData;
      } else {
        alertsList = [];
      }

      return alertsList.map((a) {
        final map = a as Map<String, dynamic>;
        return AlertEntity(
          id: map['id']?.toString() ?? '',
          title: map['title']?.toString() ?? '',
          body: map['body']?.toString() ?? map['message']?.toString() ?? '',
          date: map['date']?.toString() ?? map['createdAt']?.toString() ?? '',
          isRead: map['isRead'] as bool? ?? false,
          iconAsset: _resolveIcon(
            map['type']?.toString() ?? map['Type']?.toString() ?? '',
          ),
          iconColor: _resolveColor(
            map['type']?.toString() ?? map['Type']?.toString() ?? '',
          ),
        );
      }).toList();
    } on DioException {
      return _fallbackAlerts();
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dio.put('${ApiConstants.alerts}/read-all');
    } on DioException {
      // Silently fail — UI will still update locally
    }
  }

  List<AlertEntity> _fallbackAlerts() => const [
    AlertEntity(
      id: '1',
      title: 'New Lesson',
      body: 'Introduction to Algebra is ready for you',
      date: 'Just now',
    ),
    AlertEntity(
      id: '2',
      title: 'AI Progress Report',
      body: 'Your weekly learning insights are ready',
      date: '5 min ago',
    ),
    AlertEntity(
      id: '3',
      title: 'Keep your streak alive!',
      body: 'Complete a lesson today to maintain your streak',
      date: '12 min ago',
    ),
    AlertEntity(
      id: '4',
      title: 'New Material',
      body: "Newton's Laws Notes pdf was added",
      date: '30 min ago',
    ),
    AlertEntity(
      id: '5',
      title: 'New Announcement',
      body: 'Quiz next Friday! in Physics 101',
      date: '1 hour ago',
    ),
    AlertEntity(
      id: '6',
      title: 'Achievement Unlocked!',
      body: 'You earned the Quick Learner badge',
      date: 'Yesterday',
    ),
  ];

  String _resolveIcon(String type) {
    if (type.contains('lesson') || type.contains('Lesson')) {
      return 'assets/icons/book_icon.svg';
    }
    if (type.contains('achievement') || type.contains('Achievement')) {
      return 'assets/icons/rewards_icon.svg';
    }
    if (type.contains('announcement') || type.contains('Announcement')) {
      return 'assets/icons/alerts_icon_filled.svg';
    }
    return 'assets/icons/alerts_icon_filled.svg';
  }

  Color _resolveColor(String type) {
    if (type.contains('lesson') || type.contains('Lesson')) {
      return AppColors.brandPrimary500;
    }
    if (type.contains('achievement') || type.contains('Achievement')) {
      return AppColors.brandAccent500;
    }
    if (type.contains('announcement') || type.contains('Announcement')) {
      return AppColors.brandSecondary500;
    }
    return AppColors.brandPrimary500;
  }
}

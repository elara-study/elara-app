import 'package:flutter/material.dart';

/// A single alert / notification item.
class AlertEntity {
  final String id;
  final String title;
  final String body;
  final String date;
  final bool isRead;
  final String iconAsset;
  final Color iconColor;

  const AlertEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    this.isRead = false,
    this.iconAsset = 'assets/icons/alerts_icon_filled.svg',
    this.iconColor = const Color(0xFF4D6A8A),
  });
}

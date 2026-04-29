import 'package:flutter/material.dart';

/// A single recent activity event shown in the "Recent Activity" section
/// of the Teacher Home screen.
class TeacherActivityEntity {
  final String id;

  /// Short description of the event (e.g. "Ali submitted homework").
  final String title;

  /// Context label (e.g. "Physics • Chapter 3").
  final String subtitle;

  /// Human-readable relative time (e.g. "2 min ago").
  final String timeAgo;

  /// SVG asset path for the activity icon.
  final String iconAsset;

  /// Colour used for the icon circle background tint and icon fill.
  final Color iconColor;

  const TeacherActivityEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.iconAsset,
    required this.iconColor,
  });
}

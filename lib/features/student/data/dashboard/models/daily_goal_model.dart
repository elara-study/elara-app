import 'package:elara/features/student/domain/dashboard/entities/daily_goal_entity.dart';

class DailyGoalModel extends DailyGoalEntity {
  const DailyGoalModel({
    required super.id,
    required super.label,
    required super.iconKey,
    required super.xpReward,
    required super.isCompleted,
    super.progressCurrent = 0,
    super.progressTotal = 1,
  });

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel(
      id: json['id'] as String,
      label: json['label'] as String,
      iconKey: json['icon_key'] as String,
      xpReward: json['xp_reward'] as int,
      isCompleted: json['is_completed'] as bool? ?? false,
      progressCurrent: (json['progress_current'] as num?)?.toInt() ?? 0,
      progressTotal: (json['progress_total'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'icon_key': iconKey,
    'xp_reward': xpReward,
    'is_completed': isCompleted,
    'progress_current': progressCurrent,
    'progress_total': progressTotal,
  };
}

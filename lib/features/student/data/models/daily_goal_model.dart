import 'package:elara/features/student/domain/entities/daily_goal_entity.dart';

class DailyGoalModel extends DailyGoalEntity {
  const DailyGoalModel({
    required super.id,
    required super.label,
    required super.iconKey,
    required super.xpReward,
    required super.isCompleted,
  });

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel(
      id: json['id'] as String,
      label: json['label'] as String,
      iconKey: json['icon_key'] as String,
      xpReward: json['xp_reward'] as int,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'icon_key': iconKey,
        'xp_reward': xpReward,
        'is_completed': isCompleted,
      };
}

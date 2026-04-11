import 'package:equatable/equatable.dart';

/// Student rewards summary from GET …/rewards/overview.
class StudentRewardsOverview extends Equatable {
  final int totalPoints;
  final String? tierLabel;

  const StudentRewardsOverview({required this.totalPoints, this.tierLabel});

  factory StudentRewardsOverview.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['total_points'] ?? json['totalPoints'] ?? 0;
    final points = rawPoints is int
        ? rawPoints
        : int.tryParse(rawPoints.toString()) ?? 0;
    final tier =
        json['tier_label']?.toString() ?? json['tierLabel']?.toString();
    return StudentRewardsOverview(totalPoints: points, tierLabel: tier);
  }

  @override
  List<Object?> get props => [totalPoints, tierLabel];
}

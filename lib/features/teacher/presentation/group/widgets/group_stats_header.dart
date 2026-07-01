import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_detail_entity.dart';
import 'package:elara/shared/widgets/app_stat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Two colored stat tiles arranged in a row.
class GroupStatsHeader extends StatelessWidget {
  final String icon1;
  final String label1;
  final String value1;
  final Color color1;

  final String icon2;
  final String label2;
  final String value2;
  final Color color2;

  const GroupStatsHeader({
    super.key,
    required this.icon1,
    required this.label1,
    required this.value1,
    required this.color1,
    required this.icon2,
    required this.label2,
    required this.value2,
    required this.color2,
  });

  factory GroupStatsHeader.fromDetail(TeacherGroupDetailEntity detail) {
    return GroupStatsHeader(
      icon1: 'assets/icons/profile_icon_filled.svg',
      label1: 'Students',
      value1: '${detail.studentCount}',
      color1: AppColors.brandPrimary500,
      icon2: 'assets/icons/check_circle_icon.svg',
      label2: 'Avg. Completion',
      value2: detail.avgCompletionLabel,
      color2: AppColors.brandSecondary500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppStatTile(
            icon: icon1,
            label: label1,
            value: value1,
            backgroundColor: color1,
          ),
        ),
        SizedBox(width: AppSpacing.spacingMd.w),
        Expanded(
          child: AppStatTile(
            icon: icon2,
            label: label2,
            value: value2,
            backgroundColor: color2,
          ),
        ),
      ],
    );
  }
}

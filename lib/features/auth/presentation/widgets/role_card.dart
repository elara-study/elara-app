import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/shared/widgets/app_action_card.dart';
import 'package:flutter/material.dart';

/// Thin role-specific wrapper around [AppActionCard].
///
/// Maps each [UserRole] to its icon, primaryColor, and secondaryColor,
/// then delegates all rendering to [AppActionCard].
class RoleCard extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (role) {
      case UserRole.student:
        return Icons.school_outlined;
      case UserRole.teacher:
        return Icons.person_outline;
      case UserRole.parent:
        return Icons.people_outline;
    }
  }

  Color get _primaryColor {
    switch (role) {
      case UserRole.student:
        return AppColors.brandPrimary500;
      case UserRole.teacher:
        return AppColors.brandSecondary500;
      case UserRole.parent:
        return AppColors.success500;
    }
  }

  Color get _secondaryColor {
    switch (role) {
      case UserRole.student:
        return AppColors.brandPrimary400;
      case UserRole.teacher:
        return AppColors.brandSecondary400;
      case UserRole.parent:
        return AppColors.success400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppActionCard(
      title: role.displayName,
      subtitle: role.subtitle,
      icon: _icon,
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}

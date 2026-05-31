import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoleCard extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final double height;
  final double contentPadding;
  final double iconSize;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
    this.height = 76,
    this.contentPadding = AppSpacing.spacingLg,
    this.iconSize = 44,
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

  String get _subtitle {
    switch (role) {
      case UserRole.student:
        return 'Join as a student';
      case UserRole.teacher:
        return 'Join as a teacher';
      case UserRole.parent:
        return 'Join as a parent';
    }
  }

  Color get _veilColor {
    switch (role) {
      case UserRole.student:
        return AppColors.brandPrimary50;
      case UserRole.teacher:
        return AppColors.brandSecondary50;
      case UserRole.parent:
        return AppColors.success50;
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = (height * 0.315).clamp(
      AppRadius.radiusMd,
      AppRadius.radiusLg,
    );
    final iconGlyphSize = (iconSize * 0.45).clamp(16.0, 20.0);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_secondaryColor, _primaryColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(
                alpha: isSelected ? 0.12 : 0.08,
              ),
              blurRadius: isSelected ? 24 : 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              Positioned(
                left: -height * 1.2,
                top: -height * 0.24,
                child: Container(
                  width: height * 1.68,
                  height: height * 1.68,
                  decoration: BoxDecoration(
                    color: _veilColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Row(
                  children: [
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _icon,
                        color: AppColors.neutral50,
                        size: iconGlyphSize,
                      ),
                    ),
                    SizedBox(
                      width: (contentPadding * 0.75).clamp(
                        AppSpacing.spacingSm,
                        AppSpacing.spacingMd,
                      ),
                    ),
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 160),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                role.displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.labelLarge(
                                  color: AppColors.neutral50,
                                ),
                              ),
                              Text(
                                _subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall(
                                  color: AppColors.neutral200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacingSm),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.glow,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/right_arrow_ios.svg',
                          colorFilter: ColorFilter.mode(
                            _primaryColor,
                            BlendMode.srcIn,
                          ),
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceControls extends StatelessWidget {
  const VoiceControls({
    super.key,
    required this.isMuted,
    required this.onMuteToggle,
    required this.onEndCall,
  });

  final bool isMuted;
  final VoidCallback onMuteToggle;
  final VoidCallback onEndCall;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Mute button
        _ControlButton(
          icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
          label: isMuted ? context.l10n.voiceUnmute : context.l10n.voiceMute,
          onTap: onMuteToggle,
          isActive: isMuted,
          activeColor: AppColors.neutral600,
        ),

        SizedBox(width: 32.w),

        // End call button
        _EndCallButton(onTap: onEndCall),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isActive,
    required this.activeColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withValues(alpha: 0.2)
                  : AppColors.neutral800,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? activeColor.withValues(alpha: 0.4)
                    : AppColors.neutral700,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? activeColor : AppColors.neutral300,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: AppColors.neutral400,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _EndCallButton extends StatelessWidget {
  const _EndCallButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68.w,
            height: 68.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.error500, AppColors.error700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.error500.withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.call_end_rounded,
              color: AppColors.white,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            context.l10n.voiceEndCall,
            style: TextStyle(
              color: AppColors.error400,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

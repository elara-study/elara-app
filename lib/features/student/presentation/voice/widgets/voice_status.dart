import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_state.dart'
    as state;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceStatusBar extends StatelessWidget {
  const VoiceStatusBar({
    super.key,
    required this.status,
    required this.elapsedFormatted,
    required this.userTranscript,
    required this.assistantResponse,
  });

  final state.VoiceStatus status;
  final String elapsedFormatted;
  final String? userTranscript;
  final String? assistantResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          elapsedFormatted,
          style: TextStyle(
            color: AppColors.neutral400,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        SizedBox(height: 8.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _statusLabel,
            key: ValueKey(_statusLabel),
            style: TextStyle(
              color: _statusColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: 280.w,
          height: 60.h,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildMessage(),
          ),
        ),
      ],
    );
  }

  String get _statusLabel {
    switch (status) {
      case state.VoiceStatus.idle:
        return 'Tap to start';
      case state.VoiceStatus.connecting:
        return 'Connecting…';
      case state.VoiceStatus.listening:
        return 'Listening… Tap orb to send';
      case state.VoiceStatus.transcribing:
        return 'Transcribing…';
      case state.VoiceStatus.thinking:
        return 'Thinking…';
      case state.VoiceStatus.speaking:
        return 'Speaking… Tap orb to interrupt';
      case state.VoiceStatus.paused:
        return 'Paused';
      case state.VoiceStatus.error:
        return 'Tap to retry';
    }
  }

  Color get _statusColor {
    switch (status) {
      case state.VoiceStatus.idle:
        return AppColors.neutral400;
      case state.VoiceStatus.connecting:
        return AppColors.brandPrimary300;
      case state.VoiceStatus.listening:
        return AppColors.success400;
      case state.VoiceStatus.transcribing:
        return AppColors.brandAccent400;
      case state.VoiceStatus.thinking:
        return AppColors.brandAccent400;
      case state.VoiceStatus.speaking:
        return AppColors.brandSecondary400;
      case state.VoiceStatus.paused:
        return AppColors.neutral500;
      case state.VoiceStatus.error:
        return AppColors.error400;
    }
  }

  Widget _buildMessage() {
    if (assistantResponse != null) {
      return Text(
        assistantResponse!,
        key: const ValueKey('assistant'),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.neutral200,
          fontSize: 14.sp,
          height: 1.4,
        ),
      );
    }

    if (userTranscript != null) {
      return Text(
        '"$userTranscript"',
        key: const ValueKey('user'),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.neutral300,
          fontSize: 14.sp,
          fontStyle: FontStyle.italic,
          height: 1.4,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

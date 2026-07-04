import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_state.dart'
    as state;
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          elapsedFormatted,
          style: TextStyle(
            color: isDark ? AppColors.neutral400 : AppColors.neutral500,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        SizedBox(height: 8.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _getStatusLabel(context),
            key: ValueKey(_getStatusLabel(context)),
            style: TextStyle(
              color: _statusColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: 300.w,
          height: 100.h,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildMessage(isDark),
          ),
        ),
      ],
    );
  }

  String _getStatusLabel(BuildContext context) {
    switch (status) {
      case state.VoiceStatus.idle:
        return context.l10n.voiceStatusTapToStart;
      case state.VoiceStatus.connecting:
        return context.l10n.voiceStatusConnecting;
      case state.VoiceStatus.listening:
        return context.l10n.voiceStatusListening;
      case state.VoiceStatus.transcribing:
        return context.l10n.voiceStatusTranscribing;
      case state.VoiceStatus.thinking:
        return context.l10n.voiceStatusThinking;
      case state.VoiceStatus.speaking:
        return context.l10n.voiceStatusSpeaking;
      case state.VoiceStatus.paused:
        return context.l10n.voiceStatusPaused;
      case state.VoiceStatus.error:
        return context.l10n.voiceStatusTapToRetry;
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

  Widget _buildMessage(bool isDark) {
    if (assistantResponse != null) {
      return SingleChildScrollView(
        child: Text(
          assistantResponse!,
          key: const ValueKey('assistant'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppColors.neutral200 : AppColors.neutral700,
            fontSize: 14.sp,
            height: 1.5,
          ),
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
          color: isDark ? AppColors.neutral300 : AppColors.neutral600,
          fontSize: 14.sp,
          fontStyle: FontStyle.italic,
          height: 1.4,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

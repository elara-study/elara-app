import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_cubit.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_state.dart';
import 'package:elara/features/student/presentation/voice/widgets/voice_controls.dart';
import 'package:elara/features/student/presentation/voice/widgets/voice_orb.dart';
import 'package:elara/features/student/presentation/voice/widgets/voice_status.dart';
import 'package:elara/features/student/presentation/voice/widgets/voice_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:elara/core/localization/localization_extension.dart';

class VoiceScreen extends StatelessWidget {
  const VoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VoiceCubit>()..startSession(),
      child: const _VoiceView(),
    );
  }
}

class _VoiceView extends StatelessWidget {
  const _VoiceView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<VoiceCubit, VoiceState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status || curr.status == VoiceStatus.error,
      listener: (context, state) {
        if (state.status == VoiceStatus.error) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.l10n.commonErrorOccurred),
              backgroundColor: AppColors.error600,
              action: SnackBarAction(
                label: context.l10n.commonTryAgain,
                textColor: AppColors.white,
                onPressed: () => context.read<VoiceCubit>().startSession(),
              ),
           AppSnackBar.error(
            context,
            state.errorMessage ?? 'An error occurred',
            action: SnackBarAction(
              label: 'Retry',
              textColor: AppColors.white,
              onPressed: () => context.read<VoiceCubit>().startSession(),
             ),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            await context.read<VoiceCubit>().endSession();
            if (context.mounted) context.pop();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? const [
                          Color(0xFF0B1120),
                          Color(0xFF0F172A),
                          Color(0xFF1A1A2E),
                        ]
                      : const [
                          Color(0xFFF8FAFC),
                          Color(0xFFF1F5F9),
                          Color(0xFFE2E8F0),
                        ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark
                              ? AppColors.neutral400
                              : AppColors.neutral600,
                          size: 28.sp,
                        ),
                        onPressed: () async {
                          await context.read<VoiceCubit>().endSession();
                          if (context.mounted) context.pop();
                        },
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Status bar
                    VoiceStatusBar(
                      status: state.status,
                      elapsedFormatted: state.elapsedFormatted,
                      userTranscript: state.userTranscript,
                      assistantResponse: state.assistantResponse,
                    ),

                    SizedBox(height: 32.h),

                    // Waveform
                    VoiceWave(
                      amplitude: state.amplitude,
                      isActive: state.isListening,
                    ),

                    SizedBox(height: 24.h),

                    // Orb — tap to submit or interrupt
                    GestureDetector(
                      onTap: () => context.read<VoiceCubit>().onOrbTap(),
                      child: VoiceOrb(
                        status: state.status,
                        amplitude: state.amplitude,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Controls
                    VoiceControls(
                      isMuted: state.isMuted,
                      onMuteToggle: () =>
                          context.read<VoiceCubit>().toggleMute(),
                      onEndCall: () async {
                        await context.read<VoiceCubit>().endSession();
                        if (context.mounted) context.pop();
                      },
                    ),

                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

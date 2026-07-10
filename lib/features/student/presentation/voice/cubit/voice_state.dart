import 'package:elara/features/student/domain/voice/entities/voice_message_entity.dart';
import 'package:equatable/equatable.dart';

enum VoiceStatus {
  idle,
  connecting,
  listening,
  transcribing,
  thinking,
  speaking,
  paused,
  error,
}

class VoiceState extends Equatable {
  const VoiceState({
    this.status = VoiceStatus.idle,
    this.errorMessage,
    this.userTranscript,
    this.assistantResponse,
    this.amplitude = 0.0,
    this.elapsed = Duration.zero,
    this.isMuted = false,
    this.isSpeakerOn = true,
    this.conversation = const [],
  });

  final VoiceStatus status;
  final String? errorMessage;
  final String? userTranscript;
  final String? assistantResponse;
  final double amplitude;
  final Duration elapsed;
  final bool isMuted;
  final bool isSpeakerOn;
  final List<VoiceMessageEntity> conversation;

  bool get isListening => status == VoiceStatus.listening;
  bool get isSpeaking => status == VoiceStatus.speaking;
  bool get isProcessing =>
      status == VoiceStatus.transcribing || status == VoiceStatus.thinking;
  bool get isActive => status != VoiceStatus.idle && status != VoiceStatus.error;

  String get elapsedFormatted {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get statusLabel {
    switch (status) {
      case VoiceStatus.idle:
        return 'Tap to start';
      case VoiceStatus.connecting:
        return 'Connecting…';
      case VoiceStatus.listening:
        return isMuted ? 'Microphone muted' : 'Listening…';
      case VoiceStatus.transcribing:
        return 'Transcribing…';
      case VoiceStatus.thinking:
        return 'Thinking…';
      case VoiceStatus.speaking:
        return 'Speaking…';
      case VoiceStatus.paused:
        return 'Paused';
      case VoiceStatus.error:
        return errorMessage ?? 'Something went wrong';
    }
  }

  VoiceState copyWith({
    VoiceStatus? status,
    String? errorMessage,
    String? userTranscript,
    String? assistantResponse,
    double? amplitude,
    Duration? elapsed,
    bool? isMuted,
    bool? isSpeakerOn,
    List<VoiceMessageEntity>? conversation,
  }) {
    return VoiceState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userTranscript: userTranscript ?? this.userTranscript,
      assistantResponse: assistantResponse ?? this.assistantResponse,
      amplitude: amplitude ?? this.amplitude,
      elapsed: elapsed ?? this.elapsed,
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      conversation: conversation ?? this.conversation,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        userTranscript,
        assistantResponse,
        amplitude,
        elapsed,
        isMuted,
        isSpeakerOn,
        conversation,
      ];
}

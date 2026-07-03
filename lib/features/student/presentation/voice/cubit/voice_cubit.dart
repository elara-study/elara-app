import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:elara/core/utils/logger.dart';
import 'package:elara/features/student/domain/voice/entities/voice_message_entity.dart';
import 'package:elara/features/student/domain/voice/usecases/generate_response_use_case.dart';
import 'package:elara/features/student/domain/voice/usecases/synthesize_speech_use_case.dart';
import 'package:elara/features/student/domain/voice/usecases/transcribe_audio_use_case.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceCubit extends Cubit<VoiceState> {
  VoiceCubit({
    required TranscribeAudioUseCase transcribeAudio,
    required GenerateResponseUseCase generateResponse,
    required SynthesizeSpeechUseCase synthesizeSpeech,
  })  : _transcribeAudio = transcribeAudio,
        _generateResponse = generateResponse,
        _synthesizeSpeech = synthesizeSpeech,
        super(const VoiceState());

  final TranscribeAudioUseCase _transcribeAudio;
  final GenerateResponseUseCase _generateResponse;
  final SynthesizeSpeechUseCase _synthesizeSpeech;

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  Timer? _amplitudeTimer;
  Timer? _elapsedTimer;
  Timer? _silenceTimer;
  bool _isRecording = false;
  bool _isProcessing = false;
  bool _disposed = false;
  String? _currentRecordingPath;

  static const _silenceTimeout = Duration(seconds: 5);

  final List<Map<String, String>> _conversationHistory = [];

  // ── Public API ──────────────────────────────────────────────────────

  Future<void> startSession() async {
    if (state.isActive) return;

    emit(const VoiceState(status: VoiceStatus.connecting));

    try {
      await _configureAudioSession();
      final granted = await _requestPermission();
      if (!granted) {
        emit(const VoiceState(
          status: VoiceStatus.error,
          errorMessage: 'Microphone permission is required for voice mode.',
        ));
        return;
      }

      emit(state.copyWith(status: VoiceStatus.listening));
      _startElapsedTimer();
      await _startRecording();
    } catch (e, st) {
      AppLogger.error('Failed to start session', e, st);
      emit(VoiceState(
        status: VoiceStatus.error,
        errorMessage: 'Failed to start voice session: $e',
      ));
    }
  }

  void onOrbTap() {
    if (state.status == VoiceStatus.speaking) {
      interruptSpeaking();
    } else if (state.status == VoiceStatus.listening) {
      _submitRecording();
    } else if (state.status == VoiceStatus.error) {
      startSession();
    }
  }

  void interruptSpeaking() {
    if (state.status != VoiceStatus.speaking) return;
    _player.stop();
    emit(state.copyWith(
      status: VoiceStatus.listening,
      assistantResponse: null,
    ));
    _startRecording();
  }

  void toggleMute() {
    if (!state.isActive) return;
    final newMuted = !state.isMuted;
    emit(state.copyWith(isMuted: newMuted));

    if (newMuted && _isRecording) {
      _pauseRecording();
    } else if (!newMuted && state.isListening) {
      _resumeRecording();
    }
  }

  Future<void> endSession() async {
    await _stopTimers();
    await _stopRecording();
    await _player.stop();
    _conversationHistory.clear();

    if (!_disposed) {
      emit(const VoiceState());
    }
  }

  // ── Recording ───────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) {
      AppLogger.info('Recording: no permission');
      return;
    }

    // Reconfigure audio session for recording after playback
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
      ));
    } catch (_) {}

    final dir = Directory.systemTemp;
    _currentRecordingPath =
        '${dir.path}/elara_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
      numChannels: 1,
    );

    try {
      await _recorder.start(config, path: _currentRecordingPath!);
      _isRecording = true;
      AppLogger.info('Recording started');
    } catch (e) {
      AppLogger.error('Recording start failed', e, StackTrace.current);
      return;
    }

    // Poll amplitude via timer to avoid stream reuse issues
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      if (_disposed || !_isRecording) return;
      try {
        final amp = await _recorder.getAmplitude();
        final normalized = ((amp.current + 160) / 160).clamp(0.0, 1.0);
        emit(state.copyWith(amplitude: normalized));
      } catch (_) {}
    });

    _resetSilenceTimer();
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(_silenceTimeout, () {
      AppLogger.info('Silence timer fired: disposed=$_disposed, recording=$_isRecording, listening=${state.isListening}, muted=${state.isMuted}');
      if (!_disposed && _isRecording && state.isListening && !state.isMuted) {
        _onSilenceDetected();
      }
    });
  }

  Future<void> _onSilenceDetected() async {
    if (!_isRecording) {
      AppLogger.info('Silence: not recording, skip');
      return;
    }

    AppLogger.info('Silence detected, stopping recording');
    final path = _currentRecordingPath;
    await _stopRecording();

    if (_disposed || path == null) {
      AppLogger.info('Silence: disposed or no path');
      return;
    }

    final file = File(path);
    if (!await file.exists()) {
      AppLogger.info('Silence: file not found, restarting');
      if (!_disposed && state.isListening) {
        await _startRecording();
      }
      return;
    }

    final bytes = await file.readAsBytes();
    AppLogger.info('Silence: read ${bytes.length} bytes');
    await file.delete();

    if (bytes.isEmpty) {
      AppLogger.info('Silence: empty bytes, restarting');
      if (!_disposed && state.isListening) {
        await _startRecording();
      }
      return;
    }

    AppLogger.info('Silence: processing ${bytes.length} bytes');
    _processAudio(bytes);
  }

  Future<void> _submitRecording() async {
    if (!_isRecording) return;

    AppLogger.log('User tapped to submit recording');
    final path = _currentRecordingPath;
    await _stopRecording();

    if (_disposed || path == null) return;

    final file = File(path);
    if (!await file.exists()) {
      if (!_disposed && state.isListening) {
        await _startRecording();
      }
      return;
    }

    final bytes = await file.readAsBytes();
    await file.delete();

    if (bytes.isEmpty) {
      if (!_disposed && state.isListening) {
        await _startRecording();
      }
      return;
    }

    _processAudio(bytes);
  }

  Future<void> _pauseRecording() async {
    if (_isRecording) {
      await _recorder.pause();
      _silenceTimer?.cancel();
    }
  }

  Future<void> _resumeRecording() async {
    if (_isRecording) {
      await _recorder.resume();
      _resetSilenceTimer();
    }
  }

  Future<void> _stopRecording() async {
    _silenceTimer?.cancel();
    _amplitudeTimer?.cancel();
    if (_isRecording) {
      try {
        await _recorder.stop();
      } catch (_) {}
      _isRecording = false;
    }
  }

  // ── Audio Processing Pipeline ───────────────────────────────────────

  Future<void> _processAudio(Uint8List audioBytes) async {
    if (_disposed || _isProcessing) return;
    _isProcessing = true;

    try {
      AppLogger.info('Pipeline: transcribing...');
      emit(state.copyWith(status: VoiceStatus.transcribing));
      final transcript = await _transcribeAudio(audioBytes);

      if (_disposed) return;

      if (transcript.trim().isEmpty) {
        AppLogger.info('Pipeline: empty transcript, restarting');
        _isProcessing = false;
        emit(state.copyWith(
          status: VoiceStatus.listening,
          userTranscript: null,
        ));
        await _startRecording();
        return;
      }

      AppLogger.info('Pipeline: transcript="$transcript", generating response...');
      emit(state.copyWith(userTranscript: transcript));

      emit(state.copyWith(status: VoiceStatus.thinking));
      final response = await _generateResponse(
        userMessage: transcript,
        conversationHistory: _conversationHistory,
      );

      if (_disposed) return;

      AppLogger.info('Pipeline: response received, synthesizing...');
      _conversationHistory.add({'role': 'user', 'content': transcript});
      _conversationHistory.add({'role': 'assistant', 'content': response});

      if (_conversationHistory.length > 40) {
        _conversationHistory.removeRange(0, _conversationHistory.length - 40);
      }

      final speechBytes = await _synthesizeSpeech(response);

      if (_disposed) return;

      AppLogger.info('Pipeline: speech synthesized, playing...');
      // Show response AND start speaking simultaneously
      final message = VoiceMessageEntity(
        userTranscript: transcript,
        assistantResponse: response,
        timestamp: DateTime.now(),
      );
      final updatedConversation = [...state.conversation, message];

      emit(state.copyWith(
        status: VoiceStatus.speaking,
        assistantResponse: response,
        conversation: updatedConversation,
      ));

      await _playAudio(speechBytes);

      if (_disposed) return;

      AppLogger.info('Pipeline: playback done, restarting recording');
      emit(state.copyWith(
        status: VoiceStatus.listening,
        userTranscript: null,
        assistantResponse: null,
      ));

      _isProcessing = false;
      await _startRecording();
    } catch (e, st) {
      AppLogger.error('Pipeline failed', e, st);
      _isProcessing = false;
      if (!_disposed) {
        emit(state.copyWith(
          status: VoiceStatus.error,
          errorMessage: 'Voice processing failed. Tap to retry.',
        ));
      }
    }
  }

  Future<void> _playAudio(Uint8List audioBytes) async {
    try {
      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/elara_tts_${DateTime.now().millisecondsSinceEpoch}.mp3',
      );
      await tempFile.writeAsBytes(audioBytes);
      final fileSize = await tempFile.length();
      AppLogger.info('TTS saved: ${tempFile.path} ($fileSize bytes)');

      // Reconfigure audio session for playback
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      AppLogger.info('Audio session configured for playback');

      await _player.setFilePath(tempFile.path);
      AppLogger.info('Player file path set');

      await _player.setVolume(1.0);
      await _player.play();
      AppLogger.info('Playback started');

      await _player.processingStateStream
          .firstWhere((s) => s == ProcessingState.completed)
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () => ProcessingState.completed,
      );
      AppLogger.info('Playback completed');
    } catch (e, st) {
      AppLogger.error('Audio playback failed', e, st);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_disposed && state.isActive) {
        emit(state.copyWith(
          elapsed: state.elapsed + const Duration(seconds: 1),
        ));
      }
    });
  }

  Future<void> _stopTimers() async {
    _elapsedTimer?.cancel();
    _silenceTimer?.cancel();
    _amplitudeTimer?.cancel();
  }

  @override
  Future<void> close() async {
    _disposed = true;
    await _stopTimers();
    await _recorder.dispose();
    await _player.dispose();
    return super.close();
  }
}

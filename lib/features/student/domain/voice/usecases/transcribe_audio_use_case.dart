import 'dart:typed_data';

import 'package:elara/features/student/domain/voice/repositories/voice_repository.dart';

class TranscribeAudioUseCase {
  const TranscribeAudioUseCase(this._repository);

  final VoiceRepository _repository;

  Future<String> call(Uint8List audioBytes) {
    return _repository.transcribeAudio(audioBytes);
  }
}

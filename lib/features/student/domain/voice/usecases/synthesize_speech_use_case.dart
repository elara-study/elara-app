import 'dart:typed_data';

import 'package:elara/features/student/domain/voice/repositories/voice_repository.dart';

class SynthesizeSpeechUseCase {
  const SynthesizeSpeechUseCase(this._repository);

  final VoiceRepository _repository;

  Future<Uint8List> call(String text) {
    return _repository.synthesizeSpeech(text);
  }
}

import 'package:elara/features/student/data/voice/datasources/voice_deepgram_data_source.dart';
import 'package:elara/features/student/data/voice/datasources/voice_elevenlabs_data_source.dart';
import 'package:elara/features/student/data/voice/datasources/voice_gemini_data_source.dart';
import 'package:elara/features/student/data/voice/repositories/voice_repository_impl.dart';
import 'package:elara/features/student/domain/voice/repositories/voice_repository.dart';
import 'package:elara/features/student/domain/voice/usecases/generate_response_use_case.dart';
import 'package:elara/features/student/domain/voice/usecases/synthesize_speech_use_case.dart';
import 'package:elara/features/student/domain/voice/usecases/transcribe_audio_use_case.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupVoiceDI() {
  // DataSources
  getIt.registerLazySingleton<VoiceDeepgramDataSource>(
    () => VoiceDeepgramDataSource(),
  );
  getIt.registerLazySingleton<VoiceGeminiDataSource>(
    () => VoiceGeminiDataSource(),
  );
  getIt.registerLazySingleton<VoiceElevenLabsDataSource>(
    () => VoiceElevenLabsDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<VoiceRepository>(
    () => VoiceRepositoryImpl(
      getIt<VoiceDeepgramDataSource>(),
      getIt<VoiceGeminiDataSource>(),
      getIt<VoiceElevenLabsDataSource>(),
    ),
  );

  // UseCases
  getIt.registerLazySingleton(
    () => TranscribeAudioUseCase(getIt<VoiceRepository>()),
  );
  getIt.registerLazySingleton(
    () => GenerateResponseUseCase(getIt<VoiceRepository>()),
  );
  getIt.registerLazySingleton(
    () => SynthesizeSpeechUseCase(getIt<VoiceRepository>()),
  );

  // Cubit — factory so each screen entry gets a fresh instance
  getIt.registerFactory(
    () => VoiceCubit(
      transcribeAudio: getIt<TranscribeAudioUseCase>(),
      generateResponse: getIt<GenerateResponseUseCase>(),
      synthesizeSpeech: getIt<SynthesizeSpeechUseCase>(),
    ),
  );
}

import 'package:equatable/equatable.dart';

class VoiceMessageEntity extends Equatable {
  const VoiceMessageEntity({
    required this.userTranscript,
    required this.assistantResponse,
    required this.timestamp,
  });

  final String userTranscript;
  final String assistantResponse;
  final DateTime timestamp;

  @override
  List<Object?> get props => [userTranscript, assistantResponse, timestamp];
}

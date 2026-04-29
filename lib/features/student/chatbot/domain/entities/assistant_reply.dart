import 'package:equatable/equatable.dart';

/// Assistant payload returned after send-message (text or image).
class AssistantReply extends Equatable {
  const AssistantReply({required this.message, this.choices});

  final String message;
  final List<String>? choices;

  @override
  List<Object?> get props => [message, choices];
}

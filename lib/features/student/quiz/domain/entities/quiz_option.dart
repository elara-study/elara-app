import 'package:equatable/equatable.dart';

class QuizOption extends Equatable {
  const QuizOption({required this.id, required this.label});

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

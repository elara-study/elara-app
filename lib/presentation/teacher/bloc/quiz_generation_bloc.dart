import 'package:bloc/bloc.dart';
import 'package:elara/domain/models/quiz.dart';
import 'package:elara/domain/services/ai_service.dart';
import 'package:equatable/equatable.dart';

part 'quiz_generation_event.dart';
part 'quiz_generation_state.dart';

class QuizGenerationBloc extends Bloc<QuizGenerationEvent, QuizGenerationState> {
  final AiService _aiService;

  QuizGenerationBloc(this._aiService) : super(QuizGenerationInitial()) {
    on<GenerateQuizRequested>(_onGenerateQuizRequested);
  }

  Future<void> _onGenerateQuizRequested(
    GenerateQuizRequested event,
    Emitter<QuizGenerationState> emit,
  ) async {
    emit(QuizGenerationLoading());
    try {
      final quiz = await _aiService.generateQuiz(
        topic: event.topic,
        count: event.count,
        difficulty: event.difficulty,
        type: event.type,
      );
      emit(QuizGenerationSuccess(quiz));
    } catch (e) {
      emit(QuizGenerationFailure(e.toString()));
    }
  }
}

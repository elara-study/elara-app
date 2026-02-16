import 'package:bloc/bloc.dart';
import 'package:elara/domain/models/essay_submission.dart';
import 'package:elara/domain/models/rubric.dart';
import 'package:elara/domain/services/ai_service.dart';
import 'package:equatable/equatable.dart';

part 'essay_grading_event.dart';
part 'essay_grading_state.dart';

class EssayGradingBloc extends Bloc<EssayGradingEvent, EssayGradingState> {
  final AiService _aiService;

  EssayGradingBloc(this._aiService) : super(EssayGradingInitial()) {
    on<GradeEssayRequested>(_onGradeEssayRequested);
  }

  Future<void> _onGradeEssayRequested(
    GradeEssayRequested event,
    Emitter<EssayGradingState> emit,
  ) async {
    emit(EssayGradingLoading());
    try {
      final result = await _aiService.gradeEssay(event.essayContent, event.rubric);
      emit(EssayGradingSuccess(result));
    } catch (e) {
      emit(EssayGradingFailure(e.toString()));
    }
  }
}

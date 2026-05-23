import 'package:elara/features/parent/domain/children/usecases/get_parent_child_insights_usecase.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_insights_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentChildInsightsCubit extends Cubit<ParentChildInsightsState> {
  final GetParentChildInsightsUseCase _getInsightsUseCase;

  ParentChildInsightsCubit(this._getInsightsUseCase) : super(ParentChildInsightsInitial());

  Future<void> loadInsights(String childId) async {
    emit(ParentChildInsightsLoading());
    try {
      final insights = await _getInsightsUseCase(childId);
      emit(ParentChildInsightsLoaded(insights));
    } catch (e) {
      emit(ParentChildInsightsError(e.toString()));
    }
  }
}

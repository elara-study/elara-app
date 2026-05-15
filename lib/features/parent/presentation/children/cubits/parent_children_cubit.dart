import 'package:elara/features/parent/domain/home/usecases/get_parent_children_dashboard_use_case.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentChildrenCubit extends Cubit<ParentChildrenState> {
  ParentChildrenCubit({
    required GetParentChildrenDashboardUseCase getChildrenDashboard,
  }) : _getChildrenDashboard = getChildrenDashboard,
       super(const ParentChildrenInitial());

  final GetParentChildrenDashboardUseCase _getChildrenDashboard;

  Future<void> loadChildren() async {
    if (isClosed) return;
    emit(const ParentChildrenLoading());
    try {
      final dashboard = await _getChildrenDashboard();
      if (isClosed) return;
      emit(ParentChildrenLoaded(dashboard));
    } catch (e) {
      if (isClosed) return;
      emit(ParentChildrenError(e.toString()));
    }
  }
}

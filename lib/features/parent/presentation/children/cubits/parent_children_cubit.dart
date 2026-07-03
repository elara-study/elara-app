import 'package:elara/features/parent/domain/home/usecases/get_parent_children_dashboard_use_case.dart';
import 'package:elara/features/parent/domain/home/usecases/link_student_use_case.dart';
import 'package:elara/features/parent/domain/home/usecases/respond_to_request_use_case.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentChildrenCubit extends Cubit<ParentChildrenState> {
  ParentChildrenCubit({
    required GetParentChildrenDashboardUseCase getChildrenDashboard,
    required LinkStudentUseCase linkStudent,
    required RespondToRequestUseCase respondToRequest,
  }) : _getChildrenDashboard = getChildrenDashboard,
       _linkStudent = linkStudent,
       _respondToRequest = respondToRequest,
       super(const ParentChildrenInitial());

  final GetParentChildrenDashboardUseCase _getChildrenDashboard;
  final LinkStudentUseCase _linkStudent;
  final RespondToRequestUseCase _respondToRequest;

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

  Future<void> linkChild(String username) async {
    if (isClosed) return;
    emit(const ParentChildrenLoading());
    try {
      await _linkStudent(username);
      await loadChildren();
    } catch (e) {
      if (isClosed) return;
      emit(ParentChildrenError(e.toString()));
    }
  }

  Future<void> respondToPendingRequest(String requestId, bool accept) async {
    if (isClosed) return;
    emit(const ParentChildrenLoading());
    try {
      await _respondToRequest(requestId: requestId, accept: accept);
      await loadChildren();
    } catch (e) {
      if (isClosed) return;
      emit(ParentChildrenError(e.toString()));
    }
  }
}

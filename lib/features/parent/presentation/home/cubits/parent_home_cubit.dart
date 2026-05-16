import 'package:elara/features/parent/domain/home/usecases/get_parent_home_use_case.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentHomeCubit extends Cubit<ParentHomeState> {
  ParentHomeCubit({required GetParentHomeUseCase getParentHomeUseCase})
    : _getParentHomeUseCase = getParentHomeUseCase,
      super(const ParentHomeInitial());

  final GetParentHomeUseCase _getParentHomeUseCase;

  Future<void> loadHome() async {
    if (isClosed) return;
    emit(const ParentHomeLoading());
    try {
      final overview = await _getParentHomeUseCase();
      if (isClosed) return;
      emit(ParentHomeLoaded(overview));
    } catch (e) {
      if (isClosed) return;
      emit(ParentHomeError(e.toString()));
    }
  }
}

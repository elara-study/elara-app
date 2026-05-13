import 'package:elara/features/parent/domain/reports/usecases/get_parent_reports_use_case.dart';
import 'package:elara/features/parent/presentation/reports/cubits/parent_reports_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentReportsCubit extends Cubit<ParentReportsState> {
  ParentReportsCubit({required GetParentReportsUseCase getParentReports})
    : _getParentReports = getParentReports,
      super(const ParentReportsInitial());

  final GetParentReportsUseCase _getParentReports;

  Future<void> loadReports() async {
    if (isClosed) return;
    emit(const ParentReportsLoading());
    try {
      final overview = await _getParentReports();
      if (isClosed) return;
      emit(ParentReportsLoaded(overview));
    } catch (e) {
      if (isClosed) return;
      emit(ParentReportsError(e.toString()));
    }
  }
}

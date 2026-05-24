import 'package:elara/features/parent/domain/children/entities/parent_homework_status.dart';
import 'package:elara/features/parent/domain/children/usecases/get_parent_child_homeworks_use_case.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_homework_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit that loads and manages the homework list for a specific child.
class ParentChildHomeworkCubit extends Cubit<ParentChildHomeworkState> {
  ParentChildHomeworkCubit({
    required GetParentChildHomeworksUseCase getHomeworks,
  }) : _getHomeworks = getHomeworks,
       super(const ParentChildHomeworkInitial());

  final GetParentChildHomeworksUseCase _getHomeworks;

  Future<void> loadHomeworks(String childId) async {
    emit(const ParentChildHomeworkLoading());
    try {
      final homeworks = await _getHomeworks(childId);

      final submittedCount = homeworks
          .where((hw) => hw.status == ParentHomeworkStatus.submitted)
          .length;
      final gradedCount = homeworks
          .where((hw) => hw.status == ParentHomeworkStatus.graded)
          .length;

      emit(
        ParentChildHomeworkLoaded(
          homeworks: homeworks,
          totalCount: homeworks.length,
          submittedCount: submittedCount,
          gradedCount: gradedCount,
        ),
      );
    } catch (e) {
      emit(ParentChildHomeworkError(e.toString()));
    }
  }
}

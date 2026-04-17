import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Manages the active bottom-nav tab index for the student shell.
///
/// Any screen inside the shell can call [goToTab] or convenience methods
/// like [goToLearn] via `context.read<StudentTabCubit>()`.
@injectable
class StudentTabCubit extends Cubit<int> {
  StudentTabCubit() : super(0);

  void goToTab(int index) {
    if (isClosed) return;
    emit(index);
  }

  void goToLearn() => goToTab(1);
  void goToRewards() => goToTab(2);
  void goToAlerts() => goToTab(3);
  void goToProfile() => goToTab(4);
}

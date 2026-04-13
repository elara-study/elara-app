import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Manages the active bottom-nav tab index for the student shell.
///
/// Any screen inside the shell can call [goToTab] or convenience methods
/// like [goToLearn] via `context.read<StudentTabCubit>()`.
@injectable
class StudentTabCubit extends Cubit<int> {
  StudentTabCubit() : super(0);

  void goToTab(int index) => emit(index);

  void goToLearn() => emit(1);
  void goToRewards() => emit(2);
  void goToAlerts() => emit(3);
  void goToProfile() => emit(4);
}

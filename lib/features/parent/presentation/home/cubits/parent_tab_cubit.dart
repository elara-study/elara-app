import 'package:flutter_bloc/flutter_bloc.dart';

/// Bottom navigation index for [ParentShell].
class ParentTabCubit extends Cubit<int> {
  ParentTabCubit() : super(0);

  void goToTab(int index) {
    if (isClosed) return;
    emit(index);
  }
}

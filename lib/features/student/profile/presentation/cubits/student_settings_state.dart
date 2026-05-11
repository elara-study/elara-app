import 'package:equatable/equatable.dart';

/// UI snack + navigation flags for [StudentSettingsScreen].
class StudentSettingsState extends Equatable {
  const StudentSettingsState({
    this.pendingSnackMessage,
    this.shouldNavigateToLogin = false,
  });

  final String? pendingSnackMessage;
  final bool shouldNavigateToLogin;

  StudentSettingsState copyWith({
    String? pendingSnackMessage,
    bool clearSnackMessage = false,
    bool? shouldNavigateToLogin,
  }) {
    return StudentSettingsState(
      pendingSnackMessage: clearSnackMessage
          ? null
          : (pendingSnackMessage ?? this.pendingSnackMessage),
      shouldNavigateToLogin:
          shouldNavigateToLogin ?? this.shouldNavigateToLogin,
    );
  }

  @override
  List<Object?> get props => [pendingSnackMessage, shouldNavigateToLogin];
}

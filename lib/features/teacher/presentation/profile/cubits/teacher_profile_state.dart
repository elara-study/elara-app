import 'package:elara/features/teacher/domain/dashboard/entities/teacher_profile_entity.dart';
import 'package:equatable/equatable.dart';

class TeacherProfileState extends Equatable {
  final String? pendingSnackMessage;
  final bool shouldNavigateToLogin;
  final bool isLoading;
  final String? errorMessage;
  final TeacherProfileEntity? profileData;

  const TeacherProfileState({
    this.pendingSnackMessage,
    this.shouldNavigateToLogin = false,
    this.isLoading = false,
    this.errorMessage,
    this.profileData,
  });

  TeacherProfileState copyWith({
    String? pendingSnackMessage,
    bool clearSnackMessage = false,
    bool? shouldNavigateToLogin,
    bool? isLoading,
    String? errorMessage,
    TeacherProfileEntity? profileData,
  }) {
    return TeacherProfileState(
      pendingSnackMessage: clearSnackMessage
          ? null
          : (pendingSnackMessage ?? this.pendingSnackMessage),
      shouldNavigateToLogin:
          shouldNavigateToLogin ?? this.shouldNavigateToLogin,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      profileData: profileData ?? this.profileData,
    );
  }

  @override
  List<Object?> get props => [
    pendingSnackMessage,
    shouldNavigateToLogin,
    isLoading,
    errorMessage,
    profileData,
  ];
}

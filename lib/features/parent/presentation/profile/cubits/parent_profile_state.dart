import 'package:elara/features/parent/domain/profile/entities/parent_profile_entity.dart';
import 'package:equatable/equatable.dart';

class ParentProfileState extends Equatable {
  final String? pendingSnackMessage;
  final bool shouldNavigateToLogin;
  final bool isLoading;
  final String? errorMessage;
  final ParentProfileEntity? profileData;

  const ParentProfileState({
    this.pendingSnackMessage,
    this.shouldNavigateToLogin = false,
    this.isLoading = false,
    this.errorMessage,
    this.profileData,
  });

  ParentProfileState copyWith({
    String? pendingSnackMessage,
    bool clearSnackMessage = false,
    bool? shouldNavigateToLogin,
    bool? isLoading,
    String? errorMessage,
    ParentProfileEntity? profileData,
  }) {
    return ParentProfileState(
      pendingSnackMessage: clearSnackMessage ? null : (pendingSnackMessage ?? this.pendingSnackMessage),
      shouldNavigateToLogin: shouldNavigateToLogin ?? this.shouldNavigateToLogin,
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

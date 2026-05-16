import 'package:elara/features/settings/domain/entities/profile_account_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ProfileAccountState extends Equatable {
  const ProfileAccountState();

  @override
  List<Object?> get props => [];
}

class ProfileAccountInitial extends ProfileAccountState {
  const ProfileAccountInitial();
}

class ProfileAccountLoading extends ProfileAccountState {
  const ProfileAccountLoading();
}

class ProfileAccountLoaded extends ProfileAccountState {
  const ProfileAccountLoaded({required this.profile, this.pendingSnackMessage});

  final ProfileAccountEntity profile;
  final String? pendingSnackMessage;

  ProfileAccountLoaded copyWith({
    ProfileAccountEntity? profile,
    String? pendingSnackMessage,
    bool clearSnackMessage = false,
  }) {
    return ProfileAccountLoaded(
      profile: profile ?? this.profile,
      pendingSnackMessage: clearSnackMessage
          ? null
          : (pendingSnackMessage ?? this.pendingSnackMessage),
    );
  }

  @override
  List<Object?> get props => [profile, pendingSnackMessage];
}

class ProfileAccountError extends ProfileAccountState {
  const ProfileAccountError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

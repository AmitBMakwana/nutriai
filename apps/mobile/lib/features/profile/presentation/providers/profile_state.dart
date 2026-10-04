import '../../../auth/domain/entities/user_entity.dart';
import '../../../onboarding/domain/entities/user_profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final bool isUpdating;
  final bool isUploadingAvatar;
  final bool isChangingPassword;
  final bool isDeletingAccount;
  final UserProfileEntity? profile;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.isLoading = false,
    this.isUpdating = false,
    this.isUploadingAvatar = false,
    this.isChangingPassword = false,
    this.isDeletingAccount = false,
    this.profile,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  factory ProfileState.initial() => const ProfileState();

  ProfileState copyWith({
    bool? isLoading,
    bool? isUpdating,
    bool? isUploadingAvatar,
    bool? isChangingPassword,
    bool? isDeletingAccount,
    UserProfileEntity? profile,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      profile: profile ?? this.profile,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

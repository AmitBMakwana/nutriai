import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../nutrition/presentation/providers/nutrition_goal_provider.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

final profileNotifierProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    final user = ref.watch(authNotifierProvider).user;
    return ProfileState(user: user);
  }

  IProfileRepository get _repository => ref.read(profileRepositoryProvider);

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profile = await _repository.getProfile();
      final user = ref.read(authNotifierProvider).user;
      state = state.copyWith(
        isLoading: false,
        profile: profile,
        user: user,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> updateProfile(
    Map<String, dynamic> data, {
    bool recalculateGoals = false,
  }) async {
    state = state.copyWith(isUpdating: true, clearError: true, clearSuccess: true);
    try {
      final updatedProfile = await _repository.updateProfile(
        data,
        recalculateGoals: recalculateGoals,
      );

      // If user's name changed, update local UserEntity
      if (data.containsKey('name') && state.user != null) {
        final updatedUser = state.user!.copyWith(name: data['name'] as String);
        state = state.copyWith(user: updatedUser);
      }

      state = state.copyWith(
        isUpdating: false,
        profile: updatedProfile,
        successMessage: 'Profile updated successfully',
      );

      if (recalculateGoals) {
        await ref.read(nutritionGoalNotifierProvider.notifier).loadActiveGoal();
      }

      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isUpdating: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isUpdating: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> uploadAvatar(File imageFile) async {
    state = state.copyWith(isUploadingAvatar: true, clearError: true, clearSuccess: true);
    try {
      final updatedUser = await _repository.uploadAvatar(imageFile);
      state = state.copyWith(
        isUploadingAvatar: false,
        user: updatedUser,
        successMessage: 'Avatar updated successfully',
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isUploadingAvatar: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isUploadingAvatar: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(isChangingPassword: true, clearError: true, clearSuccess: true);
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      state = state.copyWith(
        isChangingPassword: false,
        successMessage: 'Password changed successfully',
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isChangingPassword: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isChangingPassword: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteAccount({String? password, bool confirmation = true}) async {
    state = state.copyWith(isDeletingAccount: true, clearError: true);
    try {
      await _repository.deleteAccount(password: password, confirmation: confirmation);
      state = state.copyWith(isDeletingAccount: false);

      // Perform user logout after account removal
      await ref.read(authNotifierProvider.notifier).logout();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isDeletingAccount: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isDeletingAccount: false, errorMessage: e.toString());
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

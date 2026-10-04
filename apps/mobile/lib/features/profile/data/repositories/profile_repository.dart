import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../onboarding/domain/entities/user_profile_entity.dart';
import '../datasources/profile_api_datasource.dart';

abstract class IProfileRepository {
  Future<UserProfileEntity> getProfile();
  Future<UserProfileEntity> updateProfile(Map<String, dynamic> data, {bool recalculateGoals = false});
  Future<UserEntity> uploadAvatar(File imageFile);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });
  Future<void> deleteAccount({String? password, bool confirmation = true});
}

final profileApiDataSourceProvider = Provider<IProfileApiDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProfileApiDataSource(dioClient);
});

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final dataSource = ref.watch(profileApiDataSourceProvider);
  return ProfileRepository(dataSource);
});

class ProfileRepository implements IProfileRepository {
  final IProfileApiDataSource _dataSource;

  ProfileRepository(this._dataSource);

  @override
  Future<UserProfileEntity> getProfile() => _dataSource.getProfile();

  @override
  Future<UserProfileEntity> updateProfile(
    Map<String, dynamic> data, {
    bool recalculateGoals = false,
  }) {
    final payload = Map<String, dynamic>.from(data);
    if (recalculateGoals) {
      payload['recalculate_goals'] = true;
    }
    return _dataSource.updateProfile(payload);
  }

  @override
  Future<UserEntity> uploadAvatar(File imageFile) => _dataSource.uploadAvatar(imageFile);

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) =>
      _dataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );

  @override
  Future<void> deleteAccount({String? password, bool confirmation = true}) =>
      _dataSource.deleteAccount(password: password, confirmation: confirmation);
}

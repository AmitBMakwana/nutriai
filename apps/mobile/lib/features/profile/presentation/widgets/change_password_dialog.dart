import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/profile_notifier.dart';

class ChangePasswordDialog extends ConsumerStatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ConsumerState<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _localError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _localError = null);
    if (!_formKey.currentState!.validate()) return;

    final currentPass = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    final success = await ref.read(profileNotifierProvider.notifier).changePassword(
          currentPassword: currentPass,
          newPassword: newPass,
          passwordConfirmation: confirmPass,
        );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        final error = ref.read(profileNotifierProvider).errorMessage ?? 'Failed to update password';
        setState(() => _localError = error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(profileNotifierProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.r24),
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Padding(
        padding: AppSpacing.p20,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Text(
                      'Change Password',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              if (_localError != null) ...[
                Container(
                  padding: AppSpacing.p12,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: AppRadius.r12,
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _localError!,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                  ),
                ),
                AppSpacing.gapH12,
              ],
              AppTextField(
                controller: _currentPasswordController,
                label: 'Current Password',
                hintText: 'Enter your current password',
                isPassword: true,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Current password is required';
                  return null;
                },
              ),
              AppSpacing.gapH12,
              AppTextField(
                controller: _newPasswordController,
                label: 'New Password',
                hintText: 'At least 8 characters',
                isPassword: true,
                validator: (val) {
                  if (val == null || val.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              AppSpacing.gapH12,
              AppTextField(
                controller: _confirmPasswordController,
                label: 'Confirm New Password',
                hintText: 'Re-enter your new password',
                isPassword: true,
                validator: (val) {
                  if (val != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              AppSpacing.gapH20,
              AppButton.primary(
                text: 'Update Password',
                isLoading: state.isChangingPassword,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

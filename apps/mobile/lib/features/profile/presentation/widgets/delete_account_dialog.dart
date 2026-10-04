import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/profile_notifier.dart';

class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  ConsumerState<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  bool _confirmedCheckbox = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    setState(() => _error = null);

    if (!_confirmedCheckbox) {
      setState(() => _error = 'Please check the box to confirm you understand');
      return;
    }

    final success = await ref.read(profileNotifierProvider.notifier).deleteAccount(
          password: _passwordController.text.trim().isNotEmpty
              ? _passwordController.text.trim()
              : null,
          confirmation: true,
        );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account permanently deleted.'),
            backgroundColor: AppColors.error,
          ),
        );
      } else {
        final err = ref.read(profileNotifierProvider).errorMessage ?? 'Account deletion failed';
        setState(() => _error = err);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.error,
                  size: 36,
                ),
              ),
            ),
            AppSpacing.gapH16,
            Text(
              'Delete Account Forever?',
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.error,
              ),
            ),
            AppSpacing.gapH8,
            Text(
              'This action is irreversible. All of your personal health data, tracked meals, AI photo scans, weight history, and active goals will be permanently purged immediately.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.45,
              ),
            ),
            AppSpacing.gapH16,
            if (_error != null) ...[
              Container(
                padding: AppSpacing.p12,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.r12,
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _error!,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                ),
              ),
              AppSpacing.gapH12,
            ],
            AppTextField(
              controller: _passwordController,
              label: 'Password (Optional confirmation)',
              hintText: 'Enter your password to confirm',
              isPassword: true,
            ),
            AppSpacing.gapH12,
            InkWell(
              onTap: () => setState(() => _confirmedCheckbox = !_confirmedCheckbox),
              borderRadius: AppRadius.r12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Checkbox(
                      value: _confirmedCheckbox,
                      activeColor: AppColors.error,
                      onChanged: (val) => setState(() => _confirmedCheckbox = val ?? false),
                    ),
                    Expanded(
                      child: Text(
                        'I understand that all my data will be permanently deleted and cannot be recovered.',
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapH20,
            AppButton(
              text: 'Delete My Account Permanently',
              backgroundColor: AppColors.error,
              textColor: Colors.white,
              isLoading: state.isDeletingAccount,
              onPressed: _confirmedCheckbox ? _handleDelete : null,
            ),
            AppSpacing.gapH12,
            AppButton.outline(
              text: 'Cancel and Keep Account',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

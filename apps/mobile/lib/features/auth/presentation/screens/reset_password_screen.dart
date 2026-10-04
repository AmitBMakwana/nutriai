import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

/// Reset password screen allowing users to set a new password using a reset token.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? initialEmail;

  const ResetPasswordScreen({
    super.key,
    this.initialEmail,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _success = false;
  String? _errorMessage;
  Map<String, dynamic>? _fieldErrors;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _getFieldError(String field) {
    if (_fieldErrors == null || !_fieldErrors!.containsKey(field)) return null;
    final val = _fieldErrors![field];
    if (val is List && val.isNotEmpty) {
      return val.first.toString();
    } else if (val is String) {
      return val;
    }
    return null;
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _fieldErrors = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).resetPassword(
            email: _emailController.text.trim(),
            token: _tokenController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          );
      if (mounted) {
        setState(() {
          _success = true;
        });
      }
    } on ValidationException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _fieldErrors = e.errors;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.px24,
          child: _success ? _buildSuccessView(isDark) : _buildFormView(isDark),
        ),
      ),
    );
  }

  Widget _buildFormView(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.gapH16,
          Text(
            'Create New Password',
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            'Enter the reset token sent to your email and choose a secure new password.',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.gapH32,

          if (_errorMessage != null) ...[
            Container(
              padding: AppSpacing.p12,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppRadius.r12,
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH20,
          ],

          AppTextField(
            label: 'Email Address',
            hintText: 'name@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
            validator: Validators.validateEmail,
            errorText: _getFieldError('email'),
          ),
          AppSpacing.gapH16,

          AppTextField(
            label: 'Reset Token',
            hintText: 'Paste token from email',
            controller: _tokenController,
            prefixIcon: const Icon(Icons.key_rounded, size: 20),
            validator: (v) => Validators.validateRequired(v, 'Reset token'),
            errorText: _getFieldError('token'),
          ),
          AppSpacing.gapH16,

          AppTextField(
            label: 'New Password',
            hintText: 'Min 8 characters',
            controller: _passwordController,
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            validator: Validators.validatePassword,
            errorText: _getFieldError('password'),
          ),
          AppSpacing.gapH16,

          AppTextField(
            label: 'Confirm New Password',
            hintText: 'Re-enter your new password',
            controller: _confirmPasswordController,
            isPassword: true,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_reset_rounded, size: 20),
            validator: (v) => Validators.validateConfirmPassword(v, _passwordController.text),
            errorText: _getFieldError('password_confirmation'),
            onFieldSubmitted: (_) => _handleReset(),
          ),
          AppSpacing.gapH24,

          AppButton.primary(
            text: 'Reset Password',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _handleReset,
          ),
          AppSpacing.gapH24,
        ],
      ),
    );
  }

  Widget _buildSuccessView(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSpacing.gapH32,
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.primaryDark,
              size: 44,
            ),
          ),
          AppSpacing.gapH24,
          Text(
            'Password Reset Complete!',
            textAlign: TextAlign.center,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            'Your password has been successfully updated. You can now log in with your new credentials.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.gapH32,
          AppButton.primary(
            text: 'Go to Log In',
            onPressed: () => context.go(AppConstants.loginPath),
            isFullWidth: false,
          ),
        ],
      ),
    );
  }
}

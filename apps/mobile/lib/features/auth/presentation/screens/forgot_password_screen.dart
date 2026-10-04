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

/// Forgot password screen allowing users to request a password reset email.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;
  String? _errorMessage;
  String? _serverEmailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _serverEmailError = null;
    });

    try {
      await ref.read(authNotifierProvider.notifier).forgotPassword(
            email: _emailController.text.trim(),
          );
      if (mounted) {
        setState(() {
          _sent = true;
        });
      }
    } on ValidationException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          final emailErr = e.errors?['email'];
          if (emailErr is List && emailErr.isNotEmpty) {
            _serverEmailError = emailErr.first.toString();
          }
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
        child: Padding(
          padding: AppSpacing.px24,
          child: _sent ? _buildSuccessState(isDark) : _buildFormState(isDark),
        ),
      ),
    );
  }

  Widget _buildFormState(bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSpacing.gapH16,
          Text(
            'Reset Password',
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            'Enter your registered email address and we will send you a reset link.',
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
            errorText: _serverEmailError,
            onFieldSubmitted: (_) => _handleSubmit(),
          ),
          AppSpacing.gapH24,
          AppButton.primary(
            text: 'Send Reset Link',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _handleSubmit,
          ),
          AppSpacing.gapH16,
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final path = email.isNotEmpty
                    ? '${AppConstants.resetPasswordPath}?email=${Uri.encodeComponent(email)}'
                    : AppConstants.resetPasswordPath;
                context.push(path);
              },
              child: const Text('Already have a reset token? Enter here'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              color: AppColors.primaryDark,
              size: 40,
            ),
          ),
          AppSpacing.gapH24,
          Text(
            'Check your inbox',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            'We sent a reset link and token to ${_emailController.text}',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          AppSpacing.gapH32,
          AppButton.primary(
            text: 'Enter Reset Token',
            onPressed: () {
              final email = _emailController.text.trim();
              context.push('${AppConstants.resetPasswordPath}?email=${Uri.encodeComponent(email)}');
            },
            isFullWidth: false,
          ),
          AppSpacing.gapH12,
          AppButton.secondary(
            text: 'Back to Log In',
            onPressed: () => context.pop(),
            isFullWidth: false,
          ),
        ],
      ),
    );
  }
}

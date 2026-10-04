import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class ScanQuotaExceededView extends StatelessWidget {
  final VoidCallback onEnterManually;
  final VoidCallback onUpgrade;

  const ScanQuotaExceededView({
    super.key,
    required this.onEnterManually,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.carbs.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_motion_rounded,
                size: 42,
                color: AppColors.carbs,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Monthly Scans Reached',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "You have reached your 5 free AI scans for this month. Upgrade to NutriAI Pro for 100 scans, or log your foods with the manual meal builder.",
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Upgrade to NutriAI Pro',
              icon: const Icon(Icons.star_rounded),
              onPressed: onUpgrade,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              text: 'Enter Meal Manually',
              variant: AppButtonVariant.secondary,
              icon: const Icon(Icons.edit_note_rounded),
              onPressed: onEnterManually,
            ),
          ],
        ),
      ),
    );
  }
}

class ScanNonFoodView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetake;
  final VoidCallback onEnterManually;

  const ScanNonFoodView({
    super.key,
    this.message,
    required this.onRetake,
    required this.onEnterManually,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.no_food_outlined,
                size: 42,
                color: AppColors.coral,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Food Detected',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ??
                  'NutriAI could not spot any food or drinks in this picture. Please ensure your meal is well-lit and centered in frame.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Retake Photo',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: onRetake,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              text: 'Enter Meal Manually',
              variant: AppButtonVariant.secondary,
              icon: const Icon(Icons.edit_note_rounded),
              onPressed: onEnterManually,
            ),
          ],
        ),
      ),
    );
  }
}

class ScanServiceErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  final VoidCallback onEnterManually;

  const ScanServiceErrorView({
    super.key,
    this.message,
    required this.onRetry,
    required this.onEnterManually,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 42,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'AI Service Unavailable',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message ??
                  'We could not connect to the AI vision recognition service. Please check your network or try again.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Try Again',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: onRetry,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              text: 'Enter Meal Manually',
              variant: AppButtonVariant.secondary,
              icon: const Icon(Icons.edit_note_rounded),
              onPressed: onEnterManually,
            ),
          ],
        ),
      ),
    );
  }
}

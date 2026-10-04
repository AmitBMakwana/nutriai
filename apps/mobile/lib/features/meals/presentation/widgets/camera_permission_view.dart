import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class CameraPermissionView extends StatelessWidget {
  final bool isPermanentlyDenied;
  final VoidCallback onRequestPermission;
  final VoidCallback onOpenSettings;
  final VoidCallback onPickGallery;

  const CameraPermissionView({
    super.key,
    required this.isPermanentlyDenied,
    required this.onRequestPermission,
    required this.onOpenSettings,
    required this.onPickGallery,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Camera Access Required',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isPermanentlyDenied
                  ? 'Camera permission has been permanently denied. Please enable it in your device settings to capture food photos directly.'
                  : 'NutriAI needs access to your camera to snap meal photos, identify food items, and track your daily nutrition goals.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: isPermanentlyDenied ? 'Open Device Settings' : 'Allow Camera Access',
                icon: Icon(isPermanentlyDenied ? Icons.settings : Icons.lock_open_rounded),
                onPressed: isPermanentlyDenied ? onOpenSettings : onRequestPermission,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Choose from Gallery Instead',
                icon: const Icon(Icons.photo_library_outlined),
                variant: AppButtonVariant.secondary,
                onPressed: onPickGallery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'camera_capture_screen.dart';
import 'food_search_screen.dart';
import 'image_preview_screen.dart';
import 'meal_builder_screen.dart';

class AddMealScreen extends StatelessWidget {
  const AddMealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Meal',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How would you like to log your meal?',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Search Food option
            _buildOptionCard(
              context: context,
              icon: Icons.search_rounded,
              iconColor: AppColors.primary,
              title: 'Search Food Database',
              subtitle: 'Search verified foods, calories, and standard portions',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FoodSearchScreen()),
                );
              },
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),

            // Meal Builder Manual Entry
            _buildOptionCard(
              context: context,
              icon: Icons.edit_note_rounded,
              iconColor: const Color(0xFF6366F1), // Indigo
              title: 'Meal Builder',
              subtitle: 'Assemble multiple foods and customize meal type and time',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MealBuilderScreen()),
                );
              },
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),

            // AI Camera Snap Photo
            _buildOptionCard(
              context: context,
              icon: Icons.camera_alt_rounded,
              iconColor: AppColors.coral,
              title: 'Snap Food Photo',
              subtitle: 'AI vision automatically detects foods and estimates portions',
              badge: 'AI Powered',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CameraCaptureScreen(),
                  ),
                );
              },
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.md),

            // Upload Photo
            _buildOptionCard(
              context: context,
              icon: Icons.photo_library_rounded,
              iconColor: AppColors.carbs,
              title: 'Upload Meal Photo',
              subtitle: 'Select a photo from your gallery for AI nutritional analysis',
              onTap: () async {
                try {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 2400,
                    maxHeight: 2400,
                  );
                  if (picked != null && context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewScreen(
                          initialFile: File(picked.path),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open gallery: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardBorder,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.buttonBorder,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.coral.withValues(alpha: 0.15),
                              borderRadius: AppRadius.pillBorder,
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.coral,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

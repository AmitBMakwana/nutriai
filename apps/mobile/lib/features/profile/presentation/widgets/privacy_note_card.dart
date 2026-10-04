import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PrivacyNoteCard extends StatelessWidget {
  const PrivacyNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.p16,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
        borderRadius: AppRadius.r20,
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFBBF7D0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icons.shield_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Text(
                  'Meal Photo Privacy & Security',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH8,
          Text(
            'Your meal photos are uploaded securely and analyzed in real-time by AI models solely to identify foods and estimate portion sizes. Images are stored privately in encrypted cloud storage and are never sold or used for public model training. When you delete your account, all photos and nutritional records are permanently destroyed.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/nutrition_goal_entity.dart';
import 'macro_target_card.dart';
import 'water_target_card.dart';

class DailyPlanResultView extends StatelessWidget {
  final NutritionGoalEntity goal;
  final VoidCallback onStartTracking;
  final VoidCallback onAdjustPlan;

  const DailyPlanResultView({
    super.key,
    required this.goal,
    required this.onStartTracking,
    required this.onAdjustPlan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your Daily Plan',
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Calibrated using your metabolic rate and body goal.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Large Calorie Target Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xl,
              horizontal: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF111A2E)]
                    : [AppColors.primaryContainer.withValues(alpha: 0.5), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.cardBorder,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: AppRadius.pillBorder,
                  ),
                  child: Text(
                    'DAILY TARGET',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.primaryLight : AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatNumber(goal.dailyCalories),
                      style: AppTypography.displayLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 54,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'kcal / day',
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Macro Distribution Cards
          Row(
            children: [
              MacroTargetCard(
                label: 'Protein',
                grams: goal.proteinGrams,
                percentage: goal.proteinPercentage,
                color: AppColors.protein,
              ),
              const SizedBox(width: AppSpacing.sm),
              MacroTargetCard(
                label: 'Carbs',
                grams: goal.carbsGrams,
                percentage: goal.carbsPercentage,
                color: AppColors.carbs,
              ),
              const SizedBox(width: AppSpacing.sm),
              MacroTargetCard(
                label: 'Fat',
                grams: goal.fatGrams,
                percentage: goal.fatPercentage,
                color: AppColors.fat,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Water Target Card
          WaterTargetCard(waterMl: goal.waterMl),

          const SizedBox(height: AppSpacing.lg),

          // Medical Disclaimer Alert
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDarkSubtle
                  : AppColors.surfaceLightSubtle,
              borderRadius: AppRadius.cardBorder,
              border: Border.all(
                color: isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Nutrition values are estimates, not medical advice. Consult a healthcare professional before undertaking major dietary changes.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Action Buttons
          AppButton(
            text: 'Start Tracking',
            onPressed: onStartTracking,
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: const Text('Adjust Plan'),
              onPressed: onAdjustPlan,
              style: TextButton.styleFrom(
                foregroundColor: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

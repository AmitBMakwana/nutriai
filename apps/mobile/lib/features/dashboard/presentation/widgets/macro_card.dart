import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/dashboard_entity.dart';

class MacroCard extends StatelessWidget {
  final String label;
  final MacroNutrientEntity macro;
  final Color color;

  const MacroCard({
    super.key,
    required this.label,
    required this.macro,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = macro.progressFraction;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: AppRadius.cardBorder,
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '${macro.percentage.toStringAsFixed(0)}%',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  macro.consumed.toStringAsFixed(0),
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  ' / ${macro.target.toStringAsFixed(0)}g',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: AppRadius.pillBorder,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? AppColors.surfaceDarkSubtle
                        : AppColors.surfaceLightSubtle,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MacroRowSection extends StatelessWidget {
  final MacrosSummaryEntity macros;

  const MacroRowSection({
    super.key,
    required this.macros,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MacroCard(
          label: 'Protein',
          macro: macros.protein,
          color: AppColors.protein,
        ),
        const SizedBox(width: AppSpacing.sm),
        MacroCard(
          label: 'Carbs',
          macro: macros.carbs,
          color: AppColors.carbs,
        ),
        const SizedBox(width: AppSpacing.sm),
        MacroCard(
          label: 'Fat',
          macro: macros.fat,
          color: AppColors.fat,
        ),
      ],
    );
  }
}

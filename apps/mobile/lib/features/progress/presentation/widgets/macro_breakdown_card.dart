import 'package:flutter/material.dart';
import '../../domain/entities/progress_entities.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';

/// Macro breakdown bar + stat row
class MacroBreakdownCard extends StatelessWidget {
  final MacroAverages averages;
  final MacroTargets targets;

  const MacroBreakdownCard({
    super.key,
    required this.averages,
    required this.targets,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avg. Macro Breakdown',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _MacroBar(
            label: 'Protein',
            consumed: averages.protein,
            target: targets.protein,
            color: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MacroBar(
            label: 'Carbs',
            consumed: averages.carbs,
            target: targets.carbs,
            color: const Color(0xFF2196F3),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MacroBar(
            label: 'Fat',
            consumed: averages.fat,
            target: targets.fat,
            color: const Color(0xFFFF9800),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatChip(label: 'Avg kcal', value: '${averages.calories}'),
              _StatChip(label: 'Protein', value: '${averages.protein.toStringAsFixed(0)}g'),
              _StatChip(label: 'Carbs', value: '${averages.carbs.toStringAsFixed(0)}g'),
              _StatChip(label: 'Fat', value: '${averages.fat.toStringAsFixed(0)}g'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final String label;
  final double consumed;
  final double target;
  final Color color;

  const _MacroBar({
    required this.label,
    required this.consumed,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pct = target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            Text(
              '${consumed.toStringAsFixed(0)}g / ${target.toStringAsFixed(0)}g',
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: AppRadius.pillBorder,
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor:
                isDark ? AppColors.borderDark : AppColors.borderLight,
            color: color,
            minHeight: 7,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 10,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

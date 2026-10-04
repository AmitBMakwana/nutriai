import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/dashboard_entity.dart';

class WaterCard extends StatelessWidget {
  final WaterSummaryEntity water;
  final ValueChanged<int>? onAddWater;
  final VoidCallback? onUndo;
  final bool canUndo;
  final bool isLogging;

  const WaterCard({
    super.key,
    required this.water,
    this.onAddWater,
    this.onUndo,
    this.canUndo = false,
    this.isLogging = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = water.progressFraction;
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: AppColors.water.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.water.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.water.withValues(alpha: 0.25),
                      AppColors.water.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.buttonBorder,
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.water,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hydration',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (isLogging) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.water,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${water.glassesConsumed} of ${water.glassesTarget} glasses ($percentage%)',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${water.consumed} ml',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.water,
                    ),
                  ),
                  Text(
                    '/ ${water.target} ml',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              if (onUndo != null) ...[
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  tooltip: 'Undo last entry',
                  icon: Icon(
                    Icons.undo_rounded,
                    size: 20,
                    color: canUndo
                        ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                        : Colors.grey.withValues(alpha: 0.3),
                  ),
                  onPressed: canUndo && !isLogging ? onUndo : null,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Animated Fluid Progress bar
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDarkSubtle
                      : AppColors.surfaceLightSubtle,
                  borderRadius: AppRadius.pillBorder,
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                builder: (context, val, child) {
                  return FractionallySizedBox(
                    widthFactor: val.clamp(0.0, 1.0),
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF38BDF8),
                            Color(0xFF0284C7),
                          ],
                        ),
                        borderRadius: AppRadius.pillBorder,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.water.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Quick Add Row (250 / 500 / 750 / 1000 ml)
          Row(
            children: [
              _buildQuickAddChip(context, amount: 250, label: '+250 ml', isDark: isDark),
              const SizedBox(width: AppSpacing.xs),
              _buildQuickAddChip(context, amount: 500, label: '+500 ml', isDark: isDark),
              const SizedBox(width: AppSpacing.xs),
              _buildQuickAddChip(context, amount: 750, label: '+750 ml', isDark: isDark),
              const SizedBox(width: AppSpacing.xs),
              _buildQuickAddChip(context, amount: 1000, label: '+1000 ml', isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddChip(
    BuildContext context, {
    required int amount,
    required String label,
    required bool isDark,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLogging ? null : () => onAddWater?.call(amount),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDarkSubtle.withValues(alpha: 0.8)
                  : AppColors.water.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.water.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.water,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

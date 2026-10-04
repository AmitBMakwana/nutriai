import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class WeightStepView extends StatelessWidget {
  final bool isImperial;
  final double weightKg;
  final double weightLbs;
  final ValueChanged<bool> onToggleUnit;
  final ValueChanged<double> onKgChanged;
  final ValueChanged<double> onLbsChanged;

  const WeightStepView({
    super.key,
    required this.isImperial,
    required this.weightKg,
    required this.weightLbs,
    required this.onToggleUnit,
    required this.onKgChanged,
    required this.onLbsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayValue = isImperial
        ? weightLbs.toStringAsFixed(1)
        : weightKg.toStringAsFixed(1);
    final displayUnit = isImperial ? 'lb' : 'kg';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            "What's your current weight?",
            style: AppTypography.headlineMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'We use this to calculate your exact resting energy expenditure.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Unit toggle pill
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDarkSubtle
                    : AppColors.surfaceLightSubtle,
                borderRadius: AppRadius.pillBorder,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _unitTab(
                    label: 'kg',
                    isSelected: !isImperial,
                    onTap: () => onToggleUnit(false),
                    isDark: isDark,
                  ),
                  _unitTab(
                    label: 'lb',
                    isSelected: isImperial,
                    onTap: () => onToggleUnit(true),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Big value display card
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xl,
                horizontal: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.cardBorder,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        displayValue,
                        style: AppTypography.displayLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 54,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        displayUnit,
                        style: AppTypography.titleLarge.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: isDark
                          ? AppColors.surfaceDarkSubtle
                          : AppColors.surfaceLightSubtle,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: isImperial
                          ? weightLbs.clamp(60.0, 440.0)
                          : weightKg.clamp(30.0, 200.0),
                      min: isImperial ? 60.0 : 30.0,
                      max: isImperial ? 440.0 : 200.0,
                      divisions: isImperial ? 380 : 170,
                      onChanged: (val) {
                        final rounded = double.parse(val.toStringAsFixed(1));
                        if (isImperial) {
                          onLbsChanged(rounded);
                        } else {
                          onKgChanged(rounded);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove_rounded),
                        onPressed: () {
                          if (isImperial) {
                            onLbsChanged(double.parse((weightLbs - 0.5).toStringAsFixed(1)));
                          } else {
                            onKgChanged(double.parse((weightKg - 0.5).toStringAsFixed(1)));
                          }
                        },
                      ),
                      const SizedBox(width: AppSpacing.md),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add_rounded),
                        onPressed: () {
                          if (isImperial) {
                            onLbsChanged(double.parse((weightLbs + 0.5).toStringAsFixed(1)));
                          } else {
                            onKgChanged(double.parse((weightKg + 0.5).toStringAsFixed(1)));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.pillBorder,
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            color: isSelected
                ? AppColors.onPrimary
                : (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

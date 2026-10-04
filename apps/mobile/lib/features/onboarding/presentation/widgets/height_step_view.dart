import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class HeightStepView extends StatelessWidget {
  final bool isImperial;
  final double heightCm;
  final int feet;
  final int inches;
  final ValueChanged<bool> onToggleUnit;
  final ValueChanged<double> onCmChanged;
  final void Function(int feet, int inches) onImperialChanged;

  const HeightStepView({
    super.key,
    required this.isImperial,
    required this.heightCm,
    required this.feet,
    required this.inches,
    required this.onToggleUnit,
    required this.onCmChanged,
    required this.onImperialChanged,
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
            'How tall are you?',
            style: AppTypography.headlineMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Height is essential for calculating body surface area and BMI.',
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
                    label: 'cm',
                    isSelected: !isImperial,
                    onTap: () => onToggleUnit(false),
                    isDark: isDark,
                  ),
                  _unitTab(
                    label: 'ft / in',
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
                  if (!isImperial) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${heightCm.round()}',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 54,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'cm',
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
                        value: heightCm.clamp(100.0, 240.0),
                        min: 100.0,
                        max: 240.0,
                        divisions: 140,
                        onChanged: onCmChanged,
                      ),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$feet',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 54,
                          ),
                        ),
                        Text(
                          ' ft ',
                          style: AppTypography.titleLarge.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        Text(
                          '$inches',
                          style: AppTypography.displayLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 54,
                          ),
                        ),
                        Text(
                          ' in',
                          style: AppTypography.titleLarge.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _stepper(
                          label: 'Feet',
                          value: feet,
                          onDec: () => onImperialChanged(
                              (feet - 1).clamp(3, 7), inches),
                          onInc: () => onImperialChanged(
                              (feet + 1).clamp(3, 7), inches),
                          isDark: isDark,
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        _stepper(
                          label: 'Inches',
                          value: inches,
                          onDec: () => onImperialChanged(
                              feet, (inches - 1).clamp(0, 11)),
                          onInc: () => onImperialChanged(
                              feet, (inches + 1).clamp(0, 11)),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
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

  Widget _stepper({
    required String label,
    required int value,
    required VoidCallback onDec,
    required VoidCallback onInc,
    required bool isDark,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              icon: const Icon(Icons.remove_rounded),
              onPressed: onDec,
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton.filledTonal(
              icon: const Icon(Icons.add_rounded),
              onPressed: onInc,
            ),
          ],
        ),
      ],
    );
  }
}

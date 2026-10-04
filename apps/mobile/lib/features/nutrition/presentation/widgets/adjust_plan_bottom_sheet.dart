import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/nutrition_goal_entity.dart';

class AdjustPlanBottomSheet extends StatefulWidget {
  final NutritionGoalEntity currentGoal;
  final ValueChanged<NutritionGoalEntity> onSave;

  const AdjustPlanBottomSheet({
    super.key,
    required this.currentGoal,
    required this.onSave,
  });

  @override
  State<AdjustPlanBottomSheet> createState() => _AdjustPlanBottomSheetState();
}

class _AdjustPlanBottomSheetState extends State<AdjustPlanBottomSheet> {
  late int _calories;
  late int _protein;
  late int _carbs;
  late int _fat;
  late int _water;

  @override
  void initState() {
    super.initState();
    _calories = widget.currentGoal.dailyCalories;
    _protein = widget.currentGoal.proteinGrams;
    _carbs = widget.currentGoal.carbsGrams;
    _fat = widget.currentGoal.fatGrams;
    _water = widget.currentGoal.waterMl;
  }

  void _recalculateMacrosFromCalories(int newCalories) {
    setState(() {
      _calories = newCalories;
      _protein = ((newCalories * 0.30) / 4).round();
      _carbs = ((newCalories * 0.40) / 4).round();
      _fat = ((newCalories * 0.30) / 9).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: AppRadius.pillBorder,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Adjust Daily Targets',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Customize your caloric ceiling and nutrient goals.',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Calorie slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories Target',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_calories kcal',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: isDark
                  ? AppColors.surfaceDarkSubtle
                  : AppColors.surfaceLightSubtle,
              thumbColor: AppColors.primary,
            ),
            child: Slider(
              value: _calories.toDouble().clamp(1200.0, 4000.0),
              min: 1200.0,
              max: 4000.0,
              divisions: 56,
              onChanged: (val) {
                _recalculateMacrosFromCalories((val / 50).round() * 50);
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Protein, Carbs, Fat steppers row
          Row(
            children: [
              _macroStepper(
                label: 'Protein',
                grams: _protein,
                color: AppColors.protein,
                onChanged: (v) => setState(() => _protein = v),
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _macroStepper(
                label: 'Carbs',
                grams: _carbs,
                color: AppColors.carbs,
                onChanged: (v) => setState(() => _carbs = v),
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _macroStepper(
                label: 'Fat',
                grams: _fat,
                color: AppColors.fat,
                onChanged: (v) => setState(() => _fat = v),
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Water stepper
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Water Target',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.remove_rounded, size: 18),
                    onPressed: () {
                      if (_water > 1000) setState(() => _water -= 250);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Text(
                      '$_water ml',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.water,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    onPressed: () {
                      if (_water < 6000) setState(() => _water += 250);
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          AppButton(
            text: 'Apply & Save Plan',
            onPressed: () {
              final updated = widget.currentGoal.copyWith(
                dailyCalories: _calories,
                proteinGrams: _protein,
                carbsGrams: _carbs,
                fatGrams: _fat,
                waterMl: _water,
              );
              widget.onSave(updated);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _macroStepper({
    required String label,
    required int grams,
    required Color color,
    required ValueChanged<int> onChanged,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: AppRadius.cardBorder,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${grams}g',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (grams > 10) onChanged(grams - 5);
                  },
                  borderRadius: AppRadius.pillBorder,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.remove_rounded, size: 16),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onChanged(grams + 5);
                  },
                  borderRadius: AppRadius.pillBorder,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.add_rounded, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/dashboard_entity.dart';

class MealsSection extends StatelessWidget {
  final Map<String, MealGroupEntity> meals;
  final Function(String mealType)? onAddMealForType;

  const MealsSection({
    super.key,
    required this.meals,
    this.onAddMealForType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final mealKeys = ['breakfast', 'lunch', 'dinner', 'snack'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today’s Meals',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...mealKeys.map((type) {
          final group = meals[type] ??
              MealGroupEntity(
                type: type,
                calories: 0,
                protein: 0,
                carbs: 0,
                fat: 0,
                meals: const [],
              );
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _MealTypeCard(
              group: group,
              onAddTap: () => onAddMealForType?.call(type),
            ),
          );
        }),
      ],
    );
  }
}

class _MealTypeCard extends StatelessWidget {
  final MealGroupEntity group;
  final VoidCallback onAddTap;

  const _MealTypeCard({
    required this.group,
    required this.onAddTap,
  });

  IconData _getMealIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny_outlined;
      case 'lunch':
        return Icons.wb_twilight_rounded;
      case 'dinner':
        return Icons.nightlight_outlined;
      case 'snack':
      default:
        return Icons.coffee_outlined;
    }
  }

  Color _getMealColor(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return AppColors.carbs;
      case 'lunch':
        return AppColors.primary;
      case 'dinner':
        return const Color(0xFF6366F1); // Indigo
      case 'snack':
      default:
        return AppColors.coral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _getMealColor(group.type);
    final icon = _getMealIcon(group.type);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.buttonBorder,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.displayName,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      if (!group.isEmpty)
                        Text(
                          'P: ${group.protein.toStringAsFixed(0)}g  C: ${group.carbs.toStringAsFixed(0)}g  F: ${group.fat.toStringAsFixed(0)}g',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${group.calories} kcal',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: group.calories > 0
                        ? color
                        : (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight),
                  ),
                ),
              ],
            ),
          ),

          // Divider if entries exist
          if (!group.isEmpty)
            Divider(
              height: 1,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),

          // Meal entries or empty state
          if (group.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
                  borderRadius: AppRadius.buttonBorder,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'No ${group.displayName.toLowerCase()} logged yet',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onAddTap,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add'),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: group.meals.map((meal) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.items.isNotEmpty
                                    ? meal.items.map((i) => i.foodName).join(', ')
                                    : '${group.displayName} Entry',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              if (meal.mealTime.isNotEmpty)
                                Text(
                                  meal.mealTime,
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          '${meal.totalCalories} kcal',
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

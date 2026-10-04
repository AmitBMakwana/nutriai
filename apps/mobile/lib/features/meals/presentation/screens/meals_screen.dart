import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../dashboard/presentation/widgets/date_selector_bar.dart';
import '../providers/meal_builder_provider.dart';
import '../providers/meals_tab_provider.dart';
import '../widgets/meal_detail_bottom_sheet.dart';
import 'add_meal_screen.dart';

class MealsScreen extends ConsumerWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedDate = ref.watch(selectedDateProvider);
    final mealsAsync = ref.watch(mealsTabProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.lg,
        title: Text(
          'Meals Log',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(mealBuilderProvider.notifier).reset();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMealScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Meal', style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.pillBorder),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(mealsTabProvider.notifier).refreshMeals(),
        color: AppColors.primary,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
              child: DateSelectorBar(
                selectedDate: selectedDate,
                onPreviousDay: () =>
                    ref.read(dashboardProvider.notifier).previousDay(),
                onNextDay: () =>
                    ref.read(dashboardProvider.notifier).nextDay(),
                onDateSelected: (date) =>
                    ref.read(dashboardProvider.notifier).selectDate(date),
              ),
            ),
            Expanded(
              child: mealsAsync.when(
                loading: () => const LoadingView(itemCount: 4),
                error: (error, _) => Center(
                  child: ErrorView(
                    message: error.toString(),
                    onRetry: () => ref.read(mealsTabProvider.notifier).refreshMeals(),
                  ),
                ),
                data: (meals) {
                  final totalKcal = meals.fold(0, (sum, m) => sum + m.totalCalories);
                  final totalProtein = meals.fold(0.0, (sum, m) => sum + m.totalProtein);
                  final totalCarbs = meals.fold(0.0, (sum, m) => sum + m.totalCarbs);
                  final totalFat = meals.fold(0.0, (sum, m) => sum + m.totalFat);

                  if (meals.isEmpty) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: EmptyView(
                          title: 'No meals logged yet',
                          message: 'Track your breakfast, lunch, dinner, or snacks for today.',
                          actionText: 'Log First Meal',
                          onAction: () {
                            ref.read(mealBuilderProvider.notifier).reset();
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const AddMealScreen()),
                            );
                          },
                        ),
                      ),
                    );
                  }

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 80),
                    children: [
                      // Daily macro summary banner
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDailyStat('Total Calories', '$totalKcal kcal', AppColors.primary, isDark),
                            _buildDailyStat('Protein', '${totalProtein.toStringAsFixed(0)}g', AppColors.protein, isDark),
                            _buildDailyStat('Carbs', '${totalCarbs.toStringAsFixed(0)}g', AppColors.carbs, isDark),
                            _buildDailyStat('Fat', '${totalFat.toStringAsFixed(0)}g', AppColors.fat, isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Meals list
                      ...meals.map((meal) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                              borderRadius: AppRadius.cardBorder,
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                MealDetailBottomSheet.show(context, meal: meal);
                              },
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: AppRadius.buttonBorder,
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    meal.displayName,
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  Text(
                                    '${meal.totalCalories} kcal',
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    meal.items.isNotEmpty
                                        ? meal.items.map((i) => i.foodName).join(', ')
                                        : 'No items',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${meal.mealTime} • P: ${meal.totalProtein.toStringAsFixed(0)}g C: ${meal.totalCarbs.toStringAsFixed(0)}g F: ${meal.totalFat.toStringAsFixed(0)}g',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyStat(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

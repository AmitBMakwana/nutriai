import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/calorie_ring.dart';
import '../widgets/dashboard_skeleton.dart';
import '../widgets/date_selector_bar.dart';
import '../widgets/macro_card.dart';
import '../widgets/meals_section.dart';
import '../widgets/water_card.dart';
import '../../../meals/presentation/providers/meal_builder_provider.dart';
import '../../../meals/presentation/screens/add_meal_screen.dart';
import '../../../meals/presentation/screens/meal_builder_screen.dart';
import '../../../water/presentation/providers/water_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = ref.watch(authProvider);
    final user = authState.user;
    final firstName = user?.name.trim().split(' ').first;
    final greeting = firstName != null && firstName.isNotEmpty
        ? '${_getGreeting()}, $firstName 👋'
        : '${_getGreeting()} 👋';

    final selectedDate = ref.watch(selectedDateProvider);
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.lg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              'Here is your nutrition overview',
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
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
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Add Meal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.pillBorder),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).refreshDashboard(),
        color: AppColors.primary,
        child: dashboardAsync.when(
          loading: () => const DashboardSkeleton(),
          error: (error, stack) => Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ErrorView(
                message: error.toString(),
                onRetry: () => ref.read(dashboardProvider.notifier).refreshDashboard(),
              ),
            ),
          ),
          data: (dashboard) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.sm),

                  // Date selector bar
                  DateSelectorBar(
                    selectedDate: selectedDate,
                    onPreviousDay: () =>
                        ref.read(dashboardProvider.notifier).previousDay(),
                    onNextDay: () =>
                        ref.read(dashboardProvider.notifier).nextDay(),
                    onDateSelected: (date) =>
                        ref.read(dashboardProvider.notifier).selectDate(date),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Animated Calorie Ring hero card
                  CalorieRing(calories: dashboard.calories),

                  const SizedBox(height: AppSpacing.md),

                  // Three Macro Cards (Protein, Carbs, Fat)
                  MacroRowSection(macros: dashboard.macros),

                  const SizedBox(height: AppSpacing.md),

                  // Water Card
                  WaterCard(
                    water: dashboard.water,
                    canUndo: ref.watch(waterNotifierProvider).canUndo,
                    isLogging: ref.watch(waterNotifierProvider).isLogging,
                    onAddWater: (amount) async {
                      final success = await ref
                          .read(waterNotifierProvider.notifier)
                          .quickAdd(amount);
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('+$amount ml water logged! 💧'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                ref
                                    .read(waterNotifierProvider.notifier)
                                    .undoLast();
                              },
                            ),
                          ),
                        );
                      }
                    },
                    onUndo: () async {
                      final success = await ref
                          .read(waterNotifierProvider.notifier)
                          .undoLast();
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Last water entry undone ↩️'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Meals Section (Breakfast, Lunch, Dinner, Snack)
                  MealsSection(
                    meals: dashboard.meals,
                    onAddMealForType: (type) {
                      ref.read(mealBuilderProvider.notifier).reset();
                      ref.read(mealBuilderProvider.notifier).setMealType(type);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MealBuilderScreen()),
                      );
                    },
                  ),

                  // Bottom padding for FAB clearance
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

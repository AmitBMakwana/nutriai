import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/food_entity.dart';
import '../providers/food_search_provider.dart';
import '../providers/meal_builder_provider.dart';
import '../widgets/quantity_picker_bottom_sheet.dart';
import 'custom_food_screen.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodSearchProvider.notifier).search('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFoodSelected(FoodEntity food) {
    QuantityPickerBottomSheet.show(
      context,
      food: food,
      onConfirm: (item) {
        ref.read(mealBuilderProvider.notifier).addItem(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${item.foodName} (${item.calories} kcal)'),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(); // Back to meal builder or add meal screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final searchState = ref.watch(foodSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Food',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomFoodScreen(
                    onFoodCreated: (food) => _onFoodSelected(food),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Custom'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search food or brand...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(foodSearchProvider.notifier).onQueryChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.pillBorder,
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
              onChanged: (val) {
                ref.read(foodSearchProvider.notifier).onQueryChanged(val);
              },
            ),
          ),

          // Filters row (All / Favorites)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Foods'),
                  selected: !searchState.isFavoritesOnly,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(foodSearchProvider.notifier).setFavoritesOnly(false);
                    }
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                FilterChip(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('Favorites'),
                    ],
                  ),
                  selected: searchState.isFavoritesOnly,
                  onSelected: (selected) {
                    ref.read(foodSearchProvider.notifier).setFavoritesOnly(selected);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Search results
          Expanded(
            child: Builder(
              builder: (context) {
                if (searchState.isLoading) {
                  return const LoadingView(itemCount: 6);
                }

                if (searchState.errorMessage != null) {
                  return Center(
                    child: Text(
                      searchState.errorMessage!,
                      style: TextStyle(color: AppColors.fat),
                    ),
                  );
                }

                if (searchState.foods.isEmpty) {
                  return EmptyView(
                    title: searchState.isFavoritesOnly ? 'No favorite foods' : 'No foods found',
                    message: searchState.isFavoritesOnly
                        ? 'Tap the star on any food to save it as a favorite.'
                        : 'Try searching for something else or create a custom food.',
                    actionText: 'Create Custom Food',
                    onAction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CustomFoodScreen(
                            onFoodCreated: (food) => _onFoodSelected(food),
                          ),
                        ),
                      );
                    },
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  itemCount: searchState.foods.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final food = searchState.foods[index];
                    return _FoodItemTile(
                      food: food,
                      onTap: () => _onFoodSelected(food),
                      onFavoriteToggle: () {
                        ref.read(foodSearchProvider.notifier).toggleFavorite(food.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodItemTile extends StatelessWidget {
  final FoodEntity food;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const _FoodItemTile({
    required this.food,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        title: Row(
          children: [
            Expanded(
              child: Text(
                food.name,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            if (food.isVerified)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${food.brand != null ? '${food.brand!} • ' : ''}${food.servingSize.toStringAsFixed(0)} ${food.servingUnit}',
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildMacroText('P: ${food.protein.toStringAsFixed(1)}g', AppColors.protein),
                const SizedBox(width: 8),
                _buildMacroText('C: ${food.carbs.toStringAsFixed(1)}g', AppColors.carbs),
                const SizedBox(width: 8),
                _buildMacroText('F: ${food.fat.toStringAsFixed(1)}g', AppColors.fat),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${food.calories} kcal',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            IconButton(
              icon: Icon(
                food.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: food.isFavorite ? Colors.amber : Colors.grey,
                size: 22,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

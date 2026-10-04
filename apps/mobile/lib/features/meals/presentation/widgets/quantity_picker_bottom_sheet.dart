import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/entities/meal_entity.dart';

class QuantityPickerBottomSheet extends StatefulWidget {
  final FoodEntity food;
  final Function(MealItemEntity item) onConfirm;

  const QuantityPickerBottomSheet({
    super.key,
    required this.food,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required FoodEntity food,
    required Function(MealItemEntity item) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuantityPickerBottomSheet(
        food: food,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<QuantityPickerBottomSheet> createState() => _QuantityPickerBottomSheetState();
}

class _QuantityPickerBottomSheetState extends State<QuantityPickerBottomSheet> {
  late double _quantity;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _quantity = widget.food.servingSize > 0 ? widget.food.servingSize : 1.0;
    _controller = TextEditingController(text: _formatQuantity(_quantity));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatQuantity(double q) {
    if (q == q.roundToDouble()) {
      return q.toInt().toString();
    }
    return q.toStringAsFixed(1);
  }

  void _updateQuantity(double newQuantity) {
    if (newQuantity < 0.1) return;
    setState(() {
      _quantity = newQuantity;
      _controller.text = _formatQuantity(_quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ratio = widget.food.servingSize > 0 ? (_quantity / widget.food.servingSize) : 1.0;
    final liveCalories = (widget.food.calories * ratio).round();
    final liveProtein = (widget.food.protein * ratio);
    final liveCarbs = (widget.food.carbs * ratio);
    final liveFat = (widget.food.fat * ratio);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Food Title & Brand
          Text(
            widget.food.name,
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          if (widget.food.brand != null && widget.food.brand!.isNotEmpty)
            Text(
              widget.food.brand!,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          const SizedBox(height: AppSpacing.lg),

          // Quantity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded),
                iconSize: 32,
                color: AppColors.primary,
                onPressed: () {
                  final step = widget.food.servingUnit.toLowerCase() == 'g' ||
                          widget.food.servingUnit.toLowerCase() == 'ml'
                      ? 25.0
                      : 0.5;
                  _updateQuantity((_quantity - step).clamp(0.5, 9999.0));
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.buttonBorder,
                      borderSide: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      setState(() {
                        _quantity = parsed;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                widget.food.servingUnit,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                iconSize: 32,
                color: AppColors.primary,
                onPressed: () {
                  final step = widget.food.servingUnit.toLowerCase() == 'g' ||
                          widget.food.servingUnit.toLowerCase() == 'ml'
                      ? 25.0
                      : 0.5;
                  _updateQuantity(_quantity + step);
                },
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Live Nutrition Recalculation Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
              borderRadius: AppRadius.cardBorder,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroPill('Calories', '$liveCalories kcal', AppColors.primary, isDark),
                _buildMacroPill('Protein', '${liveProtein.toStringAsFixed(1)}g', AppColors.protein, isDark),
                _buildMacroPill('Carbs', '${liveCarbs.toStringAsFixed(1)}g', AppColors.carbs, isDark),
                _buildMacroPill('Fat', '${liveFat.toStringAsFixed(1)}g', AppColors.fat, isDark),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Confirm button
          AppButton(
            text: 'Add to Meal',
            onPressed: () {
              final item = MealItemEntity(
                foodId: widget.food.id,
                foodName: widget.food.name,
                quantity: _quantity,
                unit: widget.food.servingUnit,
                calories: liveCalories,
                protein: liveProtein,
                carbs: liveCarbs,
                fat: liveFat,
                fiber: widget.food.fiber * ratio,
              );
              widget.onConfirm(item);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMacroPill(String label, String value, Color color, bool isDark) {
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

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/ai_meal_analysis_entity.dart';

class EditDetectedItemBottomSheet extends StatefulWidget {
  final AiDetectedItemEntity item;
  final ValueChanged<AiDetectedItemEntity> onSave;

  const EditDetectedItemBottomSheet({
    super.key,
    required this.item,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required AiDetectedItemEntity item,
    required ValueChanged<AiDetectedItemEntity> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditDetectedItemBottomSheet(item: item, onSave: onSave),
    );
  }

  @override
  State<EditDetectedItemBottomSheet> createState() =>
      _EditDetectedItemBottomSheetState();
}

class _EditDetectedItemBottomSheetState
    extends State<EditDetectedItemBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _unitController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;

  late double _baseQuantity;
  late int _baseCalories;
  late double _baseProtein;
  late double _baseCarbs;
  late double _baseFat;

  @override
  void initState() {
    super.initState();
    _baseQuantity = widget.item.quantity > 0 ? widget.item.quantity : 100.0;
    _baseCalories = widget.item.calories;
    _baseProtein = widget.item.protein;
    _baseCarbs = widget.item.carbs;
    _baseFat = widget.item.fat;

    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString().replaceAll(RegExp(r'\.0$'), ''),
    );
    _unitController = TextEditingController(text: widget.item.unit);
    _caloriesController = TextEditingController(text: widget.item.calories.toString());
    _proteinController = TextEditingController(text: widget.item.protein.toString());
    _carbsController = TextEditingController(text: widget.item.carbs.toString());
    _fatController = TextEditingController(text: widget.item.fat.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  void _onQuantityChanged(String value) {
    final newQty = double.tryParse(value);
    if (newQty == null || newQty <= 0) return;

    final ratio = newQty / _baseQuantity;
    final newCal = (_baseCalories * ratio).round();
    final newPro = double.parse((_baseProtein * ratio).toStringAsFixed(1));
    final newCarb = double.parse((_baseCarbs * ratio).toStringAsFixed(1));
    final newFat = double.parse((_baseFat * ratio).toStringAsFixed(1));

    setState(() {
      _caloriesController.text = newCal.toString();
      _proteinController.text = newPro.toString();
      _carbsController.text = newCarb.toString();
      _fatController.text = newFat.toString();
    });
  }

  void _adjustQuantity(double delta) {
    final current = double.tryParse(_quantityController.text) ?? _baseQuantity;
    final next = (current + delta).clamp(5.0, 5000.0);
    _quantityController.text = next.toStringAsFixed(0);
    _onQuantityChanged(_quantityController.text);
  }

  void _save() {
    final qty = double.tryParse(_quantityController.text) ?? widget.item.quantity;
    final cal = int.tryParse(_caloriesController.text) ?? widget.item.calories;
    final pro = double.tryParse(_proteinController.text) ?? widget.item.protein;
    final carb = double.tryParse(_carbsController.text) ?? widget.item.carbs;
    final fat = double.tryParse(_fatController.text) ?? widget.item.fat;

    final updated = widget.item.copyWith(
      name: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : widget.item.name,
      quantity: qty,
      unit: _unitController.text.trim().isNotEmpty
          ? _unitController.text.trim()
          : widget.item.unit,
      calories: cal,
      protein: pro,
      carbs: carb,
      fat: fat,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.sheetRadius,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: AppRadius.pillBorder,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Detected Item',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Item Name
            AppTextField(
              label: 'Food Name',
              controller: _nameController,
            ),
            const SizedBox(height: AppSpacing.md),

            // Quantity with proportional recalculation
            Text(
              'Portion & Quantity',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    label: 'Amount',
                    controller: _quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: _onQuantityChanged,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: AppTextField(
                    label: 'Unit',
                    controller: _unitController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),

            // Quick increment chips
            Row(
              children: [
                _buildQuickButton('-25', () => _adjustQuantity(-25)),
                const SizedBox(width: AppSpacing.xs),
                _buildQuickButton('+25', () => _adjustQuantity(25)),
                const SizedBox(width: AppSpacing.xs),
                _buildQuickButton('+50', () => _adjustQuantity(50)),
                const SizedBox(width: AppSpacing.xs),
                _buildQuickButton('+100', () => _adjustQuantity(100)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Nutritional Values (recomputed live or manually overrideable)
            Text(
              'Nutritional Values (Auto-rescaled)',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Calories (kcal)',
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    label: 'Protein (g)',
                    controller: _proteinController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Carbs (g)',
                    controller: _carbsController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextField(
                    label: 'Fat (g)',
                    controller: _fatController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            AppButton(
              text: 'Save Changes',
              icon: const Icon(Icons.check_rounded),
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: EdgeInsets.zero,
      onPressed: onTap,
    );
  }
}

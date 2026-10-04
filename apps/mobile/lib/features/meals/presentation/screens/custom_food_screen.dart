import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/food_entity.dart';
import '../providers/food_search_provider.dart';

class CustomFoodScreen extends ConsumerStatefulWidget {
  final Function(FoodEntity createdFood)? onFoodCreated;

  const CustomFoodScreen({super.key, this.onFoodCreated});

  @override
  ConsumerState<CustomFoodScreen> createState() => _CustomFoodScreenState();
}

class _CustomFoodScreenState extends ConsumerState<CustomFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _servingSizeController = TextEditingController(text: '100');
  final _servingUnitController = TextEditingController(text: 'g');
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _fiberController = TextEditingController(text: '0');

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _servingSizeController.dispose();
    _servingUnitController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final newFood = FoodEntity(
        id: 0,
        name: _nameController.text.trim(),
        brand: _brandController.text.trim().isNotEmpty
            ? _brandController.text.trim()
            : null,
        servingSize: double.parse(_servingSizeController.text.trim()),
        servingUnit: _servingUnitController.text.trim(),
        calories: int.parse(_caloriesController.text.trim()),
        protein: double.parse(_proteinController.text.trim()),
        carbs: double.parse(_carbsController.text.trim()),
        fat: double.parse(_fatController.text.trim()),
        fiber: double.tryParse(_fiberController.text.trim()) ?? 0.0,
        isVerified: false,
      );

      final created = await ref.read(foodRepositoryProvider).createCustomFood(newFood);
      ref.read(foodSearchProvider.notifier).addCustomFoodLocally(created);

      if (mounted) {
        widget.onFoodCreated?.call(created);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Created custom food: ${created.name}')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Custom Food',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.fat.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: AppColors.fat, fontSize: 13),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppTextField(
                label: 'Food Name *',
                hintText: 'e.g. Grandma\'s Apple Pie',
                controller: _nameController,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Food name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Brand (Optional)',
                hintText: 'e.g. Homemade, Trader Joe\'s',
                controller: _brandController,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Serving Size *',
                      hintText: '100',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _servingSizeController,
                      validator: (val) {
                        final n = double.tryParse(val ?? '');
                        return n == null || n <= 0 ? 'Enter valid size' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Serving Unit *',
                      hintText: 'g, ml, piece',
                      controller: _servingUnitController,
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Nutritional Information (per serving)',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Calories (kcal) *',
                hintText: 'e.g. 250',
                keyboardType: TextInputType.number,
                controller: _caloriesController,
                validator: (val) {
                  final n = int.tryParse(val ?? '');
                  return n == null || n < 0 ? 'Enter calories' : null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Protein (g) *',
                      hintText: '0',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _proteinController,
                      validator: (val) =>
                          double.tryParse(val ?? '') == null ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      label: 'Carbs (g) *',
                      hintText: '0',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _carbsController,
                      validator: (val) =>
                          double.tryParse(val ?? '') == null ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      label: 'Fat (g) *',
                      hintText: '0',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _fatController,
                      validator: (val) =>
                          double.tryParse(val ?? '') == null ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Fiber (g, optional)',
                hintText: '0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: _fiberController,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: 'Save Custom Food',
                isLoading: _isSubmitting,
                onPressed: _handleSubmit,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

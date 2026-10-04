import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../nutrition/domain/entities/nutrition_goal_entity.dart';
import '../../../nutrition/presentation/providers/nutrition_goal_provider.dart';

class NutritionGoalsEditorSheet extends ConsumerStatefulWidget {
  final NutritionGoalEntity currentGoal;

  const NutritionGoalsEditorSheet({
    super.key,
    required this.currentGoal,
  });

  @override
  ConsumerState<NutritionGoalsEditorSheet> createState() =>
      _NutritionGoalsEditorSheetState();
}

class _NutritionGoalsEditorSheetState
    extends ConsumerState<NutritionGoalsEditorSheet> {
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _waterController;

  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _caloriesController =
        TextEditingController(text: widget.currentGoal.dailyCalories.toString());
    _proteinController =
        TextEditingController(text: widget.currentGoal.proteinGrams.toString());
    _carbsController =
        TextEditingController(text: widget.currentGoal.carbsGrams.toString());
    _fatController =
        TextEditingController(text: widget.currentGoal.fatGrams.toString());
    _waterController =
        TextEditingController(text: widget.currentGoal.waterMl.toString());

    _caloriesController.addListener(_onFieldChanged);
    _proteinController.addListener(_onFieldChanged);
    _carbsController.addListener(_onFieldChanged);
    _fatController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  int get _parsedCalories => int.tryParse(_caloriesController.text) ?? 0;
  int get _parsedProtein => int.tryParse(_proteinController.text) ?? 0;
  int get _parsedCarbs => int.tryParse(_carbsController.text) ?? 0;
  int get _parsedFat => int.tryParse(_fatController.text) ?? 0;
  int get _parsedWater => int.tryParse(_waterController.text) ?? 0;

  int get _calculatedMacroCalories =>
      (_parsedProtein * 4) + (_parsedCarbs * 4) + (_parsedFat * 9);

  Future<void> _saveGoals() async {
    setState(() {
      _isSaving = true;
      _error = null;
    });

    if (_parsedCalories < 500 || _parsedCalories > 10000) {
      setState(() {
        _isSaving = false;
        _error = 'Daily calories should be between 500 and 10,000 kcal';
      });
      return;
    }

    if (_parsedProtein < 0 || _parsedCarbs < 0 || _parsedFat < 0) {
      setState(() {
        _isSaving = false;
        _error = 'Macronutrient targets cannot be negative';
      });
      return;
    }

    final newGoal = widget.currentGoal.copyWith(
      dailyCalories: _parsedCalories,
      proteinGrams: _parsedProtein,
      carbsGrams: _parsedCarbs,
      fatGrams: _parsedFat,
      waterMl: _parsedWater,
    );

    try {
      await ref
          .read(nutritionGoalNotifierProvider.notifier)
          .overrideGoal(newGoal);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nutrition goals updated successfully!'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final macroCals = _calculatedMacroCalories;
    final targetCals = _parsedCalories;
    final diff = macroCals - targetCals;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: AppRadius.r4,
                ),
              ),
            ),
            AppSpacing.gapH16,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Nutrition Goals',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      AppSpacing.gapH4,
                      Text(
                        'Override your daily caloric and macro targets',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            AppSpacing.gapH16,
            if (_error != null) ...[
              Container(
                padding: AppSpacing.p12,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.r12,
                  border:
                      Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _error!,
                  style:
                      AppTypography.bodySmall.copyWith(color: AppColors.error),
                ),
              ),
              AppSpacing.gapH12,
            ],

            // Daily Calories
            AppTextField(
              controller: _caloriesController,
              label: 'Daily Calories (kcal)',
              hintText: 'e.g. 2000',
              keyboardType: TextInputType.number,
              prefixIcon:
                  const Icon(Icons.local_fire_department_rounded, color: AppColors.primary),
            ),
            AppSpacing.gapH12,

            // Macros Row (Protein, Carbs, Fat)
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _proteinController,
                    label: 'Protein (g)',
                    hintText: '130',
                    keyboardType: TextInputType.number,
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: AppTextField(
                    controller: _carbsController,
                    label: 'Carbs (g)',
                    hintText: '220',
                    keyboardType: TextInputType.number,
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: AppTextField(
                    controller: _fatController,
                    label: 'Fat (g)',
                    hintText: '65',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            AppSpacing.gapH8,

            // Macro summary / balance indicator
            Container(
              padding: AppSpacing.p12,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: AppRadius.r12,
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    diff.abs() < 50
                        ? Icons.check_circle_outline_rounded
                        : Icons.info_outline_rounded,
                    color: diff.abs() < 50 ? AppColors.primary : AppColors.secondary,
                    size: 18,
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(
                      'Macros add up to $macroCals kcal (${diff >= 0 ? '+' : ''}$diff kcal vs target)',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH12,

            // Daily Water Target
            AppTextField(
              controller: _waterController,
              label: 'Daily Water Target (ml)',
              hintText: 'e.g. 2500',
              keyboardType: TextInputType.number,
              prefixIcon:
                  const Icon(Icons.water_drop_rounded, color: Colors.blueAccent),
            ),
            AppSpacing.gapH20,

            // Save Button
            AppButton.primary(
              text: 'Save Custom Goals',
              isLoading: _isSaving,
              onPressed: _saveGoals,
            ),
          ],
        ),
      ),
    );
  }
}

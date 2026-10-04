import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'onboarding_option_card.dart';

class DietStepView extends StatelessWidget {
  final String selectedDiet;
  final ValueChanged<String> onSelectDiet;

  const DietStepView({
    super.key,
    required this.selectedDiet,
    required this.onSelectDiet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final diets = [
      (
        id: 'everything',
        title: 'Everything',
        subtitle: 'No restrictions, all nutrient-dense foods',
        icon: Icons.restaurant_rounded,
      ),
      (
        id: 'vegetarian',
        title: 'Vegetarian',
        subtitle: 'Plant foods + dairy, paneer, and eggs',
        icon: Icons.eco_rounded,
      ),
      (
        id: 'vegan',
        title: 'Vegan',
        subtitle: 'Strictly 100% plant-derived nutrition',
        icon: Icons.spa_rounded,
      ),
      (
        id: 'pescatarian',
        title: 'Pescatarian',
        subtitle: 'Vegetarian diet enriched with fish & seafood',
        icon: Icons.set_meal_rounded,
      ),
      (
        id: 'keto',
        title: 'Keto',
        subtitle: 'High healthy fat, low carb ketogenic target',
        icon: Icons.egg_rounded,
      ),
      (
        id: 'other',
        title: 'Other / Flexible',
        subtitle: 'Custom preferences or flexible eating style',
        icon: Icons.more_horiz_rounded,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Any diet preference?',
            style: AppTypography.headlineMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Used by our AI to customize meal insights and suggestions.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...diets.map(
            (d) => OnboardingOptionCard(
              title: d.title,
              subtitle: d.subtitle,
              icon: d.icon,
              isSelected: selectedDiet == d.id,
              onTap: () => onSelectDiet(d.id),
            ),
          ),
        ],
      ),
    );
  }
}

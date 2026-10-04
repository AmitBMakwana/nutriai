import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'onboarding_option_card.dart';

class GenderStepView extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onSelectGender;

  const GenderStepView({
    super.key,
    required this.selectedGender,
    required this.onSelectGender,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final genders = [
      (
        id: 'male',
        title: 'Male',
        subtitle: 'Biological male metabolic rate calculation',
        icon: Icons.male_rounded,
      ),
      (
        id: 'female',
        title: 'Female',
        subtitle: 'Biological female metabolic rate calculation',
        icon: Icons.female_rounded,
      ),
      (
        id: 'prefer_not_to_say',
        title: 'Prefer not to say',
        subtitle: 'Standardized median metabolic baseline',
        icon: Icons.person_outline_rounded,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            "What's your gender?",
            style: AppTypography.headlineMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Used to calculate your calorie and nutrient needs accurately.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...genders.map(
            (g) => OnboardingOptionCard(
              title: g.title,
              subtitle: g.subtitle,
              icon: g.icon,
              isSelected: selectedGender == g.id,
              onTap: () => onSelectGender(g.id),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'onboarding_option_card.dart';

class GoalStepView extends StatelessWidget {
  final String selectedGoal;
  final ValueChanged<String> onSelectGoal;

  const GoalStepView({
    super.key,
    required this.selectedGoal,
    required this.onSelectGoal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final goals = [
      (
        id: 'lose_weight',
        title: 'Lose Weight',
        subtitle: 'Burn fat and get leaner sustainably',
        icon: Icons.trending_down_rounded,
      ),
      (
        id: 'maintain',
        title: 'Maintain Weight',
        subtitle: 'Stay healthy and balance your energy',
        icon: Icons.balance_rounded,
      ),
      (
        id: 'gain_weight',
        title: 'Gain Weight',
        subtitle: 'Build healthy mass with balanced nutrition',
        icon: Icons.trending_up_rounded,
      ),
      (
        id: 'build_muscle',
        title: 'Build Muscle',
        subtitle: 'High-protein targets to fuel muscle growth',
        icon: Icons.fitness_center_rounded,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            "What's your goal?",
            style: AppTypography.headlineMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'We will tailor your daily calories and macro targets around this.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...goals.map(
            (goal) => OnboardingOptionCard(
              title: goal.title,
              subtitle: goal.subtitle,
              icon: goal.icon,
              isSelected: selectedGoal == goal.id,
              onTap: () => onSelectGoal(goal.id),
            ),
          ),
        ],
      ),
    );
  }
}

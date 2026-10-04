import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'onboarding_option_card.dart';

class ActivityStepView extends StatelessWidget {
  final String selectedActivity;
  final ValueChanged<String> onSelectActivity;

  const ActivityStepView({
    super.key,
    required this.selectedActivity,
    required this.onSelectActivity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activities = [
      (
        id: 'sedentary',
        title: 'Sedentary',
        subtitle: 'Desk job, little to no regular workout',
        icon: Icons.chair_rounded,
      ),
      (
        id: 'lightly_active',
        title: 'Lightly Active',
        subtitle: '1-3 light sessions or daily walks',
        icon: Icons.directions_walk_rounded,
      ),
      (
        id: 'moderately_active',
        title: 'Moderately Active',
        subtitle: '3-5 sports or gym workouts per week',
        icon: Icons.fitness_center_rounded,
      ),
      (
        id: 'very_active',
        title: 'Very Active',
        subtitle: '6-7 heavy training sessions per week',
        icon: Icons.sports_gymnastics_rounded,
      ),
      (
        id: 'extremely_active',
        title: 'Extremely Active',
        subtitle: 'Intensive manual work + 2x daily training',
        icon: Icons.bolt_rounded,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'How active are you?',
            style: AppTypography.headlineMedium.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Activity multipliers directly scale your daily caloric allowance.',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...activities.map(
            (act) => OnboardingOptionCard(
              title: act.title,
              subtitle: act.subtitle,
              icon: act.icon,
              isSelected: selectedActivity == act.id,
              onTap: () => onSelectActivity(act.id),
            ),
          ),
        ],
      ),
    );
  }
}

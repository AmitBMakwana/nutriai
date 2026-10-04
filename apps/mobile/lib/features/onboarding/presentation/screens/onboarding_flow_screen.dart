import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../nutrition/domain/entities/nutrition_goal_entity.dart';
import '../../../nutrition/presentation/providers/nutrition_goal_provider.dart';
import '../../../nutrition/presentation/widgets/adjust_plan_bottom_sheet.dart';
import '../../../nutrition/presentation/widgets/daily_plan_result_view.dart';
import '../providers/onboarding_provider.dart';
import '../providers/onboarding_state.dart';
import '../widgets/activity_step_view.dart';
import '../widgets/birthday_step_view.dart';
import '../widgets/calculating_plan_view.dart';
import '../widgets/diet_step_view.dart';
import '../widgets/gender_step_view.dart';
import '../widgets/goal_step_view.dart';
import '../widgets/height_step_view.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/target_weight_step_view.dart';
import '../widgets/weight_step_view.dart';

class OnboardingFlowScreen extends ConsumerWidget {
  const OnboardingFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final nutritionState = ref.watch(nutritionGoalNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isPlanResult = state.currentStep == 8 && state.isSuccess;
    final isCalculating = state.currentStep == 8 && !state.isSuccess;

    return PopScope(
      canPop: state.currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && state.currentStep > 0 && !isCalculating && !isPlanResult) {
          notifier.previousStep();
        }
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              if (!isCalculating && !isPlanResult)
                OnboardingProgressBar(
                  currentStep: state.currentStep,
                  totalSteps: state.totalSteps,
                  onBack: notifier.previousStep,
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<String>('${state.currentStep}_${state.isSuccess}'),
                    child: _buildStepContent(context, ref, state, notifier, nutritionState, isDark),
                  ),
                ),
              ),
              if (!isCalculating && !isPlanResult) ...[
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppButton(
                    text: state.currentStep == 7 ? 'Create My Plan' : 'Continue',
                    onPressed: notifier.nextStep,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(
    BuildContext context,
    WidgetRef ref,
    OnboardingState state,
    OnboardingNotifier notifier,
    dynamic nutritionState,
    bool isDark,
  ) {
    switch (state.currentStep) {
      case 0:
        return GoalStepView(
          selectedGoal: state.goal,
          onSelectGoal: notifier.setGoal,
        );
      case 1:
        return GenderStepView(
          selectedGender: state.gender,
          onSelectGender: notifier.setGender,
        );
      case 2:
        return BirthdayStepView(
          selectedDate: state.dateOfBirth,
          calculatedAge: state.calculatedAge,
          onDateChanged: notifier.setDateOfBirth,
        );
      case 3:
        return HeightStepView(
          isImperial: state.isHeightImperial,
          heightCm: state.heightCm,
          feet: state.heightFeet,
          inches: state.heightInches,
          onToggleUnit: notifier.toggleHeightUnit,
          onCmChanged: notifier.setHeightMetric,
          onImperialChanged: notifier.setHeightImperial,
        );
      case 4:
        return WeightStepView(
          isImperial: state.isWeightImperial,
          weightKg: state.weightKg,
          weightLbs: state.weightLbs,
          onToggleUnit: notifier.toggleWeightUnit,
          onKgChanged: notifier.setWeightMetric,
          onLbsChanged: notifier.setWeightImperial,
        );
      case 5:
        return TargetWeightStepView(
          isImperial: state.isWeightImperial,
          currentWeightKg: state.weightKg,
          targetWeightKg: state.targetWeightKg,
          targetWeightLbs: state.targetWeightLbs,
          onToggleUnit: notifier.toggleWeightUnit,
          onKgChanged: notifier.setTargetWeightMetric,
          onLbsChanged: notifier.setTargetWeightImperial,
        );
      case 6:
        return ActivityStepView(
          selectedActivity: state.activityLevel,
          onSelectActivity: notifier.setActivityLevel,
        );
      case 7:
        return DietStepView(
          selectedDiet: state.dietType,
          onSelectDiet: notifier.setDietType,
        );
      case 8:
      default:
        if (state.isSuccess) {
          final effectiveGoal = nutritionState.goal ??
              _fallbackGoal(state);

          return DailyPlanResultView(
            goal: effectiveGoal,
            onStartTracking: () {
              context.go(AppConstants.homePath);
            },
            onAdjustPlan: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor:
                    isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.sheetRadius,
                ),
                builder: (modalContext) => AdjustPlanBottomSheet(
                  currentGoal: effectiveGoal,
                  onSave: (updated) {
                    ref
                        .read(nutritionGoalNotifierProvider.notifier)
                        .overrideGoal(updated);
                  },
                ),
              );
            },
          );
        }

        return CalculatingPlanView(
          isSubmitting: state.isSubmitting,
          errorMessage: state.errorMessage,
          onRetry: notifier.submitOnboarding,
        );
    }
  }

  NutritionGoalEntity _fallbackGoal(OnboardingState state) {
    // Quick fallback calculation
    final bmr = (10 * state.weightKg) +
        (6.25 * state.heightCm) -
        (5 * state.calculatedAge) +
        (state.gender == 'female' ? -161 : (state.gender == 'male' ? 5 : -78));

    final mult = switch (state.activityLevel) {
      'lightly_active' => 1.375,
      'moderately_active' => 1.55,
      'very_active' => 1.725,
      'extremely_active' => 1.9,
      _ => 1.2,
    };

    final tdee = bmr * mult;
    final calories = (tdee + (state.goal == 'lose_weight' ? -500 : (state.goal == 'gain_weight' ? 300 : (state.goal == 'build_muscle' ? 250 : 0)))).round();
    final protein = ((calories * 0.30) / 4).round();
    final carbs = ((calories * 0.40) / 4).round();
    final fat = ((calories * 0.30) / 9).round();
    final water = (state.weightKg * 35 / 250).round() * 250;

    return NutritionGoalEntity(
      dailyCalories: calories,
      proteinGrams: protein,
      carbsGrams: carbs,
      fatGrams: fat,
      waterMl: water,
    );
  }
}

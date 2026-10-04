import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/features/nutrition/domain/entities/nutrition_goal_entity.dart';

void main() {
  group('NutritionGoalEntity Tests', () {
    test('calculates correct calories per macro and percentages', () {
      final goal = NutritionGoalEntity(
        id: 1,
        userId: 1,
        dailyCalories: 2000,
        proteinGrams: 150,
        carbsGrams: 200,
        fatGrams: 67,
        waterMl: 2750,
      );

      // Protein: 150g * 4 = 600 kcal
      expect(goal.proteinCalories, equals(600));
      // Carbs: 200g * 4 = 800 kcal
      expect(goal.carbsCalories, equals(800));
      // Fat: 67g * 9 = 603 kcal
      expect(goal.fatCalories, equals(603));

      // Total macro calories: 600 + 800 + 603 = 2003
      expect(goal.totalMacroCalories, equals(2003));

      // Percentages relative to total macro calories
      expect(goal.proteinPercentage, closeTo((600 / 2003) * 100, 0.1));
      expect(goal.carbsPercentage, closeTo((800 / 2003) * 100, 0.1));
      expect(goal.fatPercentage, closeTo((603 / 2003) * 100, 0.1));

      // Water: 2750ml = 2.75L, 2750 / 250 = 11 glasses
      expect(goal.waterLiters, equals(2.75));
      expect(goal.waterGlasses, equals(11));
    });

    test('handles zero daily calories gracefully without divide by zero', () {
      final goal = NutritionGoalEntity(
        dailyCalories: 0,
        proteinGrams: 0,
        carbsGrams: 0,
        fatGrams: 0,
        waterMl: 0,
      );

      expect(goal.proteinCalories, equals(0));
      expect(goal.carbsCalories, equals(0));
      expect(goal.fatCalories, equals(0));
      expect(goal.totalMacroCalories, equals(0));
      // Fallbacks
      expect(goal.proteinPercentage, equals(30.0));
      expect(goal.carbsPercentage, equals(40.0));
      expect(goal.fatPercentage, equals(30.0));
      expect(goal.waterLiters, equals(0.0));
      expect(goal.waterGlasses, equals(0));
    });

    test('copyWith updates fields properly', () {
      final goal = NutritionGoalEntity(
        dailyCalories: 2000,
        proteinGrams: 150,
        carbsGrams: 200,
        fatGrams: 65,
        waterMl: 2500,
      );

      final updated = goal.copyWith(
        dailyCalories: 2200,
        proteinGrams: 165,
      );

      expect(updated.dailyCalories, equals(2200));
      expect(updated.proteinGrams, equals(165));
      expect(updated.carbsGrams, equals(200));
      expect(updated.fatGrams, equals(65));
      expect(updated.waterMl, equals(2500));
    });
  });
}

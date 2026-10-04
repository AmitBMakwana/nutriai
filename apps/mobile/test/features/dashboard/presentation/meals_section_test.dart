import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/core/theme/theme.dart';
import 'package:nutriai/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:nutriai/features/dashboard/presentation/widgets/meals_section.dart';

void main() {
  group('MealsSection Widget Tests', () {
    testWidgets('renders empty states for all 4 meal types when no meals logged', (tester) async {
      final emptyMeals = <String, MealGroupEntity>{
        'breakfast': const MealGroupEntity(type: 'breakfast', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
        'lunch': const MealGroupEntity(type: 'lunch', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
        'dinner': const MealGroupEntity(type: 'dinner', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
        'snack': const MealGroupEntity(type: 'snack', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
      };

      String? tappedMealType;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: MealsSection(
                meals: emptyMeals,
                onAddMealForType: (type) => tappedMealType = type,
              ),
            ),
          ),
        ),
      );

      // Section header
      expect(find.text('Today’s Meals'), findsOneWidget);

      // Meal type titles
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
      expect(find.text('Snack'), findsOneWidget);

      // Empty state text
      expect(find.text('No breakfast logged yet'), findsOneWidget);
      expect(find.text('No lunch logged yet'), findsOneWidget);
      expect(find.text('No dinner logged yet'), findsOneWidget);
      expect(find.text('No snack logged yet'), findsOneWidget);

      // Calories 0 kcal
      expect(find.text('0 kcal'), findsNWidgets(4));

      // Add buttons
      final addButtons = find.text('Add');
      expect(addButtons, findsNWidgets(4));

      // Tap on Breakfast Add button
      await tester.tap(addButtons.first);
      await tester.pumpAndSettle();

      expect(tappedMealType, equals('breakfast'));
    });

    testWidgets('renders meal entries when meals are populated', (tester) async {
      final populatedMeals = <String, MealGroupEntity>{
        'breakfast': const MealGroupEntity(
          type: 'breakfast',
          calories: 450,
          protein: 30,
          carbs: 50,
          fat: 15,
          meals: [
            MealEntryEntity(
              id: 1,
              mealType: 'breakfast',
              mealDate: '2026-10-02',
              mealTime: '08:30 AM',
              totalCalories: 450,
              totalProtein: 30,
              totalCarbs: 50,
              totalFat: 15,
              items: [
                MealItemSummaryEntity(
                  id: 1,
                  foodName: 'Oatmeal with berries',
                  quantity: 1,
                  unit: 'bowl',
                  calories: 450,
                ),
              ],
            ),
          ],
        ),
        'lunch': const MealGroupEntity(type: 'lunch', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
        'dinner': const MealGroupEntity(type: 'dinner', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
        'snack': const MealGroupEntity(type: 'snack', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
      };

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: MealsSection(meals: populatedMeals),
            ),
          ),
        ),
      );

      expect(find.text('450 kcal'), findsNWidgets(2));
      expect(find.text('Oatmeal with berries'), findsOneWidget);
      expect(find.text('08:30 AM'), findsOneWidget);
      expect(find.text('P: 30g  C: 50g  F: 15g'), findsOneWidget);
    });
  });
}

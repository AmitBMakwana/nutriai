import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/core/theme/theme.dart';
import 'package:nutriai/features/nutrition/domain/entities/nutrition_goal_entity.dart';
import 'package:nutriai/features/nutrition/presentation/widgets/daily_plan_result_view.dart';
import 'package:nutriai/features/nutrition/presentation/widgets/macro_target_card.dart';
import 'package:nutriai/features/nutrition/presentation/widgets/water_target_card.dart';

void main() {
  final testGoal = NutritionGoalEntity(
    id: 1,
    userId: 1,
    dailyCalories: 2125,
    proteinGrams: 159,
    carbsGrams: 213,
    fatGrams: 71,
    waterMl: 2750,
  );

  Widget createWidgetUnderTest({
    NutritionGoalEntity? goal,
    VoidCallback? onStartTracking,
    VoidCallback? onAdjustPlan,
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: DailyPlanResultView(
            goal: goal ?? testGoal,
            onStartTracking: onStartTracking ?? () {},
            onAdjustPlan: onAdjustPlan ?? () {},
          ),
        ),
      ),
    );
  }

  group('DailyPlanResultView Widget Tests', () {
    testWidgets('renders daily plan title, calorie target, macro and water cards, and disclaimer', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Heading
      expect(find.text('Your Daily Plan'), findsOneWidget);
      expect(find.text('Calibrated using your metabolic rate and body goal.'), findsOneWidget);

      // Calorie card
      expect(find.text('DAILY TARGET'), findsOneWidget);
      expect(find.text('2,125'), findsOneWidget);
      expect(find.text('kcal / day'), findsOneWidget);

      // Macro breakdown
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('Carbs'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);
      expect(find.byType(MacroTargetCard), findsNWidgets(3));

      // Water target
      expect(find.text('Daily Hydration Target'), findsOneWidget);
      expect(find.byType(WaterTargetCard), findsOneWidget);
      expect(find.text('2750 ml (2.8 L)'), findsOneWidget);
      expect(find.text('11 glasses'), findsOneWidget);

      // Medical disclaimer note
      expect(
        find.textContaining('estimates, not medical advice', findRichText: false),
        findsOneWidget,
      );

      // Action buttons
      expect(find.text('Start Tracking'), findsOneWidget);
      expect(find.text('Adjust Plan'), findsOneWidget);
    });

    testWidgets('tapping Start Tracking triggers onStartTracking callback', (tester) async {
      bool tracked = false;
      await tester.pumpWidget(
        createWidgetUnderTest(
          onStartTracking: () => tracked = true,
        ),
      );

      final trackButton = find.text('Start Tracking');
      expect(trackButton, findsOneWidget);

      await tester.ensureVisible(trackButton);
      await tester.tap(trackButton);
      await tester.pumpAndSettle();

      expect(tracked, isTrue);
    });

    testWidgets('tapping Adjust Plan triggers onAdjustPlan callback', (tester) async {
      bool adjusted = false;
      await tester.pumpWidget(
        createWidgetUnderTest(
          onAdjustPlan: () => adjusted = true,
        ),
      );

      final adjustButton = find.text('Adjust Plan');
      expect(adjustButton, findsOneWidget);

      await tester.ensureVisible(adjustButton);
      await tester.tap(adjustButton);
      await tester.pumpAndSettle();

      expect(adjusted, isTrue);
    });
  });
}

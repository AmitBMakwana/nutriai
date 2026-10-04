import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/core/theme/theme.dart';
import 'package:nutriai/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:nutriai/features/dashboard/presentation/widgets/calorie_ring.dart';

void main() {
  group('CalorieRing Widget Tests', () {
    testWidgets('renders remaining calories when under target', (tester) async {
      const calories = CalorieSummaryEntity(
        target: 2100,
        consumed: 1300,
        remaining: 800,
        percentage: 61.9,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: CalorieRing(calories: calories),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('800'), findsOneWidget);
      expect(find.text('kcal remaining'), findsOneWidget);
      expect(find.text('Consumed: '), findsOneWidget);
      expect(find.text('1,300 kcal'), findsOneWidget);
      expect(find.text('Goal: '), findsOneWidget);
      expect(find.text('2,100 kcal'), findsOneWidget);
    });

    testWidgets('renders over-target state gracefully when consumed exceeds target', (tester) async {
      const calories = CalorieSummaryEntity(
        target: 2000,
        consumed: 2350,
        remaining: -350,
        percentage: 117.5,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: CalorieRing(calories: calories),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('+350'), findsOneWidget);
      expect(find.text('kcal over goal'), findsOneWidget);
      expect(find.text('2,350 kcal'), findsOneWidget);
      expect(find.text('2,000 kcal'), findsOneWidget);
    });
  });
}

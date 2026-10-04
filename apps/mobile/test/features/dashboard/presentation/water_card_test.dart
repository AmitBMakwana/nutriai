import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:nutriai/features/dashboard/presentation/widgets/water_card.dart';

void main() {
  group('WaterCard Widget Tests', () {
    const testWater = WaterSummaryEntity(
      consumed: 1250,
      target: 2500,
      remaining: 1250,
      percentage: 50.0,
    );

    testWidgets('renders hydration title, consumption text, and 4 quick add chips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WaterCard(
              water: testWater,
              canUndo: true,
              onUndo: () {},
            ),
          ),
        ),
      );

      expect(find.text('Hydration'), findsOneWidget);
      expect(find.text('1250 ml'), findsOneWidget);
      expect(find.text('/ 2500 ml'), findsOneWidget);
      expect(find.text('+250 ml'), findsOneWidget);
      expect(find.text('+500 ml'), findsOneWidget);
      expect(find.text('+750 ml'), findsOneWidget);
      expect(find.text('+1000 ml'), findsOneWidget);
      expect(find.byIcon(Icons.undo_rounded), findsOneWidget);
    });

    testWidgets('tapping quick add chip calls onAddWater with exact amount', (tester) async {
      int? tappedAmount;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WaterCard(
              water: testWater,
              onAddWater: (amount) => tappedAmount = amount,
            ),
          ),
        ),
      );

      await tester.tap(find.text('+500 ml'));
      await tester.pump();

      expect(tappedAmount, 500);

      await tester.tap(find.text('+1000 ml'));
      await tester.pump();

      expect(tappedAmount, 1000);
    });

    testWidgets('tapping undo button calls onUndo callback when canUndo is true', (tester) async {
      bool undoTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WaterCard(
              water: testWater,
              canUndo: true,
              onUndo: () => undoTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.undo_rounded));
      await tester.pump();

      expect(undoTapped, isTrue);
    });
  });
}

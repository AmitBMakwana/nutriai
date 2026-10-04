import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/features/weight/domain/entities/weight_log_entity.dart';
import 'package:nutriai/features/weight/presentation/widgets/weight_history_list.dart';
import 'package:nutriai/features/weight/presentation/widgets/weight_line_chart.dart';

void main() {
  group('Weight Widgets Tests', () {
    final testDate = DateTime(2026, 10, 2);
    final log1 = WeightLogEntity(id: 1, weightKg: 75.0, loggedAt: testDate);
    final log2 = WeightLogEntity(id: 2, weightKg: 74.5, loggedAt: testDate.add(const Duration(days: 1)));

    testWidgets('WeightLineChart renders empty placeholder when no logs provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WeightLineChart(
              logs: [],
              unitSystem: 'metric',
            ),
          ),
        ),
      );

      expect(find.text('No weight entries yet'), findsOneWidget);
      expect(find.byIcon(Icons.show_chart_rounded), findsOneWidget);
    });

    testWidgets('WeightHistoryList renders items and delete dialog triggers callback', (tester) async {
      int? deletedId;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeightHistoryList(
              logs: [log1, log2],
              unitSystem: 'metric',
              onDelete: (id) => deletedId = id,
            ),
          ),
        ),
      );

      expect(find.text('Weight History'), findsOneWidget);
      expect(find.text('2 entries'), findsOneWidget);
      expect(find.text('75.0 kg'), findsOneWidget);
      expect(find.text('74.5 kg'), findsOneWidget);

      // Tap delete on first trash icon
      await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
      await tester.pumpAndSettle();

      // Confirmation dialog should be visible
      expect(find.text('Delete Weight Entry'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Confirm delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(deletedId, 2); // newest item (log2 with id 2) is first in reversed list
    });

    testWidgets('WeightHistoryList respects imperial unitSystem display', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeightHistoryList(
              logs: [log1],
              unitSystem: 'imperial',
            ),
          ),
        ),
      );

      // 75.0 kg * 2.20462 = 165.3 lb
      expect(find.text('165.3 lb'), findsOneWidget);
    });
  });
}

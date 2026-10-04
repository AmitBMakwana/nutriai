import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/features/meals/presentation/widgets/scan_error_views.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  group('Meal Scan Error Widgets Tests', () {
    testWidgets('ScanQuotaExceededView displays quota message and triggers callbacks', (tester) async {
      bool upgraded = false;
      bool manuallyEntered = false;

      await tester.pumpWidget(
        buildTestableWidget(
          ScanQuotaExceededView(
            onUpgrade: () => upgraded = true,
            onEnterManually: () => manuallyEntered = true,
          ),
        ),
      );

      expect(find.text('Monthly Scans Reached'), findsOneWidget);
      expect(find.textContaining('reached your 5 free AI scans'), findsOneWidget);

      await tester.tap(find.text('Upgrade to NutriAI Pro'));
      await tester.pump();
      expect(upgraded, isTrue);

      await tester.tap(find.text('Enter Meal Manually'));
      await tester.pump();
      expect(manuallyEntered, isTrue);
    });

    testWidgets('ScanNonFoodView displays non-food message and triggers retake', (tester) async {
      bool retaken = false;
      bool manuallyEntered = false;

      await tester.pumpWidget(
        buildTestableWidget(
          ScanNonFoodView(
            message: 'A photo of a water bottle and keys.',
            onRetake: () => retaken = true,
            onEnterManually: () => manuallyEntered = true,
          ),
        ),
      );

      expect(find.text('No Food Detected'), findsOneWidget);
      expect(find.text('A photo of a water bottle and keys.'), findsOneWidget);

      await tester.tap(find.text('Retake Photo'));
      await tester.pump();
      expect(retaken, isTrue);

      await tester.tap(find.text('Enter Meal Manually'));
      await tester.pump();
      expect(manuallyEntered, isTrue);
    });

    testWidgets('ScanServiceErrorView displays service error and triggers retry', (tester) async {
      bool retried = false;
      bool manuallyEntered = false;

      await tester.pumpWidget(
        buildTestableWidget(
          ScanServiceErrorView(
            message: 'Connection timed out to vision service.',
            onRetry: () => retried = true,
            onEnterManually: () => manuallyEntered = true,
          ),
        ),
      );

      expect(find.text('AI Service Unavailable'), findsOneWidget);
      expect(find.text('Connection timed out to vision service.'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();
      expect(retried, isTrue);

      await tester.tap(find.text('Enter Meal Manually'));
      await tester.pump();
      expect(manuallyEntered, isTrue);
    });
  });
}

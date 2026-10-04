import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/features/subscription/data/repositories/subscription_repository.dart';
import 'package:nutriai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:nutriai/features/subscription/domain/services/purchases_service.dart';
import 'package:nutriai/features/subscription/presentation/screens/paywall_screen.dart';

class MockSubscriptionRepository extends Mock implements ISubscriptionRepository {}
class MockPurchasesService extends Mock implements IPurchasesService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSubscriptionRepository mockRepo;
  late MockPurchasesService mockPurchases;

  const testSubscription = SubscriptionEntity(
    plan: 'free',
    status: 'none',
    isPro: false,
    quota: 5,
    usedScans: 3,
    remainingScans: 2,
    features: ['5 AI meal scans per month'],
  );

  final testPackages = [
    const SubscriptionPackage(
      id: 'nutriai_pro_annual',
      title: 'Pro Annual',
      description: '100 AI scans/month, full analytics',
      priceString: '\$4.99 / month',
      period: 'annual',
      price: 59.99,
      isBestValue: true,
      badgeText: 'SAVE 50%',
    ),
    const SubscriptionPackage(
      id: 'nutriai_pro_monthly',
      title: 'Pro Monthly',
      description: '100 AI scans/month, cancel anytime',
      priceString: '\$9.99 / month',
      period: 'monthly',
      price: 9.99,
      isBestValue: false,
    ),
  ];

  setUp(() {
    mockRepo = MockSubscriptionRepository();
    mockPurchases = MockPurchasesService();
    when(() => mockRepo.getSubscription()).thenAnswer((_) async => testSubscription);
    when(() => mockPurchases.getOfferings()).thenAnswer((_) async => testPackages);
  });

  testWidgets('PaywallScreen renders usage indicator ("3 of 5 scans used"), titles, and upgrade buttons', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subscriptionRepositoryProvider.overrideWithValue(mockRepo),
          purchasesServiceProvider.overrideWithValue(mockPurchases),
        ],
        child: const MaterialApp(
          home: PaywallScreen(),
        ),
      ),
    );

    // Initial render
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify title and usage indicator
    expect(find.text('Unlock NutriAI Pro'), findsOneWidget);
    expect(find.text('3 of 5 scans used'), findsOneWidget);
    expect(find.text('2 scans remaining this month on Free Plan.'), findsOneWidget);

    // Verify billing cycle options
    expect(find.text('Annual'), findsOneWidget);
    expect(find.text('Monthly'), findsOneWidget);
    expect(find.text('SAVE 50%'), findsNWidgets(2));

    // Verify CTA and restore buttons
    expect(find.text('Upgrade to Pro Now'), findsOneWidget);
    expect(find.text('Restore Purchases'), findsOneWidget);
  });
}

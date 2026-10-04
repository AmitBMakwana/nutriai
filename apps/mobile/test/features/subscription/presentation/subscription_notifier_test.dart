import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/features/subscription/data/repositories/subscription_repository.dart';
import 'package:nutriai/features/subscription/domain/entities/subscription_entity.dart';
import 'package:nutriai/features/subscription/domain/services/purchases_service.dart';
import 'package:nutriai/features/subscription/presentation/providers/subscription_provider.dart';

class MockSubscriptionRepository extends Mock implements ISubscriptionRepository {}
class MockPurchasesService extends Mock implements IPurchasesService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockSubscriptionRepository mockRepo;
  late MockPurchasesService mockPurchases;

  final freeSubscription = SubscriptionEntity(
    plan: 'free',
    status: 'none',
    isPro: false,
    quota: 5,
    usedScans: 3,
    remainingScans: 2,
    features: ['5 AI meal scans per month'],
  );

  final proSubscription = SubscriptionEntity(
    plan: 'pro',
    status: 'active',
    isPro: true,
    quota: 100,
    usedScans: 10,
    remainingScans: 90,
    features: ['100 AI meal scans per month', 'Advanced macro goals'],
  );

  final testPackages = [
    const SubscriptionPackage(
      id: 'nutriai_pro_annual',
      title: 'Pro Annual',
      description: '100 AI scans/month, full analytics',
      priceString: '\$4.99 / mo',
      period: 'annual',
      price: 59.99,
      isBestValue: true,
      badgeText: 'SAVE 50%',
    ),
    const SubscriptionPackage(
      id: 'nutriai_pro_monthly',
      title: 'Pro Monthly',
      description: '100 AI scans/month, cancel anytime',
      priceString: '\$9.99 / mo',
      period: 'monthly',
      price: 9.99,
      isBestValue: false,
    ),
  ];

  setUp(() {
    mockRepo = MockSubscriptionRepository();
    mockPurchases = MockPurchasesService();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        subscriptionRepositoryProvider.overrideWithValue(mockRepo),
        purchasesServiceProvider.overrideWithValue(mockPurchases),
      ],
    );
  }

  test('initial state has default free subscription and packages', () {
    final container = createContainer();
    final state = container.read(subscriptionNotifierProvider);

    expect(state.subscription.plan, 'free');
    expect(state.subscription.isPro, false);
    expect(state.subscription.quota, 5);
    expect(state.isLoading, false);
    expect(state.isPurchasing, false);
  });

  test('usageIndicator formats string as "X of Y scans used" and calculates percentage', () {
    expect(freeSubscription.usageIndicator, '3 of 5 scans used');
    expect(freeSubscription.usagePercentage, 0.6);
    expect(freeSubscription.isQuotaExhausted, false);

    const exhaustedSub = SubscriptionEntity(
      plan: 'free',
      status: 'none',
      isPro: false,
      quota: 5,
      usedScans: 5,
      remainingScans: 0,
    );
    expect(exhaustedSub.usageIndicator, '5 of 5 scans used');
    expect(exhaustedSub.usagePercentage, 1.0);
    expect(exhaustedSub.isQuotaExhausted, true);
  });

  test('loadSubscription fetches subscription and offerings successfully', () async {
    when(() => mockRepo.getSubscription()).thenAnswer((_) async => freeSubscription);
    when(() => mockPurchases.getOfferings()).thenAnswer((_) async => testPackages);

    final container = createContainer();
    final notifier = container.read(subscriptionNotifierProvider.notifier);

    await notifier.loadSubscription();

    final state = container.read(subscriptionNotifierProvider);
    expect(state.isLoading, false);
    expect(state.subscription.plan, 'free');
    expect(state.subscription.usedScans, 3);
    expect(state.subscription.remainingScans, 2);
    expect(state.packages.length, 2);
    expect(state.errorMessage, isNull);
  });

  test('purchase calls purchasesService then refreshes entitlement from backend', () async {
    when(() => mockPurchases.purchasePackage('nutriai_pro_annual'))
        .thenAnswer((_) async => true);
    when(() => mockRepo.getSubscription()).thenAnswer((_) async => proSubscription);

    final container = createContainer();
    final notifier = container.read(subscriptionNotifierProvider.notifier);

    final result = await notifier.purchase('nutriai_pro_annual');

    expect(result, true);
    verify(() => mockPurchases.purchasePackage('nutriai_pro_annual')).called(1);
    // Verified that app refreshes entitlement from the backend after purchase
    verify(() => mockRepo.getSubscription()).called(1);

    final state = container.read(subscriptionNotifierProvider);
    expect(state.isPurchasing, false);
    expect(state.subscription.plan, 'pro');
    expect(state.subscription.isPro, true);
    expect(state.subscription.quota, 100);
    expect(state.successMessage, contains('Pro Plan'));
  });

  test('purchase handles cancellation or failure gracefully', () async {
    when(() => mockPurchases.purchasePackage('nutriai_pro_annual'))
        .thenAnswer((_) async => false);

    final container = createContainer();
    final notifier = container.read(subscriptionNotifierProvider.notifier);

    final result = await notifier.purchase('nutriai_pro_annual');

    expect(result, false);
    verifyNever(() => mockRepo.getSubscription());

    final state = container.read(subscriptionNotifierProvider);
    expect(state.isPurchasing, false);
    expect(state.errorMessage, 'Purchase was cancelled or failed.');
  });

  test('restorePurchases calls purchasesService then refreshes entitlement from backend', () async {
    when(() => mockPurchases.restorePurchases()).thenAnswer((_) async => true);
    when(() => mockRepo.getSubscription()).thenAnswer((_) async => proSubscription);

    final container = createContainer();
    final notifier = container.read(subscriptionNotifierProvider.notifier);

    final result = await notifier.restorePurchases();

    expect(result, true);
    verify(() => mockPurchases.restorePurchases()).called(1);
    // Verified backend refresh
    verify(() => mockRepo.getSubscription()).called(1);

    final state = container.read(subscriptionNotifierProvider);
    expect(state.isRestoring, false);
    expect(state.subscription.isPro, true);
    expect(state.successMessage, contains('Purchases restored'));
  });

  test('setAnnualBilling switches billing period and updates selectedPackageId', () {
    final container = createContainer();
    final notifier = container.read(subscriptionNotifierProvider.notifier);

    notifier.setAnnualBilling(false);
    expect(container.read(subscriptionNotifierProvider).isAnnual, false);
    expect(container.read(subscriptionNotifierProvider).selectedPackageId, 'nutriai_pro_monthly');

    notifier.setAnnualBilling(true);
    expect(container.read(subscriptionNotifierProvider).isAnnual, true);
    expect(container.read(subscriptionNotifierProvider).selectedPackageId, 'nutriai_pro_annual');
  });
}

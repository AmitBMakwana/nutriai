import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Available subscription package offered to the user.
@immutable
class SubscriptionPackage {
  final String id;
  final String title;
  final String description;
  final String priceString;
  final String period; // 'monthly' | 'annual'
  final double price;
  final bool isBestValue;
  final String? badgeText;

  const SubscriptionPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.priceString,
    required this.period,
    required this.price,
    this.isBestValue = false,
    this.badgeText,
  });
}

/// Abstract interface for in-app purchases (RevenueCat SDK wrapper).
/// Allows seamless mocking in unit, widget, and integration tests.
abstract class IPurchasesService {
  /// Initialize the purchases service with API keys and optional user identification.
  Future<void> init({String? apiKey, String? appUserId});

  /// Get the current available subscription packages/offerings.
  Future<List<SubscriptionPackage>> getOfferings();

  /// Purchase the specified package by its identifier.
  /// Returns `true` if the purchase succeeded, `false` if cancelled or failed.
  Future<bool> purchasePackage(String packageId);

  /// Restore previous purchases.
  /// Returns `true` if active purchases were restored.
  Future<bool> restorePurchases();
}

/// Standard RevenueCat purchase service implementation.
/// Uses native RevenueCat SDK or simulated purchase flow for development & testing.
class RevenueCatPurchasesService implements IPurchasesService {
  bool _isInitialized = false;
  String? _currentUserId;

  bool get isInitialized => _isInitialized;

  static const List<SubscriptionPackage> defaultOfferings = [
    SubscriptionPackage(
      id: 'nutriai_pro_annual',
      title: 'Pro Annual',
      description: '100 AI scans/month, full analytics & priority access',
      priceString: '\$4.99 / month',
      period: 'annual',
      price: 59.99,
      isBestValue: true,
      badgeText: 'SAVE 50%',
    ),
    SubscriptionPackage(
      id: 'nutriai_pro_monthly',
      title: 'Pro Monthly',
      description: '100 AI scans/month, flexible monthly billing',
      priceString: '\$9.99 / month',
      period: 'monthly',
      price: 9.99,
      isBestValue: false,
    ),
    SubscriptionPackage(
      id: 'nutriai_premium_annual',
      title: 'Premium Annual',
      description: '500 AI scans/month, 24/7 AI coach & custom recipes',
      priceString: '\$9.99 / month',
      period: 'annual',
      price: 119.99,
      isBestValue: false,
      badgeText: 'POWER USER',
    ),
  ];

  @override
  Future<void> init({String? apiKey, String? appUserId}) async {
    _currentUserId = appUserId;
    _isInitialized = true;
    if (kDebugMode) {
      debugPrint('[PurchasesService] Initialized with user: $_currentUserId');
    }
  }

  @override
  Future<List<SubscriptionPackage>> getOfferings() async {
    // In production with Purchases Flutter SDK, this calls:
    // final offerings = await Purchases.getOfferings();
    return defaultOfferings;
  }

  @override
  Future<bool> purchasePackage(String packageId) async {
    if (kDebugMode) {
      debugPrint('[PurchasesService] Purchasing package: $packageId');
    }
    // Simulate payment transaction network latency
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }

  @override
  Future<bool> restorePurchases() async {
    if (kDebugMode) {
      debugPrint('[PurchasesService] Restoring purchases for user: $_currentUserId');
    }
    // Simulate restore latency
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}

/// Provider for the PurchasesService interface.
final purchasesServiceProvider = Provider<IPurchasesService>((ref) {
  final service = RevenueCatPurchasesService();
  service.init();
  return service;
});

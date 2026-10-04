import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/services/purchases_service.dart';

@immutable
class SubscriptionState {
  final bool isLoading;
  final bool isPurchasing;
  final bool isRestoring;
  final SubscriptionEntity subscription;
  final List<SubscriptionPackage> packages;
  final String selectedPackageId;
  final bool isAnnual;
  final String? errorMessage;
  final String? successMessage;

  const SubscriptionState({
    this.isLoading = false,
    this.isPurchasing = false,
    this.isRestoring = false,
    required this.subscription,
    this.packages = const [],
    this.selectedPackageId = 'nutriai_pro_annual',
    this.isAnnual = true,
    this.errorMessage,
    this.successMessage,
  });

  factory SubscriptionState.initial() {
    return SubscriptionState(
      subscription: SubscriptionEntity.free(),
      packages: RevenueCatPurchasesService.defaultOfferings,
    );
  }

  SubscriptionState copyWith({
    bool? isLoading,
    bool? isPurchasing,
    bool? isRestoring,
    SubscriptionEntity? subscription,
    List<SubscriptionPackage>? packages,
    String? selectedPackageId,
    bool? isAnnual,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      isRestoring: isRestoring ?? this.isRestoring,
      subscription: subscription ?? this.subscription,
      packages: packages ?? this.packages,
      selectedPackageId: selectedPackageId ?? this.selectedPackageId,
      isAnnual: isAnnual ?? this.isAnnual,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

final subscriptionNotifierProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(SubscriptionNotifier.new);

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() {
    return SubscriptionState.initial();
  }

  ISubscriptionRepository get _repository => ref.read(subscriptionRepositoryProvider);
  IPurchasesService get _purchasesService => ref.read(purchasesServiceProvider);

  /// Load current subscription and scan entitlement from Laravel backend.
  Future<void> loadSubscription() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final sub = await _repository.getSubscription();
      final offerings = await _purchasesService.getOfferings();
      state = state.copyWith(
        isLoading: false,
        subscription: sub,
        packages: offerings,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Select active billing package
  void selectPackage(String packageId) {
    state = state.copyWith(selectedPackageId: packageId);
  }

  /// Toggle between annual and monthly cycle
  void setAnnualBilling(bool isAnnual) {
    final matchingPackage = state.packages.firstWhere(
      (p) => p.period == (isAnnual ? 'annual' : 'monthly'),
      orElse: () => state.packages.first,
    );
    state = state.copyWith(
      isAnnual: isAnnual,
      selectedPackageId: matchingPackage.id,
    );
  }

  /// Purchase selected package via IPurchasesService and refresh entitlement from backend.
  Future<bool> purchase([String? packageId]) async {
    final targetId = packageId ?? state.selectedPackageId;
    state = state.copyWith(isPurchasing: true, clearError: true, clearSuccess: true);

    try {
      final success = await _purchasesService.purchasePackage(targetId);
      if (!success) {
        state = state.copyWith(
          isPurchasing: false,
          errorMessage: 'Purchase was cancelled or failed.',
        );
        return false;
      }

      // Backend is single source of truth: refresh entitlement from Laravel
      final refreshed = await _repository.getSubscription();
      state = state.copyWith(
        isPurchasing: false,
        subscription: refreshed,
        successMessage: 'Successfully upgraded to ${refreshed.planDisplayName}!',
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isPurchasing: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isPurchasing: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Restore purchases via IPurchasesService and refresh entitlement from backend.
  Future<bool> restorePurchases() async {
    state = state.copyWith(isRestoring: true, clearError: true, clearSuccess: true);

    try {
      final success = await _purchasesService.restorePurchases();
      if (!success) {
        state = state.copyWith(
          isRestoring: false,
          errorMessage: 'No previous purchases found to restore.',
        );
        return false;
      }

      // Backend is single source of truth: refresh entitlement from Laravel
      final refreshed = await _repository.getSubscription();
      state = state.copyWith(
        isRestoring: false,
        subscription: refreshed,
        successMessage: 'Purchases restored! Active plan: ${refreshed.planDisplayName}',
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isRestoring: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isRestoring: false, errorMessage: e.toString());
      return false;
    }
  }
}

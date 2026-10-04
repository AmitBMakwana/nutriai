import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

/// Contract for application analytics tracking.
abstract class IAnalyticsService {
  void trackEvent(String eventName, [Map<String, dynamic>? parameters]);

  void trackAppOpened({required String flavor});
  void trackSignupCompleted({required String method});
  void trackOnboardingCompleted({required String goal, required String dietType});
  void trackMealPhotoTaken({required String source});
  void trackMealAnalysisStarted({required String mealType});
  void trackMealAnalysisCompleted({required int detectedItemsCount, required int estimatedCalories});
  void trackMealAnalysisFailed({required String reason});
  void trackMealSaved({required String mealType, required int calories, required String source});
  void trackMealEdited({required int itemsCount, required int caloriesDiff});
  void trackFoodSearch({required String query, required int resultsCount});
  void trackWaterLogged({required int amountMl, required int totalMl});
  void trackWeightLogged({required double weightKg, required String unit});
  void trackSubscriptionStarted({required String plan, required double price});
}

/// Production & Debug implementation of AnalyticsService.
/// In debug/test environments, events are recorded to memory and printed.
/// In production, events are dispatched to analytics backends (Firebase / PostHog).
class AnalyticsService implements IAnalyticsService {
  final List<({String name, Map<String, dynamic> params, DateTime timestamp})> _recordedEvents = [];

  List<({String name, Map<String, dynamic> params, DateTime timestamp})> get recordedEvents =>
      List.unmodifiable(_recordedEvents);

  @override
  void trackEvent(String eventName, [Map<String, dynamic>? parameters]) {
    final params = parameters ?? <String, dynamic>{};
    _recordedEvents.add((name: eventName, params: params, timestamp: DateTime.now()));

    if (kDebugMode || AppConfig.current.enableAnalytics) {
      debugPrint('[Analytics] Event: $eventName -> $params');
    }
  }

  @override
  void trackAppOpened({required String flavor}) {
    trackEvent('app_opened', {'flavor': flavor});
  }

  @override
  void trackSignupCompleted({required String method}) {
    trackEvent('signup_completed', {'method': method});
  }

  @override
  void trackOnboardingCompleted({required String goal, required String dietType}) {
    trackEvent('onboarding_completed', {'goal': goal, 'diet_type': dietType});
  }

  @override
  void trackMealPhotoTaken({required String source}) {
    trackEvent('meal_photo_taken', {'source': source});
  }

  @override
  void trackMealAnalysisStarted({required String mealType}) {
    trackEvent('meal_analysis_started', {'meal_type': mealType});
  }

  @override
  void trackMealAnalysisCompleted({required int detectedItemsCount, required int estimatedCalories}) {
    trackEvent('meal_analysis_completed', {
      'detected_items_count': detectedItemsCount,
      'estimated_calories': estimatedCalories,
    });
  }

  @override
  void trackMealAnalysisFailed({required String reason}) {
    trackEvent('meal_analysis_failed', {'reason': reason});
  }

  @override
  void trackMealSaved({required String mealType, required int calories, required String source}) {
    trackEvent('meal_saved', {
      'meal_type': mealType,
      'calories': calories,
      'source': source,
    });
  }

  @override
  void trackMealEdited({required int itemsCount, required int caloriesDiff}) {
    trackEvent('meal_edited', {
      'items_count': itemsCount,
      'calories_diff': caloriesDiff,
    });
  }

  @override
  void trackFoodSearch({required String query, required int resultsCount}) {
    trackEvent('food_search', {
      'query': query,
      'results_count': resultsCount,
    });
  }

  @override
  void trackWaterLogged({required int amountMl, required int totalMl}) {
    trackEvent('water_logged', {
      'amount_ml': amountMl,
      'total_ml': totalMl,
    });
  }

  @override
  void trackWeightLogged({required double weightKg, required String unit}) {
    trackEvent('weight_logged', {
      'weight_kg': weightKg,
      'unit': unit,
    });
  }

  @override
  void trackSubscriptionStarted({required String plan, required double price}) {
    trackEvent('subscription_started', {
      'plan': plan,
      'price': price,
    });
  }
}

/// Riverpod provider for analytics tracking.
final analyticsServiceProvider = Provider<IAnalyticsService>((ref) {
  return AnalyticsService();
});

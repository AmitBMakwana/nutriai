import 'package:flutter/foundation.dart';

@immutable
class SubscriptionEntity {
  final String plan;
  final String status;
  final bool isPro;
  final bool isPremium;
  final int quota;
  final int usedScans;
  final int remainingScans;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final List<String> features;

  const SubscriptionEntity({
    required this.plan,
    required this.status,
    required this.isPro,
    this.isPremium = false,
    required this.quota,
    required this.usedScans,
    required this.remainingScans,
    this.startsAt,
    this.endsAt,
    this.features = const [],
  });

  /// Formatted usage string as required: e.g. "3 of 5 scans used"
  String get usageIndicator => '$usedScans of $quota scans used';

  /// Scan usage percentage between 0.0 and 1.0
  double get usagePercentage {
    if (quota <= 0) return 0.0;
    return (usedScans / quota).clamp(0.0, 1.0);
  }

  /// Whether the user has used up all available scans for the current period
  bool get isQuotaExhausted => remainingScans <= 0;

  /// Display name of the plan
  String get planDisplayName {
    switch (plan.toLowerCase()) {
      case 'premium':
        return 'Premium Plan';
      case 'pro':
        return 'Pro Plan';
      case 'free':
      default:
        return 'Free Plan';
    }
  }

  factory SubscriptionEntity.free() {
    return const SubscriptionEntity(
      plan: 'free',
      status: 'none',
      isPro: false,
      isPremium: false,
      quota: 5,
      usedScans: 0,
      remainingScans: 5,
      features: [
        '5 AI meal scans per month',
        'Calorie & macronutrient tracking',
        'Water & body weight tracking',
        '7-day progress history',
      ],
    );
  }

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) {
    return SubscriptionEntity(
      plan: (json['plan'] as String?)?.toLowerCase() ?? 'free',
      status: (json['status'] as String?) ?? 'none',
      isPro: json['is_pro'] as bool? ?? false,
      isPremium: json['is_premium'] as bool? ?? false,
      quota: json['quota'] is int
          ? json['quota'] as int
          : (json['quota'] is Map ? (json['quota']['total'] as int? ?? 5) : 5),
      usedScans: json['used_scans'] as int? ??
          (json['quota'] is Map ? (json['quota']['used'] as int? ?? 0) : 0),
      remainingScans: json['remaining_scans'] as int? ??
          (json['quota'] is Map ? (json['quota']['remaining'] as int? ?? 5) : 5),
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String)
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'] as String)
          : null,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan': plan,
      'status': status,
      'is_pro': isPro,
      'is_premium': isPremium,
      'quota': quota,
      'used_scans': usedScans,
      'remaining_scans': remainingScans,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'features': features,
    };
  }

  SubscriptionEntity copyWith({
    String? plan,
    String? status,
    bool? isPro,
    bool? isPremium,
    int? quota,
    int? usedScans,
    int? remainingScans,
    DateTime? startsAt,
    DateTime? endsAt,
    List<String>? features,
  }) {
    return SubscriptionEntity(
      plan: plan ?? this.plan,
      status: status ?? this.status,
      isPro: isPro ?? this.isPro,
      isPremium: isPremium ?? this.isPremium,
      quota: quota ?? this.quota,
      usedScans: usedScans ?? this.usedScans,
      remainingScans: remainingScans ?? this.remainingScans,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      features: features ?? this.features,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubscriptionEntity &&
        other.plan == plan &&
        other.status == status &&
        other.isPro == isPro &&
        other.isPremium == isPremium &&
        other.quota == quota &&
        other.usedScans == usedScans &&
        other.remainingScans == remainingScans &&
        other.startsAt == startsAt &&
        other.endsAt == endsAt;
  }

  @override
  int get hashCode => Object.hash(
        plan,
        status,
        isPro,
        isPremium,
        quota,
        usedScans,
        remainingScans,
        startsAt,
        endsAt,
      );
}

import 'package:flutter/foundation.dart';

/// Environment flavors supported by NutriAI.
enum AppFlavor {
  dev,
  staging,
  prod,
}

/// Application configuration and environment settings.
class AppConfig {
  static const String appName = 'NutriAI';
  static const String appTagline = 'Snap your meal. Understand your nutrition. Reach your goal.';

  /// Base URL for the NutriAI Laravel API.
  /// On Android emulator, localhost is 10.0.2.2.
  /// On Web/iOS simulator/Desktop, localhost is 127.0.0.1 or localhost.
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api/v1';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api/v1';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return 'http://127.0.0.1:8000/api/v1';
    }
  }

  /// Global active application configuration instance.
  static AppConfig current = AppConfig.dev();

  final AppFlavor flavor;
  final String baseUrl;
  final String sentryDsn;
  final bool enableAnalytics;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  const AppConfig({
    this.flavor = AppFlavor.dev,
    required this.baseUrl,
    this.sentryDsn = '',
    this.enableAnalytics = false,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
  });

  bool get isDev => flavor == AppFlavor.dev;
  bool get isStaging => flavor == AppFlavor.staging;
  bool get isProd => flavor == AppFlavor.prod;

  factory AppConfig.dev() => AppConfig(
        flavor: AppFlavor.dev,
        baseUrl: defaultBaseUrl,
        sentryDsn: '',
        enableAnalytics: false,
      );

  factory AppConfig.staging() => const AppConfig(
        flavor: AppFlavor.staging,
        baseUrl: 'https://staging-api.nutriai.app/api/v1',
        sentryDsn: 'https://staging@sentry.io/nutriai-staging',
        enableAnalytics: true,
      );

  factory AppConfig.prod() => const AppConfig(
        flavor: AppFlavor.prod,
        baseUrl: 'https://api.nutriai.app/api/v1',
        sentryDsn: 'https://prod@sentry.io/nutriai-prod',
        enableAnalytics: true,
      );
}

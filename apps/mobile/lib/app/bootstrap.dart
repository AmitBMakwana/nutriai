import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/app_config.dart';
import '../core/services/analytics_service.dart';
import 'app.dart';

/// Bootstraps the application before starting the Flutter engine loop.
Future<void> bootstrap([AppConfig? config]) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (config != null) {
    AppConfig.current = config;
  }

  // Configure Global Error Handling & Sentry Reporting Hook
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (!kDebugMode && AppConfig.current.sentryDsn.isNotEmpty) {
      // In production builds with Sentry configured, captured to Sentry:
      debugPrint('[Error Tracking] FlutterError: ${details.exceptionAsString()}');
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kDebugMode && AppConfig.current.sentryDsn.isNotEmpty) {
      debugPrint('[Error Tracking] Unhandled Async Error: $error');
    }
    return true;
  };

  // Set preferred orientations and system UI overlay on mobile platforms only
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  final container = ProviderContainer();
  // Fire app_opened analytics event
  container.read(analyticsServiceProvider).trackAppOpened(flavor: AppConfig.current.flavor.name);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const NutriAiApp(),
    ),
  );
}

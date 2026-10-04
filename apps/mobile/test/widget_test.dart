import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/app/app.dart';
import 'package:nutriai/core/theme/theme.dart';
import 'package:nutriai/core/widgets/widgets.dart';
import 'package:nutriai/features/auth/domain/entities/user_entity.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_provider.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_state.dart';
import 'package:nutriai/features/dashboard/presentation/screens/home_screen.dart';

void main() {
  group('NutriAI Theme Tests', () {
    test('AppTheme light and dark palettes are configured correctly', () {
      final lightTheme = AppTheme.lightTheme;
      final darkTheme = AppTheme.darkTheme;

      expect(lightTheme.brightness, Brightness.light);
      expect(lightTheme.colorScheme.primary, AppColors.primary);
      expect(lightTheme.scaffoldBackgroundColor, AppColors.backgroundLight);
      expect(lightTheme.useMaterial3, isTrue);

      expect(darkTheme.brightness, Brightness.dark);
      expect(darkTheme.colorScheme.primary, AppColors.primary);
      expect(darkTheme.scaffoldBackgroundColor, AppColors.backgroundDark);
      expect(darkTheme.useMaterial3, isTrue);
    });

    test('ThemeModeNotifier toggles and updates correctly within container', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeModeProvider), ThemeMode.system);

      final notifier = container.read(themeModeProvider.notifier);
      notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeModeProvider), ThemeMode.light);

      notifier.toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.dark);

      notifier.toggleTheme();
      expect(container.read(themeModeProvider), ThemeMode.light);
    });
  });

  group('Core Widgets Smoke Tests', () {
    testWidgets('AppButton renders text and triggers callback', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.primary(
              text: 'Click Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.text('Click Me'));
      expect(pressed, isTrue);
    });

    testWidgets('ErrorView renders error message and retry button triggers callback', (tester) async {
      bool retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              title: 'Server Error',
              message: 'Failed to connect',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Server Error'), findsOneWidget);
      expect(find.text('Failed to connect'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      expect(retried, isTrue);
    });

    testWidgets('EmptyView renders title and description', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyView(
              title: 'No meals',
              message: 'Start logging today',
            ),
          ),
        ),
      );

      expect(find.text('No meals'), findsOneWidget);
      expect(find.text('Start logging today'), findsOneWidget);
    });
  });

  group('Router & Auth Navigation Tests', () {
    testWidgets('App launches to SplashScreen and redirects to WelcomeScreen when unauthenticated', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _MockUnauthenticatedAuthNotifier()),
          ],
          child: const NutriAiApp(),
        ),
      );

      // Pump routing cycle
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Unauthenticated state routes to Welcome screen
      expect(find.text('Track meals with a photo'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('I already have an account'), findsOneWidget);
    });

    testWidgets('App redirects directly to HomeScreen when authenticated', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _MockAuthenticatedAuthNotifier()),
          ],
          child: const NutriAiApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Should redirect to HomeScreen in the ShellRoute
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Meals'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Coach'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Navigation from WelcomeScreen to LoginScreen works', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _MockUnauthenticatedAuthNotifier()),
          ],
          child: const NutriAiApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap "I already have an account"
      final loginButton = find.text('I already have an account');
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify LoginScreen is displayed
      expect(find.text('Welcome back 👋'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('App redirects authenticated user with incomplete onboarding to OnboardingFlowScreen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _MockIncompleteOnboardingAuthNotifier()),
          ],
          child: const NutriAiApp(),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Should redirect to OnboardingFlowScreen (step 1 Goal)
      expect(find.text("What's your goal?"), findsOneWidget);
      expect(find.text('Lose Weight'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}

/// Mock AuthNotifier pre-set to unauthenticated state.
class _MockUnauthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => const AuthState.unauthenticated();
}

/// Mock AuthNotifier pre-set to authenticated state with completed onboarding.
class _MockAuthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.authenticated(
      token: 'mock-test-token',
      user: UserEntity(
        id: 1,
        name: 'Test User',
        email: 'test@nutriai.app',
        isOnboardingCompleted: true,
      ),
    );
  }
}

/// Mock AuthNotifier pre-set to authenticated state with incomplete onboarding.
class _MockIncompleteOnboardingAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.authenticated(
      token: 'mock-test-token',
      user: UserEntity(
        id: 1,
        name: 'Test User',
        email: 'test@nutriai.app',
        isOnboardingCompleted: false,
      ),
    );
  }
}

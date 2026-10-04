import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/core/theme/theme.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_provider.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_state.dart';
import 'package:nutriai/features/auth/presentation/screens/login_screen.dart';

class _FakeAuthNotifier extends AuthNotifier {
  final AuthState initialState;
  bool loginCalled = false;
  String? submittedEmail;
  String? submittedPassword;

  _FakeAuthNotifier([this.initialState = const AuthState.unauthenticated()]);

  @override
  AuthState build() => initialState;

  @override
  Future<bool> login({required String email, required String password}) async {
    loginCalled = true;
    submittedEmail = email;
    submittedPassword = password;
    return true;
  }
}

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('renders all login fields and labels', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _FakeAuthNotifier()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        ),
      );

      expect(find.text('Welcome back 👋'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('client-side validation displays error on empty submit', (tester) async {
      final fakeNotifier = _FakeAuthNotifier();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => fakeNotifier),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        ),
      );

      // Tap Log In button without filling fields
      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(fakeNotifier.loginCalled, isFalse);
    });

    testWidgets('client-side validation requires valid email format and minimum password length', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _FakeAuthNotifier()),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        ),
      );

      // Enter invalid email format and short password
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, '123');

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Password must be at least 8 characters long'), findsOneWidget);
    });

    testWidgets('displays server validation field error under email input and error banner', (tester) async {
      const errorState = AuthState.error(
        message: 'The given data was invalid.',
        fieldErrors: {
          'email': ['These credentials do not match our records.'],
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => _FakeAuthNotifier(errorState)),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Top error banner message
      expect(find.text('The given data was invalid.'), findsOneWidget);

      // Field error message under email field
      expect(find.text('These credentials do not match our records.'), findsOneWidget);
    });

    testWidgets('valid form submission triggers login on notifier', (tester) async {
      final fakeNotifier = _FakeAuthNotifier();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => fakeNotifier),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const LoginScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'user@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(find.text('Log In'));
      await tester.pumpAndSettle();

      expect(fakeNotifier.loginCalled, isTrue);
      expect(fakeNotifier.submittedEmail, 'user@example.com');
      expect(fakeNotifier.submittedPassword, 'password123');
    });
  });
}

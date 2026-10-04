import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/providers/auth_state.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_flow_screen.dart';
import '../features/coach/presentation/screens/coach_screen.dart';
import '../features/dashboard/presentation/screens/home_screen.dart';
import '../features/meals/presentation/screens/add_meal_screen.dart';
import '../features/meals/presentation/screens/camera_capture_screen.dart';
import '../features/meals/presentation/screens/food_search_screen.dart';
import '../features/meals/presentation/screens/meal_builder_screen.dart';
import '../features/meals/presentation/screens/meals_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/progress/presentation/screens/progress_screen.dart';
import '../features/shell/presentation/main_shell_screen.dart';
import '../features/subscription/presentation/screens/paywall_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

/// Provider for [GoRouter] with authentication redirect logic and ShellRoute.
final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.splashPath,
    refreshListenable: routerNotifier,
    redirect: routerNotifier.redirect,
    routes: [
      // Splash
      GoRoute(
        path: AppConstants.splashPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppConstants.welcomePath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppConstants.loginPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.forgotPasswordPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppConstants.resetPasswordPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return ResetPasswordScreen(initialEmail: email);
        },
      ),
      GoRoute(
        path: AppConstants.onboardingPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingFlowScreen(),
      ),
      GoRoute(
        path: AppConstants.addMealPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddMealScreen(),
      ),
      GoRoute(
        path: AppConstants.cameraCapturePath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final mealType = state.uri.queryParameters['mealType'] ?? 'lunch';
          return CameraCaptureScreen(initialMealType: mealType);
        },
      ),
      GoRoute(
        path: AppConstants.foodSearchPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FoodSearchScreen(),
      ),
      GoRoute(
        path: AppConstants.mealBuilderPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final mealType = state.uri.queryParameters['mealType'] ?? 'lunch';
          return MealBuilderScreen(initialMealType: mealType);
        },
      ),
      GoRoute(
        path: AppConstants.paywallPath,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaywallScreen(),
      ),

      // Main Shell Route with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.homePath,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 1: Meals
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.mealsPath,
                builder: (context, state) => const MealsScreen(),
              ),
            ],
          ),
          // Tab 2: Progress
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.progressPath,
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          // Tab 3: Coach (Coming soon)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.coachPath,
                builder: (context, state) => const CoachScreen(),
              ),
            ],
          ),
          // Tab 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppConstants.profilePath,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Listenable that notifies GoRouter on auth state changes and calculates redirects.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authNotifierProvider,
      (_, _) => notifyListeners(),
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authNotifierProvider);
    final location = state.matchedLocation;

    final isSplash = location == AppConstants.splashPath;
    final isAuthRoute = location == AppConstants.welcomePath ||
        location == AppConstants.loginPath ||
        location == AppConstants.registerPath ||
        location == AppConstants.forgotPasswordPath ||
        location == AppConstants.resetPasswordPath;
    final isOnboardingRoute = location == AppConstants.onboardingPath;

    // When authenticated
    if (authState.isAuthenticated) {
      final user = authState.user;
      final onboardingDone = user?.isOnboardingCompleted ?? false;

      // If user has not completed onboarding, route them to onboarding
      if (!onboardingDone) {
        return isOnboardingRoute ? null : AppConstants.onboardingPath;
      }

      // If onboarding is completed, redirect away from splash, auth, and onboarding to home
      if (isSplash || isAuthRoute || isOnboardingRoute) {
        return AppConstants.homePath;
      }
      return null;
    }

    // While in initial state, keep on splash screen
    if (authState.isInitial) {
      return isSplash ? null : AppConstants.splashPath;
    }

    // When unauthenticated, redirect to welcome unless on an allowed auth route
    if (isSplash) return AppConstants.welcomePath;
    return isAuthRoute ? null : AppConstants.welcomePath;
  }
}

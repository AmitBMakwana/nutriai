/// Shared application constants.
abstract class AppConstants {
  // Storage Keys
  static const String tokenKey = 'nutriai_auth_token';
  static const String refreshTokenKey = 'nutriai_refresh_token';
  static const String userIdKey = 'nutriai_user_id';
  static const String userNameKey = 'nutriai_user_name';
  static const String userEmailKey = 'nutriai_user_email';
  static const String themeModeKey = 'nutriai_theme_mode';

  // Route Paths
  static const String splashPath = '/splash';
  static const String welcomePath = '/welcome';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String forgotPasswordPath = '/forgot-password';
  static const String resetPasswordPath = '/reset-password';
  static const String onboardingPath = '/onboarding';

  // Shell Tabs
  static const String homePath = '/home';
  static const String mealsPath = '/meals';
  static const String progressPath = '/progress';
  static const String coachPath = '/coach';
  static const String profilePath = '/profile';

  // Meal & Camera Flows
  static const String addMealPath = '/add-meal';
  static const String cameraCapturePath = '/camera-capture';
  static const String foodSearchPath = '/food-search';
  static const String mealBuilderPath = '/meal-builder';
  static const String paywallPath = '/paywall';
}

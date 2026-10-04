/// API endpoint constants mapping to the NutriAI Laravel backend.
abstract class ApiEndpoints {
  // Auth
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String me = '/me';
  static const String forgotPassword = '/password/forgot';
  static const String resetPassword = '/password/reset';

  // System
  static const String health = '/health';

  // Feature endpoints
  static const String onboarding = '/onboarding';
  static const String profile = '/profile';
  static const String avatar = '/profile/avatar';
  static const String changePassword = '/password/change';
  static const String account = '/account';
  static const String goals = '/goals';
  static const String calculateGoals = '/goals/calculate';
  static const String meals = '/meals';
  static const String foods = '/foods';
  static const String analyzeMeal = '/meals/analyze';
  static const String aiAnalysis = '/ai-analysis';
  static const String water = '/water';
  static const String weight = '/weight';
  static const String waterLogs = '/water';
  static const String weightLogs = '/weight';
  static const String dailySummary = '/summary/daily';
  static const String dashboard = '/dashboard';
  static const String progress = '/progress';
  static const String progressWeekly = '/progress/weekly';
  static const String progressMonthly = '/progress/monthly';
  static const String subscription = '/subscription';
}

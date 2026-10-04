import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/notification_service.dart';
import '../providers/profile_notifier.dart';

class SettingsState {
  final String unitSystem; // 'metric' or 'imperial'
  final bool mealRemindersEnabled;
  final bool waterRemindersEnabled;

  const SettingsState({
    this.unitSystem = 'metric',
    this.mealRemindersEnabled = true,
    this.waterRemindersEnabled = true,
  });

  bool get isMetric => unitSystem == 'metric';
  bool get isImperial => unitSystem == 'imperial';

  SettingsState copyWith({
    String? unitSystem,
    bool? mealRemindersEnabled,
    bool? waterRemindersEnabled,
  }) {
    return SettingsState(
      unitSystem: unitSystem ?? this.unitSystem,
      mealRemindersEnabled: mealRemindersEnabled ?? this.mealRemindersEnabled,
      waterRemindersEnabled: waterRemindersEnabled ?? this.waterRemindersEnabled,
    );
  }
}

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<SettingsState> {
  static const _keyUnitSystem = 'settings_unit_system';
  static const _keyMealReminders = 'settings_meal_reminders';
  static const _keyWaterReminders = 'settings_water_reminders';

  @override
  SettingsState build() {
    _loadPreferences();
    return const SettingsState();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final unitSystem = prefs.getString(_keyUnitSystem) ?? 'metric';
    final mealReminders = prefs.getBool(_keyMealReminders) ?? true;
    final waterReminders = prefs.getBool(_keyWaterReminders) ?? true;

    state = SettingsState(
      unitSystem: unitSystem,
      mealRemindersEnabled: mealReminders,
      waterRemindersEnabled: waterReminders,
    );

    final notificationService = ref.read(notificationServiceProvider);
    notificationService.scheduleMealReminders(enabled: mealReminders);
    notificationService.scheduleWaterReminders(enabled: waterReminders);
  }

  Future<void> setUnitSystem(String unitSystem) async {
    state = state.copyWith(unitSystem: unitSystem);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnitSystem, unitSystem);

    // Sync with backend profile if available
    try {
      ref.read(profileNotifierProvider.notifier).updateProfile(
        {'unit_system': unitSystem},
        recalculateGoals: false,
      );
    } catch (_) {}
  }

  Future<void> setMealReminders(bool enabled) async {
    state = state.copyWith(mealRemindersEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMealReminders, enabled);

    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.scheduleMealReminders(enabled: enabled);
  }

  Future<void> setWaterReminders(bool enabled) async {
    state = state.copyWith(waterRemindersEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWaterReminders, enabled);

    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.scheduleWaterReminders(enabled: enabled);
  }
}

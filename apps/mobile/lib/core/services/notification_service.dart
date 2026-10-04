import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.initialize();
  return service;
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        initSettings,
        onSelectNotification: (String? payload) async {
          debugPrint('Notification clicked with payload: $payload');
        },
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint('Notification initialization bypassed or error: $e');
    }
  }

  Future<void> scheduleMealReminders({required bool enabled}) async {
    if (!enabled) {
      await cancelNotification(101);
      await cancelNotification(102);
      await cancelNotification(103);
      return;
    }

    try {
      // Breakfast reminder
      await _showPeriodicReminder(
        id: 101,
        title: 'Time for Breakfast! 🍳',
        body: 'Log your morning fuel to stay on track with your goals.',
      );

      // Lunch reminder
      await _showPeriodicReminder(
        id: 102,
        title: 'Lunchtime Nutrition Check 🥗',
        body: 'Snap a photo of your lunch or log your items.',
      );

      // Dinner reminder
      await _showPeriodicReminder(
        id: 103,
        title: 'Evening Meal Reflection 🍲',
        body: 'Wrap up your day by logging dinner and meeting your macros.',
      );
    } catch (e) {
      debugPrint('Error scheduling meal reminders: $e');
    }
  }

  Future<void> scheduleWaterReminders({required bool enabled}) async {
    if (!enabled) {
      await cancelNotification(201);
      return;
    }

    try {
      await _showPeriodicReminder(
        id: 201,
        title: 'Stay Hydrated! 💧',
        body: 'Drink a glass of water to keep your metabolism active.',
      );
    } catch (e) {
      debugPrint('Error scheduling water reminders: $e');
    }
  }

  Future<void> _showPeriodicReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'nutriai_reminders',
      'Daily Health & Nutrition Reminders',
      'Reminders to log meals, track water, and stay on top of daily targets',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
    } catch (e) {
      debugPrint('Error cancelling notification $id: $e');
    }
  }

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }
}

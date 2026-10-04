import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../nutrition/presentation/providers/nutrition_goal_provider.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';
import '../providers/profile_notifier.dart';
import '../providers/settings_provider.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/delete_account_dialog.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/nutrition_goals_editor_sheet.dart';
import '../widgets/privacy_note_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(nutritionGoalNotifierProvider.notifier).loadActiveGoal();
      ref.read(subscriptionNotifierProvider.notifier).loadSubscription();
    });
  }

  Future<void> _pickAndUploadAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: AppSpacing.p20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Profile Photo',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              AppSpacing.gapH16,
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                title: const Text('Take a Photo'),
                onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.primary),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        final success = await ref
            .read(profileNotifierProvider.notifier)
            .uploadAvatar(File(picked.path));

        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar updated successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showPolicyDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.r20),
        title: Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Text(content, style: AppTypography.bodySmall.copyWith(height: 1.5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentThemeMode = ref.watch(themeModeProvider);
    final profileState = ref.watch(profileNotifierProvider);
    final settingsState = ref.watch(settingsNotifierProvider);
    final goalState = ref.watch(nutritionGoalNotifierProvider);

    final user = profileState.user ?? ref.watch(authNotifierProvider).user;
    final profile = profileState.profile;
    final userName = user?.name ?? 'NutriAI User';
    final userEmail = user?.email ?? 'user@nutriai.app';
    final isImperial = settingsState.isImperial;
    final subState = ref.watch(subscriptionNotifierProvider);
    final currentSub = subState.subscription;

    // Unit conversions for display
    final displayWeight = profile != null
        ? (isImperial ? (profile.weightKg * 2.20462).roundToDouble() : profile.weightKg)
        : null;
    final displayTargetWeight = profile != null
        ? (isImperial ? (profile.targetWeightKg * 2.20462).roundToDouble() : profile.targetWeightKg)
        : null;

    final weightUnit = isImperial ? 'lbs' : 'kg';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileNotifierProvider.notifier).loadProfile();
          await ref.read(nutritionGoalNotifierProvider.notifier).loadActiveGoal();
          await ref.read(subscriptionNotifierProvider.notifier).loadSubscription();
        },
        child: ListView(
          padding: AppSpacing.px20,
          children: [
            AppSpacing.gapH12,

            // Profile Card (Avatar, Name, Email, Edit Profile button)
            Container(
              padding: AppSpacing.p20,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.r24,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar with edit badge
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: AppColors.primaryContainer,
                            backgroundImage: user?.avatar != null && user!.avatar!.isNotEmpty
                                ? NetworkImage(user.avatar!)
                                : null,
                            child: user?.avatar == null || user!.avatar!.isEmpty
                                ? Text(
                                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                    style: AppTypography.headlineMedium.copyWith(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickAndUploadAvatar,
                              borderRadius: AppRadius.r12,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark ? AppColors.surfaceDark : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: profileState.isUploadingAvatar
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapW16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            AppSpacing.gapH4,
                            Text(
                              userEmail,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            AppSpacing.gapH8,
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (currentSub.isPro ? const Color(0xFFF59E0B) : AppColors.primary).withValues(alpha: 0.12),
                                borderRadius: AppRadius.r8,
                              ),
                              child: Text(
                                currentSub.planDisplayName,
                                style: AppTypography.labelSmall.copyWith(
                                  color: currentSub.isPro ? const Color(0xFFD97706) : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapH16,
                  AppButton.outline(
                    text: 'Edit Profile & Stats',
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditProfileDialog(
                          profile: profile,
                          userName: userName,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,

            // Subscription & AI Scans Card ("3 of 5 scans used")
            Container(
              padding: AppSpacing.p16,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.r20,
                border: Border.all(
                  color: currentSub.isPro
                      ? AppColors.primary.withValues(alpha: 0.6)
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            currentSub.isPro ? Icons.workspace_premium : Icons.camera_alt_outlined,
                            color: currentSub.isPro ? const Color(0xFFF59E0B) : AppColors.primary,
                            size: 20,
                          ),
                          AppSpacing.gapW8,
                          Text(
                            currentSub.planDisplayName,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        currentSub.usageIndicator,
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: currentSub.isQuotaExhausted ? AppColors.error : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapH12,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: currentSub.usagePercentage,
                      minHeight: 6,
                      backgroundColor: isDark ? AppColors.surfaceDarkSubtle : Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        currentSub.isQuotaExhausted ? AppColors.error : AppColors.primary,
                      ),
                    ),
                  ),
                  AppSpacing.gapH12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          currentSub.isQuotaExhausted
                              ? 'Monthly scan quota reached'
                              : '${currentSub.remainingScans} scans remaining this month',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => context.push(AppConstants.paywallPath),
                        icon: Icon(
                          currentSub.isPro ? Icons.tune_rounded : Icons.bolt_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          currentSub.isPro ? 'Manage' : 'Upgrade',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapH20,

            // Health & Body Stats Grid
            Text(
              'Your Metrics',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            AppSpacing.gapH12,
            Container(
              padding: AppSpacing.p16,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.r20,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _StatTile(
                        label: 'Goal',
                        value: (profile?.goal ?? 'maintain').replaceAll('_', ' ').toUpperCase(),
                        icon: Icons.flag_rounded,
                        color: AppColors.primary,
                      ),
                      _StatTile(
                        label: 'Weight',
                        value: displayWeight != null ? '$displayWeight $weightUnit' : '--',
                        icon: Icons.scale_rounded,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      _StatTile(
                        label: 'Target',
                        value: displayTargetWeight != null ? '$displayTargetWeight $weightUnit' : '--',
                        icon: Icons.track_changes_rounded,
                        color: Colors.purpleAccent,
                      ),
                      _StatTile(
                        label: 'Height',
                        value: profile != null ? '${profile.heightCm} cm' : '--',
                        icon: Icons.height_rounded,
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      _StatTile(
                        label: 'Activity',
                        value: (profile?.activityLevel ?? 'moderate').replaceAll('_', ' '),
                        icon: Icons.directions_run_rounded,
                        color: Colors.teal,
                      ),
                      _StatTile(
                        label: 'Diet',
                        value: (profile?.dietType ?? 'standard').toUpperCase(),
                        icon: Icons.restaurant_menu_rounded,
                        color: Colors.amber[800] ?? Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapH20,

            // Active Nutrition Targets Card
            Text(
              'Nutrition Targets',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            AppSpacing.gapH12,
            Container(
              padding: AppSpacing.p16,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.r20,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Calorie Target',
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          AppSpacing.gapH4,
                          Text(
                            goalState.goal != null ? '${goalState.goal!.dailyCalories} kcal' : '2,000 kcal',
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.tune_rounded, size: 18),
                        label: const Text('Customize'),
                        onPressed: () {
                          if (goalState.goal != null) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                              ),
                              builder: (_) => NutritionGoalsEditorSheet(
                                currentGoal: goalState.goal!,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  AppSpacing.gapH12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MacroPill(
                        label: 'Protein',
                        grams: goalState.goal?.proteinGrams ?? 120,
                        color: AppColors.primary,
                      ),
                      _MacroPill(
                        label: 'Carbs',
                        grams: goalState.goal?.carbsGrams ?? 220,
                        color: Colors.blueAccent,
                      ),
                      _MacroPill(
                        label: 'Fat',
                        grams: goalState.goal?.fatGrams ?? 65,
                        color: Colors.orangeAccent,
                      ),
                      _MacroPill(
                        label: 'Water',
                        grams: (goalState.goal?.waterMl ?? 2500) ~/ 1000,
                        unit: 'L',
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.gapH20,

            // Preferences Section
            Text(
              'App Preferences',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            AppSpacing.gapH12,
            Container(
              padding: AppSpacing.p16,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.r20,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  // Units Selector
                  Row(
                    children: [
                      const Icon(Icons.straighten_rounded, color: AppColors.primary, size: 22),
                      AppSpacing.gapW12,
                      Expanded(
                        child: Text(
                          'Units of Measurement',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'metric', label: Text('Metric')),
                          ButtonSegment(value: 'imperial', label: Text('Imperial')),
                        ],
                        selected: {settingsState.unitSystem},
                        onSelectionChanged: (set) {
                          ref.read(settingsNotifierProvider.notifier).setUnitSystem(set.first);
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Theme Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          AppSpacing.gapW12,
                          Text(
                            'Appearance',
                            style: AppTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapH12,
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('System'),
                            icon: Icon(Icons.brightness_auto_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode_rounded, size: 16),
                          ),
                        ],
                        selected: {currentThemeMode},
                        onSelectionChanged: (newSelection) {
                          ref.read(themeModeProvider.notifier).setThemeMode(newSelection.first);
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Local Notifications
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                    title: Text(
                      'Meal Reminders',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    subtitle: Text(
                      'Daily reminders for Breakfast, Lunch & Dinner',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    value: settingsState.mealRemindersEnabled,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      ref.read(settingsNotifierProvider.notifier).setMealReminders(val);
                    },
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.water_drop_outlined, color: Colors.blueAccent),
                    title: Text(
                      'Hydration Reminders',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    subtitle: Text(
                      'Drink water reminders throughout the day',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    value: settingsState.waterRemindersEnabled,
                    activeTrackColor: Colors.blueAccent,
                    onChanged: (val) {
                      ref.read(settingsNotifierProvider.notifier).setWaterReminders(val);
                    },
                  ),
                ],
              ),
            ),
            AppSpacing.gapH20,

            // Privacy Note Card
            const PrivacyNoteCard(),
            AppSpacing.gapH20,

            // Security & Links
            Text(
              'Security & Policies',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            AppSpacing.gapH12,
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: AppRadius.r20,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ChangePasswordDialog(),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      _showPolicyDialog(
                        'Privacy Policy',
                        'NutriAI takes your health data seriously. All meal images, body weight logs, and personal health metrics are strictly encrypted and used solely for providing accurate nutritional calculations. We do not sell or monetize personal health information.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      _showPolicyDialog(
                        'Terms of Service',
                        'NutriAI is designed as an educational and wellness tracking tool. It is not intended to replace professional medical advice, diagnosis, or treatment. Always consult with a licensed physician or registered dietitian before starting any restrictive diet.',
                      );
                    },
                  ),
                ],
              ),
            ),
            AppSpacing.gapH24,

            // Actions & Danger Zone
            AppButton.outline(
              text: 'Log Out',
              icon: const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
              textColor: AppColors.error,
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).logout();
              },
            ),
            AppSpacing.gapH12,
            Center(
              child: TextButton.icon(
                icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 18),
                label: Text(
                  'Delete Account Forever',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const DeleteAccountDialog(),
                  );
                },
              ),
            ),
            AppSpacing.gapH32,
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.r12,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final int grams;
  final String unit;
  final Color color;

  const _MacroPill({
    required this.label,
    required this.grams,
    this.unit = 'g',
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          '$grams$unit',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        AppSpacing.gapH4,
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

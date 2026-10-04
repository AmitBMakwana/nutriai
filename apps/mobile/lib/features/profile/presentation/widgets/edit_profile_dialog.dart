import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../onboarding/domain/entities/user_profile_entity.dart';
import '../providers/profile_notifier.dart';
import '../providers/settings_provider.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  final UserProfileEntity? profile;
  final String userName;

  const EditProfileDialog({
    super.key,
    required this.profile,
    required this.userName,
  });

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetWeightController;
  late final TextEditingController _heightController;

  late String _selectedGoal;
  late String _selectedActivity;
  late String _selectedDiet;
  bool _recalculateGoals = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: widget.userName);

    final isImperial = ref.read(settingsNotifierProvider).isImperial;
    final displayWeight = p != null
        ? (isImperial ? (p.weightKg * 2.20462).roundToDouble() : p.weightKg)
        : 70.0;
    final displayTargetWeight = p != null
        ? (isImperial ? (p.targetWeightKg * 2.20462).roundToDouble() : p.targetWeightKg)
        : 65.0;
    final displayHeight = p?.heightCm ?? 175;

    _weightController = TextEditingController(text: displayWeight.toString());
    _targetWeightController = TextEditingController(text: displayTargetWeight.toString());
    _heightController = TextEditingController(text: displayHeight.toString());

    _selectedGoal = p?.goal ?? 'maintain';
    _selectedActivity = p?.activityLevel ?? 'moderately_active';
    _selectedDiet = p?.dietType ?? 'everything';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final isImperial = ref.read(settingsNotifierProvider).isImperial;
    final rawWeight = double.tryParse(_weightController.text) ?? 70.0;
    final rawTargetWeight = double.tryParse(_targetWeightController.text) ?? 70.0;
    final rawHeight = int.tryParse(_heightController.text) ?? 175;

    // Convert back to metric for DB storage (constraint: store metric in DB)
    final weightKg = isImperial ? (rawWeight / 2.20462) : rawWeight;
    final targetWeightKg = isImperial ? (rawTargetWeight / 2.20462) : rawTargetWeight;

    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'goal': _selectedGoal,
      'activity_level': _selectedActivity,
      'diet_type': _selectedDiet,
      'weight_kg': double.parse(weightKg.toStringAsFixed(1)),
      'target_weight_kg': double.parse(targetWeightKg.toStringAsFixed(1)),
      'height_cm': rawHeight,
    };

    final success = await ref.read(profileNotifierProvider.notifier).updateProfile(
          payload,
          recalculateGoals: _recalculateGoals,
        );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _recalculateGoals
                  ? 'Profile updated & nutrition targets recalculated!'
                  : 'Profile updated successfully!',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      } else {
        final err = ref.read(profileNotifierProvider).errorMessage ?? 'Failed to update profile';
        setState(() => _error = err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isImperial = ref.watch(settingsNotifierProvider).isImperial;
    final state = ref.watch(profileNotifierProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.r24),
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 680),
        child: Padding(
          padding: AppSpacing.p20,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit Profile',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                AppSpacing.gapH12,
                if (_error != null) ...[
                  Container(
                    padding: AppSpacing.p12,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: AppRadius.r12,
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _error!,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                    ),
                  ),
                  AppSpacing.gapH12,
                ],
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Name
                      AppTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Name cannot be empty';
                          return null;
                        },
                      ),
                      AppSpacing.gapH12,

                      // Goal dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGoal,
                        decoration: InputDecoration(
                          labelText: 'Health Goal',
                          filled: true,
                          fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          border: OutlineInputBorder(borderRadius: AppRadius.r16),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'lose_weight', child: Text('Lose Weight')),
                          DropdownMenuItem(value: 'maintain', child: Text('Maintain Weight')),
                          DropdownMenuItem(value: 'gain_weight', child: Text('Gain Weight')),
                          DropdownMenuItem(value: 'build_muscle', child: Text('Build Muscle')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedGoal = val);
                        },
                      ),
                      AppSpacing.gapH12,

                      // Measurements row
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _weightController,
                              label: 'Weight (${isImperial ? 'lbs' : 'kg'})',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          AppSpacing.gapW8,
                          Expanded(
                            child: AppTextField(
                              controller: _targetWeightController,
                              label: 'Target (${isImperial ? 'lbs' : 'kg'})',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          AppSpacing.gapW8,
                          Expanded(
                            child: AppTextField(
                              controller: _heightController,
                              label: 'Height (cm)',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.gapH12,

                      // Activity level
                      DropdownButtonFormField<String>(
                        initialValue: _selectedActivity,
                        decoration: InputDecoration(
                          labelText: 'Activity Level',
                          filled: true,
                          fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          border: OutlineInputBorder(borderRadius: AppRadius.r16),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'sedentary', child: Text('Sedentary (Desk Job)')),
                          DropdownMenuItem(value: 'lightly_active', child: Text('Lightly Active (1-3 days/wk)')),
                          DropdownMenuItem(value: 'moderately_active', child: Text('Moderately Active (3-5 days/wk)')),
                          DropdownMenuItem(value: 'very_active', child: Text('Very Active (6-7 days/wk)')),
                          DropdownMenuItem(value: 'extra_active', child: Text('Extra Active (Hard training)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedActivity = val);
                        },
                      ),
                      AppSpacing.gapH12,

                      // Diet type
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDiet,
                        decoration: InputDecoration(
                          labelText: 'Diet Type',
                          filled: true,
                          fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          border: OutlineInputBorder(borderRadius: AppRadius.r16),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'everything', child: Text('Standard / Everything')),
                          DropdownMenuItem(value: 'vegetarian', child: Text('Vegetarian')),
                          DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
                          DropdownMenuItem(value: 'pescatarian', child: Text('Pescatarian')),
                          DropdownMenuItem(value: 'keto', child: Text('Ketogenic')),
                          DropdownMenuItem(value: 'paleo', child: Text('Paleo')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedDiet = val);
                        },
                      ),
                      AppSpacing.gapH16,

                      // Recalculate goals confirmation switch
                      Container(
                        padding: AppSpacing.p12,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: AppRadius.r16,
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recalculate Nutrition Goals',
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  AppSpacing.gapH4,
                                  Text(
                                    'Update daily calories and macros automatically for your new stats',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _recalculateGoals,
                              activeTrackColor: AppColors.primary,
                              onChanged: (val) => setState(() => _recalculateGoals = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapH16,
                AppButton.primary(
                  text: 'Save Changes',
                  isLoading: state.isUpdating,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

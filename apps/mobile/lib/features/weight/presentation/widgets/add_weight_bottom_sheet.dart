import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class AddWeightBottomSheet extends StatefulWidget {
  final String initialUnitSystem;
  final double? currentWeightKg;
  final Future<bool> Function({
    required double value,
    required String unitSystem,
    required DateTime date,
  }) onSave;

  const AddWeightBottomSheet({
    super.key,
    required this.initialUnitSystem,
    this.currentWeightKg,
    required this.onSave,
  });

  @override
  State<AddWeightBottomSheet> createState() => _AddWeightBottomSheetState();
}

class _AddWeightBottomSheetState extends State<AddWeightBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weightController;
  late String _selectedUnit;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.initialUnitSystem.toLowerCase() == 'imperial' ? 'lb' : 'kg';

    if (widget.currentWeightKg != null) {
      final initialVal = _selectedUnit == 'lb'
          ? (widget.currentWeightKg! * 2.20462).toStringAsFixed(1)
          : widget.currentWeightKg!.toStringAsFixed(1);
      _weightController = TextEditingController(text: initialVal);
    } else {
      _weightController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final val = double.tryParse(_weightController.text.trim());
    if (val == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await widget.onSave(
      value: val,
      unitSystem: _selectedUnit == 'lb' ? 'imperial' : 'metric',
      date: _selectedDate,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to save weight. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Log Weight',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Date picker row
              InkWell(
                onTap: _pickDate,
                borderRadius: AppRadius.cardBorder,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
                    borderRadius: AppRadius.cardBorder,
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      Text(
                        'Change',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Weight input and unit selector
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Weight Value',
                        hintText: _selectedUnit == 'lb' ? '160.0' : '72.5',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        border: OutlineInputBorder(borderRadius: AppRadius.cardBorder),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a weight';
                        }
                        final numVal = double.tryParse(value.trim());
                        if (numVal == null) {
                          return 'Enter a valid number';
                        }
                        if (_selectedUnit == 'kg' && (numVal < 20 || numVal > 500)) {
                          return 'Enter realistic weight (20 - 500 kg)';
                        }
                        if (_selectedUnit == 'lb' && (numVal < 44 || numVal > 1100)) {
                          return 'Enter realistic weight (44 - 1100 lb)';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Unit Toggle Buttons
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
                      borderRadius: AppRadius.cardBorder,
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildUnitButton('kg'),
                        _buildUnitButton('lb'),
                      ],
                    ),
                  ),
                ],
              ),

              if (_error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _error!,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              AppButton(
                text: 'Save Weight Entry',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitButton(String unit) {
    final isSelected = _selectedUnit == unit;
    return GestureDetector(
      onTap: () {
        if (_selectedUnit == unit) return;
        final currentText = _weightController.text.trim();
        final currentVal = double.tryParse(currentText);

        setState(() {
          _selectedUnit = unit;
          if (currentVal != null) {
            if (unit == 'lb') {
              _weightController.text = (currentVal * 2.20462).toStringAsFixed(1);
            } else {
              _weightController.text = (currentVal / 2.20462).toStringAsFixed(1);
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.cardBorder,
        ),
        child: Text(
          unit.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}

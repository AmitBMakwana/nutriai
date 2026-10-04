import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/safe_file_image.dart';
import '../../domain/entities/ai_meal_analysis_entity.dart';
import '../providers/meal_scan_review_provider.dart';
import '../widgets/edit_detected_item_bottom_sheet.dart';
import '../widgets/scan_analyzing_view.dart';
import '../widgets/scan_error_views.dart';
import 'food_search_screen.dart';
import 'meal_builder_screen.dart';

class MealScanReviewScreen extends ConsumerStatefulWidget {
  final File imageFile;
  final String mealType;

  const MealScanReviewScreen({
    super.key,
    required this.imageFile,
    this.mealType = 'lunch',
  });

  @override
  ConsumerState<MealScanReviewScreen> createState() => _MealScanReviewScreenState();
}

class _MealScanReviewScreenState extends ConsumerState<MealScanReviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealScanReviewProvider.notifier).analyzeImage(
            widget.imageFile,
            widget.mealType,
          );
    });
  }

  void _onSaveMeal() async {
    final notifier = ref.read(mealScanReviewProvider.notifier);
    final success = await notifier.saveMeal();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal saved successfully to your nutrition log!'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate back to Dashboard/Home
      context.go(AppConstants.homePath);
    } else {
      final error = ref.read(mealScanReviewProvider).errorMessage ?? 'Failed to save meal';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onEnterManually() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MealBuilderScreen(
          initialMealType: widget.mealType,
        ),
      ),
    );
  }

  void _onRetake() {
    Navigator.of(context).pop();
  }

  void _onAddFoodManually() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FoodSearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scanState = ref.watch(mealScanReviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          scanState.status == ScanStatus.analyzing
              ? 'Analyzing Meal...'
              : scanState.status == ScanStatus.error
                  ? 'Meal Analysis'
                  : 'Review Meal',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          if (scanState.status == ScanStatus.success)
            IconButton(
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Add Food',
              onPressed: _onAddFoodManually,
            ),
        ],
      ),
      body: switch (scanState.status) {
        ScanStatus.initial || ScanStatus.analyzing => ScanAnalyzingView(
            imageFile: widget.imageFile,
            statusMessage: scanState.statusMessage,
          ),
        ScanStatus.error => _buildErrorView(scanState),
        ScanStatus.success => _buildReviewContent(isDark, scanState),
      },
    );
  }

  Widget _buildErrorView(MealScanReviewState state) {
    switch (state.errorType) {
      case ScanErrorType.quotaExceeded:
        return ScanQuotaExceededView(
          onEnterManually: _onEnterManually,
          onUpgrade: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pro subscription checkout arriving in billing milestone!'),
              ),
            );
          },
        );
      case ScanErrorType.nonFood:
        return ScanNonFoodView(
          message: state.errorMessage,
          onRetake: _onRetake,
          onEnterManually: _onEnterManually,
        );
      case ScanErrorType.serviceUnavailable:
      case ScanErrorType.network:
      case ScanErrorType.generic:
      default:
        return ScanServiceErrorView(
          message: state.errorMessage,
          onRetry: () {
            ref.read(mealScanReviewProvider.notifier).analyzeImage(
                  widget.imageFile,
                  widget.mealType,
                );
          },
          onEnterManually: _onEnterManually,
        );
    }
  }

  Widget _buildReviewContent(bool isDark, MealScanReviewState scanState) {
    final notifier = ref.read(mealScanReviewProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card with Image Thumbnail and Overall Confidence
                _buildHeaderCard(isDark, scanState),
                const SizedBox(height: AppSpacing.md),

                // Low confidence warning banner if applicable
                if (scanState.hasLowConfidenceItems) ...[
                  _buildLowConfidenceBanner(isDark),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Detected Items Title & Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detected Items (${scanState.items.length})',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Add Item'),
                      onPressed: _onAddFoodManually,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),

                // List of Detected Items
                if (scanState.items.isEmpty)
                  _buildEmptyItemsState(isDark)
                else
                  ...scanState.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _buildDetectedItemCard(isDark, item, index, notifier);
                  }),
                const SizedBox(height: AppSpacing.md),

                // Estimates Disclaimer
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Estimates are derived from AI vision analysis. Tap any item to adjust portion weights or macros.',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),

        // Bottom Live Total Bar & Save Button
        _buildBottomTotalBar(isDark, scanState),
      ],
    );
  }

  Widget _buildHeaderCard(bool isDark, MealScanReviewState state) {
    final overallConfidence = (state.analysisResult?.confidence ?? 0.9) * 100;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          // Meal photo thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 72,
              height: 72,
              child: SafeFileImage(
                file: widget.imageFile,
                fit: BoxFit.cover,
                placeholder: Container(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  child: const Icon(Icons.restaurant, color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Meal title & Confidence
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: AppRadius.pillBorder,
                      ),
                      child: Text(
                        widget.mealType.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    // Overall confidence badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: overallConfidence >= 80
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.carbs.withValues(alpha: 0.15),
                        borderRadius: AppRadius.pillBorder,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            overallConfidence >= 80
                                ? Icons.verified_rounded
                                : Icons.help_outline_rounded,
                            size: 12,
                            color: overallConfidence >= 80
                                ? AppColors.primary
                                : AppColors.carbs,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${overallConfidence.round()}% match',
                            style: AppTypography.labelSmall.copyWith(
                              color: overallConfidence >= 80
                                  ? AppColors.primary
                                  : AppColors.carbs,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  state.analysisResult?.mealName ?? 'Recognized Meal',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowConfidenceBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.carbs.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.carbs.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.carbs,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Some portions have lower confidence (<60%). Please tap highlighted items to verify portion weight.',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedItemCard(
    bool isDark,
    AiDetectedItemEntity item,
    int index,
    MealScanReviewNotifier notifier,
  ) {
    final isLowConfidence = item.isLowConfidence;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isLowConfidence
              ? AppColors.carbs.withValues(alpha: 0.6)
              : isDark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
          width: isLowConfidence ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          EditDetectedItemBottomSheet.show(
            context,
            item: item,
            onSave: (updated) => notifier.updateItem(index, updated),
          );
        },
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top item row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),

                  // Confidence badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isLowConfidence
                          ? AppColors.carbs.withValues(alpha: 0.15)
                          : AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: AppRadius.pillBorder,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLowConfidence)
                          const Icon(
                            Icons.help_outline,
                            size: 10,
                            color: AppColors.carbs,
                          ),
                        Text(
                          ' ${(item.confidence * 100).round()}%',
                          style: AppTypography.labelSmall.copyWith(
                            color: isLowConfidence
                                ? AppColors.carbs
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),

                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.error,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => notifier.removeItem(index),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // Quantity & Nutrition breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.quantity.toString().replaceAll(RegExp(r'\.0$'), '')} ${item.unit}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${item.calories} kcal',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.carbs,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // Macro pills
              Row(
                children: [
                  _buildMacroPill('P', '${item.protein}g', AppColors.protein),
                  const SizedBox(width: AppSpacing.xs),
                  _buildMacroPill('C', '${item.carbs}g', AppColors.carbs),
                  const SizedBox(width: AppSpacing.xs),
                  _buildMacroPill('F', '${item.fat}g', AppColors.fat),
                  const Spacer(),
                  Text(
                    'Tap to edit',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        '$label $value',
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyItemsState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Icon(Icons.playlist_remove_rounded, size: 40, color: Colors.grey),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'All items removed',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTotalBar(bool isDark, MealScanReviewState scanState) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Live totals row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL CALORIES',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${scanState.totalCalories} kcal',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildTotalMacroCol('Protein', '${scanState.totalProtein}g', AppColors.protein),
                    const SizedBox(width: AppSpacing.md),
                    _buildTotalMacroCol('Carbs', '${scanState.totalCarbs}g', AppColors.carbs),
                    const SizedBox(width: AppSpacing.md),
                    _buildTotalMacroCol('Fat', '${scanState.totalFat}g', AppColors.fat),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Save Meal button
            AppButton(
              text: 'Save Meal to Diary',
              icon: const Icon(Icons.check_circle_rounded),
              isLoading: scanState.isSaving,
              onPressed: scanState.items.isEmpty ? null : _onSaveMeal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalMacroCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

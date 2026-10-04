import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../weight/presentation/providers/weight_notifier.dart';
import '../../../weight/presentation/widgets/add_weight_bottom_sheet.dart';
import '../../../weight/presentation/widgets/weight_history_list.dart';
import '../../../weight/presentation/widgets/weight_line_chart.dart';
import '../providers/progress_notifier.dart';
import '../widgets/calories_chart.dart';
import '../widgets/macro_breakdown_card.dart';
import '../widgets/progress_stats_row.dart';
import '../widgets/range_selector.dart';
import '../widgets/skeleton_cards.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddWeightSheet() {
    final weightState = ref.read(weightNotifierProvider);
    final unitSystem = weightState.history.unitSystem;
    final currentKg = weightState.history.currentWeightKg;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddWeightBottomSheet(
        initialUnitSystem: unitSystem,
        currentWeightKg: currentKg,
        onSave: ({required double value, required String unitSystem, required DateTime date}) {
          return ref.read(weightNotifierProvider.notifier).addWeight(
                value: value,
                unitSystem: unitSystem,
                date: date,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        actions: [
          // Show weight button only on weight tab
          ListenableBuilder(
            listenable: _tabController,
            builder: (_, _) => _tabController.index == 1
                ? TextButton.icon(
                    onPressed: _openAddWeightSheet,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Log Weight'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor:
              isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Nutrition'),
            Tab(text: 'Weight'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NutritionTab(),
          _WeightTab(onAddWeight: _openAddWeightSheet),
        ],
      ),
    );
  }
}

// ─── Nutrition / Calorie Tab ─────────────────────────────────────────────────

class _NutritionTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressNotifierProvider);
    final notifier = ref.read(progressNotifierProvider.notifier);

    if (state.isLoading && state.data == null) {
      return const SkeletonProgressPage();
    }

    if (state.errorMessage != null && state.data == null) {
      return Center(
        child: ErrorView(
          message: state.errorMessage!,
          onRetry: () => notifier.loadProgress(),
        ),
      );
    }

    final data = state.data;

    if (data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No data yet',
              style: AppTypography.titleMedium.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start logging meals to see your progress',
              style: AppTypography.bodySmall.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalDays = data.calorieDaily.length;

    return RefreshIndicator(
      onRefresh: () => notifier.loadProgress(),
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        children: [
          // Range Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RangeSelector(
                selected: state.selectedRange,
                onChanged: (r) => notifier.selectRange(r),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Stats Row
          ProgressStatsRow(
            mealsTracked: data.mealsTracked,
            daysOnTarget: data.daysOnTarget,
            activeDays: data.activeDays,
            streak: data.streak,
            totalDays: totalDays,
          ),

          const SizedBox(height: AppSpacing.md),

          // Calorie Chart card
          _SectionCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'Daily Calories',
                  subtitle: 'Avg: ${data.calorieAverage} kcal / Target: ${data.calorieTarget} kcal',
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.md),
                CaloriesChart(
                  points: data.calorieDaily,
                  target: data.calorieTarget,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Macro breakdown
          MacroBreakdownCard(
            averages: data.macroAverages,
            targets: data.macroTargets,
          ),

          const SizedBox(height: AppSpacing.md),

          // Weight mini-preview in nutrition tab
          if (data.weight.series.isNotEmpty) ...[
            _SectionCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Weight in Period',
                    subtitle: data.weight.changeKg != null
                        ? '${data.weight.changeKg! >= 0 ? '+' : ''}${data.weight.changeKg!.toStringAsFixed(1)} kg'
                        : '',
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _WeightMiniRow(
                    startKg: data.weight.startKg,
                    currentKg: data.weight.currentKg,
                    targetKg: data.weight.targetKg,
                    changeKg: data.weight.changeKg,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── Weight Tab ──────────────────────────────────────────────────────────────

class _WeightTab extends ConsumerWidget {
  final VoidCallback onAddWeight;

  const _WeightTab({required this.onAddWeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weightState = ref.watch(weightNotifierProvider);
    final history = weightState.history;
    final unit = history.unitLabel;

    return RefreshIndicator(
      onRefresh: () => ref.read(weightNotifierProvider.notifier).loadHistory(),
      color: AppColors.primary,
      child: weightState.isLoading && history.logs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : weightState.errorMessage != null && history.logs.isEmpty
              ? Center(
                  child: ErrorView(
                    message: weightState.errorMessage!,
                    onRetry: () =>
                        ref.read(weightNotifierProvider.notifier).loadHistory(),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  children: [
                    // Current weight hero card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Current Weight',
                                style: AppTypography.labelMedium.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              if (history.targetWeightKg != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: AppRadius.pillBorder,
                                  ),
                                  child: Text(
                                    'Goal: ${history.formattedTargetWeight} $unit',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                history.formattedCurrentWeight,
                                style: AppTypography.headlineLarge.copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                unit,
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              const Spacer(),
                              if (history.differenceToTarget != null)
                                _TargetDiffChip(
                                    diff: history.differenceToTarget!,
                                    unit: unit),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Trend label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weight Trend',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          '${history.unitSystem.toUpperCase()} UNITS',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    WeightLineChart(
                      logs: history.logs,
                      unitSystem: history.unitSystem,
                      targetWeight: history.displayTargetWeight,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    WeightHistoryList(
                      logs: history.logs,
                      unitSystem: history.unitSystem,
                      onDelete: (id) async {
                        final success = await ref
                            .read(weightNotifierProvider.notifier)
                            .deleteWeight(id);
                        if (context.mounted && success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Weight entry deleted'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
    );
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _SectionCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
      ],
    );
  }
}

class _WeightMiniRow extends StatelessWidget {
  final double? startKg;
  final double? currentKg;
  final double? targetKg;
  final double? changeKg;
  final bool isDark;

  const _WeightMiniRow({
    this.startKg,
    this.currentKg,
    this.targetKg,
    this.changeKg,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (startKg != null) _Mini('Start', '${startKg!.toStringAsFixed(1)} kg', isDark),
        if (currentKg != null) _Mini('Now', '${currentKg!.toStringAsFixed(1)} kg', isDark),
        if (targetKg != null) _Mini('Goal', '${targetKg!.toStringAsFixed(1)} kg', isDark),
        if (changeKg != null)
          _Mini(
            'Change',
            '${changeKg! >= 0 ? '+' : ''}${changeKg!.toStringAsFixed(1)} kg',
            isDark,
            color: changeKg! < 0 ? Colors.green : Colors.orange,
          ),
      ],
    );
  }
}

class _Mini extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? color;

  const _Mini(this.label, this.value, this.isDark, {this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 10,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class _TargetDiffChip extends StatelessWidget {
  final double diff;
  final String unit;

  const _TargetDiffChip({required this.diff, required this.unit});

  @override
  Widget build(BuildContext context) {
    final isLoss = diff < 0;
    final isExact = diff.abs() < 0.1;
    final text = isExact
        ? 'Goal reached! 🎉'
        : isLoss
            ? '${diff.abs().toStringAsFixed(1)} $unit to gain'
            : '${diff.toStringAsFixed(1)} $unit to lose';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isExact
            ? Colors.green.withValues(alpha: 0.15)
            : (isLoss
                ? Colors.blue.withValues(alpha: 0.15)
                : AppColors.primary.withValues(alpha: 0.12)),
        borderRadius: AppRadius.pillBorder,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isExact
              ? Colors.green
              : (isLoss ? Colors.blue : AppColors.primary),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/weight_log_entity.dart';

class WeightLineChart extends StatelessWidget {
  final List<WeightLogEntity> logs;
  final String unitSystem;
  final double? targetWeight;

  const WeightLineChart({
    super.key,
    required this.logs,
    required this.unitSystem,
    this.targetWeight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unit = WeightLogEntity.unitSymbol(unitSystem);

    if (logs.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: AppRadius.cardBorder,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.show_chart_rounded,
              size: 40,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No weight entries yet',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Log your first weigh-in to see your progress chart',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Convert logs to FlSpots
    final sortedLogs = List<WeightLogEntity>.from(logs)
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));

    final spots = <FlSpot>[];
    double minY = double.infinity;
    double maxY = -double.infinity;

    for (int i = 0; i < sortedLogs.length; i++) {
      final y = sortedLogs[i].weightIn(unitSystem);
      spots.add(FlSpot(i.toDouble(), double.parse(y.toStringAsFixed(1))));
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }

    if (targetWeight != null) {
      if (targetWeight! < minY) minY = targetWeight!;
      if (targetWeight! > maxY) maxY = targetWeight!;
    }

    // Add padding to Y bounds
    final yRange = maxY - minY;
    final yPad = yRange > 0 ? yRange * 0.15 : 2.0;
    final chartMinY = (minY - yPad).clamp(0.0, double.infinity);
    final chartMaxY = maxY + yPad;

    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (yRange / 4).clamp(1.0, 100.0),
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.black12,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: (sortedLogs.length / 5).clamp(1.0, 10.0),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < sortedLogs.length) {
                    final date = sortedLogs[index].loggedAt;
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        DateFormat('MMM d').format(date),
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (sortedLogs.length - 1).toDouble().clamp(0.0, double.infinity),
          minY: chartMinY,
          maxY: chartMaxY,
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              if (targetWeight != null)
                HorizontalLine(
                  y: targetWeight!,
                  color: AppColors.primary.withValues(alpha: 0.6),
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 6, bottom: 2),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    labelResolver: (line) => 'Goal: ${line.y.toStringAsFixed(1)} $unit',
                  ),
                ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  final log = sortedLogs[index];
                  final formattedDate = DateFormat('MMM d, yyyy').format(log.loggedAt);
                  return LineTooltipItem(
                    '${spot.y} $unit\n',
                    TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: formattedDate,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: sortedLogs.length > 2,
              curveSmoothness: 0.25,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: sortedLogs.length <= 15,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.28),
                    AppColors.primary.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

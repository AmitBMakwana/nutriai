import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/progress_entities.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

/// Line chart of daily calories vs. target
class CaloriesChart extends StatelessWidget {
  final List<DailyCaloriePoint> points;
  final int target;

  const CaloriesChart({super.key, required this.points, required this.target});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const _EmptyChart(label: 'No calorie data');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spots = points.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.consumed.toDouble());
    }).toList();

    final maxY = (points.map((p) => p.consumed).reduce((a, b) => a > b ? a : b)).toDouble();
    final yMax = (maxY * 1.15).clamp(target.toDouble() + 200, double.infinity);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (v) => FlLine(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (v, _) => Text(
                  '${(v / 1000).toStringAsFixed(1)}k',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _bottomInterval(points.length),
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= points.length) return const SizedBox.shrink();
                  return Text(
                    DateFormat('M/d').format(points[idx].date),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          minY: 0,
          maxY: yMax,
          lineBarsData: [
            // Consumed line
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 2.5,
              dotData: FlDotData(
                show: points.length <= 14,
                getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                  radius: 3,
                  color: AppColors.primary,
                  strokeWidth: 1.5,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.25),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
            // Target line (dashed)
            LineChartBarData(
              spots: [
                FlSpot(0, target.toDouble()),
                FlSpot((points.length - 1).toDouble(), target.toDouble()),
              ],
              isCurved: false,
              color: Colors.orange.withValues(alpha: 0.7),
              barWidth: 1.5,
              dashArray: [6, 4],
              dotData: const FlDotData(show: false),
            ),
          ],
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: target.toDouble(),
                color: Colors.transparent,
                strokeWidth: 0,
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) => 'Goal',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                return spots.map((s) {
                  final idx = s.x.toInt();
                  if (idx < 0 || idx >= points.length) return null;
                  final p = points[idx];
                  final label = s.barIndex == 0
                      ? '${p.consumed} kcal'
                      : 'Target: ${p.target} kcal';
                  return LineTooltipItem(
                    label,
                    TextStyle(
                      color: s.barIndex == 0 ? AppColors.primary : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  double _bottomInterval(int length) {
    if (length <= 7) return 1;
    if (length <= 30) return 5;
    if (length <= 91) return 14;
    return 30;
  }
}

class _EmptyChart extends StatelessWidget {
  final String label;
  const _EmptyChart({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}

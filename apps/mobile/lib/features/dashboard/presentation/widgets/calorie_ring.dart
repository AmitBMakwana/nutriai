import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/dashboard_entity.dart';

class CalorieRing extends StatelessWidget {
  final CalorieSummaryEntity calories;

  const CalorieRing({
    super.key,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isOver = calories.isOverTarget;

    final progress = calories.target > 0
        ? (calories.consumed / calories.target).clamp(0.0, 1.0)
        : 0.0;

    final ringColor = isOver ? AppColors.fat : AppColors.primary;
    final secondaryRingColor = isOver ? const Color(0xFFE11D48) : AppColors.primaryDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: isOver
              ? AppColors.fat.withValues(alpha: 0.4)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        boxShadow: [
          BoxShadow(
            color: ringColor.withValues(alpha: isDark ? 0.05 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: _CalorieRingPainter(
                    progress: value,
                    isOver: isOver,
                    ringColor: ringColor,
                    secondaryColor: secondaryRingColor,
                    backgroundColor: isDark
                        ? AppColors.surfaceDarkSubtle
                        : AppColors.surfaceLightSubtle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isOver) ...[
                            Text(
                              '+${_formatNumber(calories.overTargetAmount)}',
                              style: AppTypography.headlineMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.fat,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.fat.withValues(alpha: 0.15),
                                borderRadius: AppRadius.pillBorder,
                              ),
                              child: Text(
                                'kcal over goal',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.fat,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ] else ...[
                            Text(
                              _formatNumber(calories.remaining),
                              style: AppTypography.headlineLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontSize: 36,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'kcal remaining',
                              style: AppTypography.labelMedium.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMetricPill(
                label: 'Consumed',
                value: '${_formatNumber(calories.consumed)} kcal',
                color: isOver ? AppColors.fat : AppColors.primary,
                isDark: isDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildMetricPill(
                label: 'Goal',
                value: '${_formatNumber(calories.target)} kcal',
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildMetricPill({
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
        borderRadius: AppRadius.pillBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          Text(
            value,
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class _CalorieRingPainter extends CustomPainter {
  final double progress;
  final bool isOver;
  final Color ringColor;
  final Color secondaryColor;
  final Color backgroundColor;

  _CalorieRingPainter({
    required this.progress,
    required this.isOver,
    required this.ringColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = 14.0;
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [ringColor, secondaryColor],
      );

      final progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isOver != isOver ||
        oldDelegate.ringColor != ringColor;
  }
}

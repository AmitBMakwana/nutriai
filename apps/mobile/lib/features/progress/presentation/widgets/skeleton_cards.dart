import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// A shimmering skeleton placeholder for cards while data loads.
class SkeletonCard extends StatefulWidget {
  final double height;
  final double? width;

  const SkeletonCard({super.key, this.height = 120, this.width});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Opacity(
        opacity: _animation.value,
        child: Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            borderRadius: AppRadius.cardBorder,
          ),
        ),
      ),
    );
  }
}

class SkeletonProgressPage extends StatelessWidget {
  const SkeletonProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      children: const [
        SkeletonCard(height: 56),   // range selector
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 72),   // stats row
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 200),  // calorie chart
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 180),  // macro breakdown
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 200),  // weight chart
      ],
    );
  }
}

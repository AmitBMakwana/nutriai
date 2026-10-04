import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Skeleton loader box that pulses smoothly to indicate loading state.
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  const SkeletonBox.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(999));

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight;
    final highlightColor = isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = Color.lerp(baseColor, highlightColor, _animation.value);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: widget.borderRadius ?? AppRadius.r12,
          ),
        );
      },
    );
  }
}

/// Full loading view with skeleton cards and lines.
class LoadingView extends StatelessWidget {
  final int itemCount;
  final EdgeInsets padding;

  const LoadingView({
    super.key,
    this.itemCount = 4,
    this.padding = AppSpacing.screenMargin,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => AppSpacing.gapH16,
      itemBuilder: (context, index) {
        return Container(
          padding: AppSpacing.p16,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: AppRadius.r24,
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonBox.circle(size: 44),
                  AppSpacing.gapW12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SkeletonBox(width: 140, height: 16),
                        AppSpacing.gapH8,
                        SkeletonBox(width: 90, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              const SkeletonBox(height: 60),
              AppSpacing.gapH12,
              Row(
                children: const [
                  Expanded(child: SkeletonBox(height: 24)),
                  AppSpacing.gapW12,
                  Expanded(child: SkeletonBox(height: 24)),
                  AppSpacing.gapW12,
                  Expanded(child: SkeletonBox(height: 24)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

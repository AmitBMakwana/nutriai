import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/loading_view.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.sm),
          // Date selector bar skeleton
          const SkeletonBox(height: 44, borderRadius: AppRadius.pillBorder),
          const SizedBox(height: AppSpacing.md),

          // Calorie ring card skeleton
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppRadius.cardBorder,
            ),
            child: Column(
              children: const [
                SkeletonBox.circle(size: 180),
                SizedBox(height: AppSpacing.md),
                SkeletonBox(width: 160, height: 24),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Three macro cards skeleton
          Row(
            children: const [
              Expanded(child: SkeletonBox(height: 80, borderRadius: AppRadius.cardBorder)),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: SkeletonBox(height: 80, borderRadius: AppRadius.cardBorder)),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: SkeletonBox(height: 80, borderRadius: AppRadius.cardBorder)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Water card skeleton
          const SkeletonBox(height: 110, borderRadius: AppRadius.cardBorder),
          const SizedBox(height: AppSpacing.lg),

          // Meals section skeleton
          const SkeletonBox(width: 140, height: 24),
          const SizedBox(height: AppSpacing.sm),
          const SkeletonBox(height: 70, borderRadius: AppRadius.cardBorder),
          const SizedBox(height: AppSpacing.sm),
          const SkeletonBox(height: 70, borderRadius: AppRadius.cardBorder),
          const SizedBox(height: AppSpacing.sm),
          const SkeletonBox(height: 70, borderRadius: AppRadius.cardBorder),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

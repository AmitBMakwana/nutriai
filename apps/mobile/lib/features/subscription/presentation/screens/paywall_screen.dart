import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionNotifierProvider.notifier).loadSubscription();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listen for errors or success messages
    ref.listen<SubscriptionState>(subscriptionNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
      if (next.successMessage != null && next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    });

    final currentSub = subState.subscription;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Close Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 14, color: AppColors.primary),
                        AppSpacing.gapW4,
                        Text(
                          currentSub.planDisplayName.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero Icon & Title
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    AppSpacing.gapH16,

                    Text(
                      'Unlock NutriAI Pro',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    AppSpacing.gapH8,

                    Text(
                      'Supercharge your nutrition goals with intelligent meal scans, personalized macro targets, and priority AI processing.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.4,
                      ),
                    ),
                    AppSpacing.gapH20,

                    // Scan Usage Indicator Card ("3 of 5 scans used")
                    _buildUsageCard(context, currentSub, isDark),
                    AppSpacing.gapH20,

                    // Billing Cycle Switcher (Annual vs Monthly)
                    _buildBillingCycleToggle(context, subState, isDark),
                    AppSpacing.gapH16,

                    // Package Cards
                    ...subState.packages
                        .where((p) => p.period == (subState.isAnnual ? 'annual' : 'monthly'))
                        .map((pkg) => _buildPackageCard(context, pkg, subState, isDark)),

                    AppSpacing.gapH20,

                    // Features Checklist
                    _buildFeatureList(context, isDark),
                    AppSpacing.gapH24,

                    // Disclaimer
                    Text(
                      'Subscribers can cancel anytime. Subscriptions renew automatically unless canceled at least 24 hours prior to end of the billing period. Health estimates are educational and not medical advice.',
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                    AppSpacing.gapH20,
                  ],
                ),
              ),
            ),

            // Bottom Sticky CTA Section
            _buildBottomBar(context, subState, isDark),
          ],
        ),
      ),
    );
  }

  /// Usage Indicator widget satisfying the requirement: ("3 of 5 scans used")
  Widget _buildUsageCard(BuildContext context, dynamic sub, bool isDark) {
    final used = sub.usedScans;
    final total = sub.quota;
    final remaining = sub.remainingScans;
    final progress = sub.usagePercentage;
    final isExhausted = sub.isQuotaExhausted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.r20,
        border: Border.all(
          color: isExhausted
              ? AppColors.error.withValues(alpha: 0.5)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 18,
                    color: isExhausted ? AppColors.error : AppColors.primary,
                  ),
                  AppSpacing.gapW8,
                  Text(
                    'AI Scan Usage',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Indicator text required: "3 of 5 scans used"
              Text(
                '$used of $total scans used',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isExhausted ? AppColors.error : AppColors.primary,
                ),
              ),
            ],
          ),
          AppSpacing.gapH12,
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(
                isExhausted
                    ? AppColors.error
                    : (progress > 0.8 ? AppColors.secondary : AppColors.primary),
              ),
            ),
          ),
          AppSpacing.gapH8,
          Text(
            isExhausted
                ? 'You have reached your scan limit for this month. Upgrade to Pro for 100 scans!'
                : '$remaining scans remaining this month on ${sub.planDisplayName}.',
            style: AppTypography.labelSmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingCycleToggle(BuildContext context, SubscriptionState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(subscriptionNotifierProvider.notifier).setAnnualBilling(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: state.isAnnual
                      ? (isDark ? AppColors.surfaceDark : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: state.isAnnual
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Annual',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: state.isAnnual ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SAVE 50%',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(subscriptionNotifierProvider.notifier).setAnnualBilling(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !state.isAnnual
                      ? (isDark ? AppColors.surfaceDark : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !state.isAnnual
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Monthly',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: !state.isAnnual ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context,
    dynamic pkg,
    SubscriptionState state,
    bool isDark,
  ) {
    final isSelected = state.selectedPackageId == pkg.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => ref.read(subscriptionNotifierProvider.notifier).selectPackage(pkg.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: AppRadius.r20,
            border: Border.all(
              color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Radio Indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textMutedLight,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              AppSpacing.gapW12,

              // Plan Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pkg.title,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (pkg.badgeText != null) ...[
                          AppSpacing.gapW8,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pkg.badgeText!,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primaryDark,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.gapH4,
                    Text(
                      pkg.description,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Price
              Text(
                pkg.priceString,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context, bool isDark) {
    const features = [
      '100 AI meal scans per month with vision analysis',
      'Instant calorie, macro, and micro-nutrient estimations',
      'Advanced historical analytics and weekly trend reports',
      'Priority AI speed and dedicated customer support',
      'Exportable CSV and PDF dietary summaries',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.r20,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EVERYTHING IN PRO INCLUDES:',
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          AppSpacing.gapH12,
          ...features.map(
            (feat) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feat,
                      style: AppTypography.bodySmall.copyWith(
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, SubscriptionState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Purchase Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              onPressed: state.isPurchasing || state.isRestoring
                  ? null
                  : () async {
                      final success = await ref
                          .read(subscriptionNotifierProvider.notifier)
                          .purchase();
                      if (context.mounted && success) {
                        context.pop();
                      }
                    },
              child: state.isPurchasing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Upgrade to Pro Now',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          AppSpacing.gapH8,

          // Restore Purchases Button
          TextButton(
            onPressed: state.isPurchasing || state.isRestoring
                ? null
                : () async {
                    await ref
                        .read(subscriptionNotifierProvider.notifier)
                        .restorePurchases();
                  },
            child: state.isRestoring
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Restore Purchases',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

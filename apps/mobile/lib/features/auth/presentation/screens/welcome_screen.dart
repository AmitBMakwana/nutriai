import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';

/// Welcome screen introducing NutriAI with call-to-actions to register or log in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.px24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Hero Visual: Scanning Camera Card
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDarkSubtle : AppColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: AppRadius.r32,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Scanner lines
                      Positioned(
                        top: 24,
                        left: 24,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.primary, width: 3),
                              left: BorderSide(color: AppColors.primary, width: 3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 24,
                        right: 24,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.primary, width: 3),
                              right: BorderSide(color: AppColors.primary, width: 3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 24,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.primary, width: 3),
                              left: BorderSide(color: AppColors.primary, width: 3),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        right: 24,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.primary, width: 3),
                              right: BorderSide(color: AppColors.primary, width: 3),
                            ),
                          ),
                        ),
                      ),
                      // Center Camera & Meal Icon
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 54,
                            color: isDark ? AppColors.primaryLight : AppColors.primary,
                          ),
                          AppSpacing.gapH8,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.coral,
                              borderRadius: AppRadius.pillRadius,
                            ),
                            child: const Text(
                              'AI Scanner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Headline
              Text(
                'Track meals with a photo',
                textAlign: TextAlign.center,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.gapH12,
              // Subtitle
              Text(
                'AI estimates calories and macros in seconds. Snap your meal, understand your nutrition, reach your goal.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.45,
                ),
              ),
              const Spacer(),
              // CTA Buttons
              AppButton.primary(
                text: 'Get Started',
                onPressed: () => context.push(AppConstants.registerPath),
              ),
              AppSpacing.gapH12,
              AppButton.secondary(
                text: 'I already have an account',
                onPressed: () => context.push(AppConstants.loginPath),
              ),
              AppSpacing.gapH24,
            ],
          ),
        ),
      ),
    );
  }
}

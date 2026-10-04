import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

/// Reusable button matching NutriAI design system:
/// Pill-shaped, responsive feedback, loading spinner, and icon support.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.height = 52.0,
    this.backgroundColor,
    this.textColor,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.height = 52.0,
    this.backgroundColor,
    this.textColor,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.height = 52.0,
    this.backgroundColor,
    this.textColor,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.height = 52.0,
    this.backgroundColor,
    this.textColor,
  }) : variant = AppButtonVariant.outline;

  const AppButton.ghost({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.height = 52.0,
    this.backgroundColor,
    this.textColor,
  }) : variant = AppButtonVariant.ghost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = backgroundColor ?? AppColors.primary;
        fg = textColor ?? AppColors.onPrimary;
        break;
      case AppButtonVariant.secondary:
        bg = backgroundColor ?? (isDark ? AppColors.surfaceDarkSubtle : AppColors.surfaceLightSubtle);
        fg = textColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
        break;
      case AppButtonVariant.outline:
        bg = backgroundColor ?? Colors.transparent;
        fg = textColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
        border = BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.5,
        );
        break;
      case AppButtonVariant.ghost:
        bg = backgroundColor ?? Colors.transparent;
        fg = textColor ?? AppColors.primary;
        break;
    }

    final isDisabled = onPressed == null || isLoading;

    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          AppSpacing.gapW12,
        ] else if (icon != null) ...[
          icon!,
          AppSpacing.gapW8,
        ],
        Text(
          text,
          style: AppTypography.labelLarge.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : null,
      child: Material(
        color: isDisabled ? bg.withValues(alpha: 0.5) : bg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.pillRadius,
          side: border,
        ),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: AppRadius.pillRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Reusable modal bottom sheet container with rounded top corners,
/// a drag handle, and optional title and close button.
class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool showCloseButton;
  final EdgeInsets padding;

  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.showCloseButton = true,
    this.padding = AppSpacing.p24,
  });

  /// Static helper to display the sheet modally.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.sheetRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: AppRadius.pillRadius,
                ),
              ),
            ),
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTypography.titleLarge.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (showCloseButton)
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/safe_file_image.dart';

class ScanAnalyzingView extends StatefulWidget {
  final File? imageFile;
  final String statusMessage;

  const ScanAnalyzingView({
    super.key,
    this.imageFile,
    required this.statusMessage,
  });

  @override
  State<ScanAnalyzingView> createState() => _ScanAnalyzingViewState();
}

class _ScanAnalyzingViewState extends State<ScanAnalyzingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing scanner frame
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: widget.imageFile != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                SafeFileImage(
                                  file: widget.imageFile!,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                                const Center(
                                  child: Icon(
                                    Icons.auto_awesome,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Rotating status text with smooth transition
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                widget.statusMessage,
                key: ValueKey<String>(widget.statusMessage),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Powered by NutriAI Clinical Vision',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Minimal progress indicator
            const SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                backgroundColor: Colors.black12,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

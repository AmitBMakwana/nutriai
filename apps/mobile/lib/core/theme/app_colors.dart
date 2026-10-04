import 'package:flutter/material.dart';

/// App color palette supporting both light and dark modes.
/// Health-tech palette: fresh green primary with coral/orange hero accents,
/// macro nutrient colors, and modern neutrals.
abstract class AppColors {
  // --- Brand & Primary ---
  static const Color primary = Color(0xFF22C55E); // Fresh Green (health-tech primary)
  static const Color primaryDark = Color(0xFF16A34A);
  static const Color primaryLight = Color(0xFF86EFAC);
  static const Color primaryContainer = Color(0xFFDCFCE7);
  static const Color onPrimary = Colors.white;

  // --- Coral / Orange Accents (Hero & Energy) ---
  static const Color coral = Color(0xFFFC5C39);
  static const Color coralLight = Color(0xFFFF8A66);
  static const Color peach = Color(0xFFFFEDD5);

  // --- Secondary ---
  static const Color secondary = Color(0xFFF59E0B);
  static const Color secondaryLight = Color(0xFFFDE68A);
  static const Color onSecondary = Colors.white;

  // --- Macro Nutrient Colors ---
  static const Color calories = Color(0xFFFC5C39);
  static const Color protein = Color(0xFF3B82F6); // Protein Blue
  static const Color carbs = Color(0xFF10B981);   // Carbs Mint Green
  static const Color fat = Color(0xFFF43F5E);     // Fat Rose
  static const Color water = Color(0xFF38BDF8);   // Water Sky Blue

  // --- Semantic Feedback ---
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // --- Light Palette ---
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightSubtle = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // --- Dark Palette ---
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceDarkSubtle = Color(0xFF334155);
  static const Color borderDark = Color(0xFF334155);
  static const Color dividerDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textMutedDark = Color(0xFF64748B);

  // --- Shimmer / Skeleton ---
  static const Color shimmerBaseLight = Color(0xFFE2E8F0);
  static const Color shimmerHighlightLight = Color(0xFFF1F5F9);
  static const Color shimmerBaseDark = Color(0xFF1E293B);
  static const Color shimmerHighlightDark = Color(0xFF334155);
}

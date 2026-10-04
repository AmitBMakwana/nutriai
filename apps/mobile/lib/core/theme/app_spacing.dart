import 'package:flutter/widgets.dart';

/// App spacing scale based on standard 8px grid (with 4px half-step).
abstract class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double massive = 64.0;

  // Standard EdgeInsets
  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets p4 = EdgeInsets.all(xs);
  static const EdgeInsets p8 = EdgeInsets.all(sm);
  static const EdgeInsets p12 = EdgeInsets.all(12.0);
  static const EdgeInsets p16 = EdgeInsets.all(md);
  static const EdgeInsets p20 = EdgeInsets.all(20.0);
  static const EdgeInsets p24 = EdgeInsets.all(lg);
  static const EdgeInsets p32 = EdgeInsets.all(xl);

  // Horizontal Padding
  static const EdgeInsets px8 = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets px16 = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets px20 = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets px24 = EdgeInsets.symmetric(horizontal: lg);

  // Vertical Padding
  static const EdgeInsets py8 = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets py12 = EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets py16 = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets py24 = EdgeInsets.symmetric(vertical: lg);

  // Screen Margins
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets screenMargin = EdgeInsets.all(md);

  // Vertical Spacer SizedBoxes
  static const SizedBox gapH4 = SizedBox(height: xs);
  static const SizedBox gapH8 = SizedBox(height: sm);
  static const SizedBox gapH12 = SizedBox(height: 12.0);
  static const SizedBox gapH16 = SizedBox(height: md);
  static const SizedBox gapH20 = SizedBox(height: 20.0);
  static const SizedBox gapH24 = SizedBox(height: lg);
  static const SizedBox gapH32 = SizedBox(height: xl);
  static const SizedBox gapH40 = SizedBox(height: xxl);
  static const SizedBox gapH48 = SizedBox(height: xxxl);

  // Horizontal Spacer SizedBoxes
  static const SizedBox gapW4 = SizedBox(width: xs);
  static const SizedBox gapW8 = SizedBox(width: sm);
  static const SizedBox gapW12 = SizedBox(width: 12.0);
  static const SizedBox gapW16 = SizedBox(width: md);
  static const SizedBox gapW20 = SizedBox(width: 20.0);
  static const SizedBox gapW24 = SizedBox(width: lg);
  static const SizedBox gapW32 = SizedBox(width: xl);
}

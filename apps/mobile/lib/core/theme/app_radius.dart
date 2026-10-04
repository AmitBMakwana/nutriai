import 'package:flutter/widgets.dart';

/// Corner radius scale for cards, buttons, dialogs, and inputs.
abstract class AppRadius {
  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double card = 24.0; // Heavily rounded card design
  static const double xxl = 32.0;
  static const double pill = 999.0;

  // BorderRadius instances
  static const BorderRadius zero = BorderRadius.zero;
  static const BorderRadius r4 = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius r8 = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius r12 = BorderRadius.all(Radius.circular(md));
  static const BorderRadius r16 = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius r20 = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius r24 = BorderRadius.all(Radius.circular(card));
  static const BorderRadius r32 = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius cardBorder = BorderRadius.all(Radius.circular(card));
  static const BorderRadius buttonBorder = BorderRadius.all(Radius.circular(md));
  static const BorderRadius pillBorder = BorderRadius.all(Radius.circular(pill));

  // Top rounded for bottom sheets
  static const BorderRadius sheetRadius = BorderRadius.only(
    topLeft: Radius.circular(card),
    topRight: Radius.circular(card),
  );
}

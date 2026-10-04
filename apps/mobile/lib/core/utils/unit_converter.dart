/// Utility for converting between metric and imperial health measurements.
class UnitConverter {
  const UnitConverter._();

  static const double cmPerInch = 2.54;
  static const double inchesPerFoot = 12.0;
  static const double lbsPerKg = 2.20462262;
  static const double kgPerLb = 0.45359237;

  // --- Height Conversions ---

  /// Converts centimeters to total inches.
  static double cmToInches(double cm) {
    if (cm <= 0) return 0;
    return cm / cmPerInch;
  }

  /// Converts centimeters to a record of (feet, inches), rounded to nearest whole inch.
  static ({int feet, int inches}) cmToFeetAndInches(double cm) {
    if (cm <= 0) return (feet: 0, inches: 0);
    final totalInches = (cm / cmPerInch).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return (feet: feet, inches: inches);
  }

  /// Converts feet and inches to centimeters, rounded to 1 decimal place or integer.
  static double feetAndInchesToCm(int feet, int inches) {
    final totalInches = (feet * 12) + inches;
    if (totalInches <= 0) return 0;
    final cm = totalInches * cmPerInch;
    return double.parse(cm.toStringAsFixed(1));
  }

  // --- Weight Conversions ---

  /// Converts kilograms to pounds (lbs), rounded to 1 decimal place.
  static double kgToLbs(double kg) {
    if (kg <= 0) return 0;
    final lbs = kg * lbsPerKg;
    return double.parse(lbs.toStringAsFixed(1));
  }

  /// Converts pounds (lbs) to kilograms (kg), rounded to 1 decimal place.
  static double lbsToKg(double lbs) {
    if (lbs <= 0) return 0;
    final kg = lbs * kgPerLb;
    return double.parse(kg.toStringAsFixed(1));
  }
}

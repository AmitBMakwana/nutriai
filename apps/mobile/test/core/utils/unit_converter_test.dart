import 'package:flutter_test/flutter_test.dart';
import 'package:nutriai/core/utils/unit_converter.dart';

void main() {
  group('UnitConverter Tests', () {
    group('Height Conversions', () {
      test('cmToInches converts accurately', () {
        expect(UnitConverter.cmToInches(2.54), closeTo(1.0, 0.01));
        expect(UnitConverter.cmToInches(152.4), closeTo(60.0, 0.01));
        expect(UnitConverter.cmToInches(0), equals(0.0));
        expect(UnitConverter.cmToInches(-10), equals(0.0));
      });

      test('cmToFeetAndInches converts standard heights correctly', () {
        // 172 cm = 67.71 inches -> rounds to 68 inches -> 5 ft 8 in
        final h172 = UnitConverter.cmToFeetAndInches(172.0);
        expect(h172.feet, equals(5));
        expect(h172.inches, equals(8));

        // 180 cm = 70.86 inches -> rounds to 71 inches -> 5 ft 11 in
        final h180 = UnitConverter.cmToFeetAndInches(180.0);
        expect(h180.feet, equals(5));
        expect(h180.inches, equals(11));

        // 183 cm = 72.04 inches -> rounds to 72 inches -> 6 ft 0 in
        final h183 = UnitConverter.cmToFeetAndInches(183.0);
        expect(h183.feet, equals(6));
        expect(h183.inches, equals(0));

        // 0 cm
        final h0 = UnitConverter.cmToFeetAndInches(0);
        expect(h0.feet, equals(0));
        expect(h0.inches, equals(0));
      });

      test('feetAndInchesToCm converts back accurately', () {
        expect(UnitConverter.feetAndInchesToCm(5, 8), equals(172.7));
        expect(UnitConverter.feetAndInchesToCm(6, 0), equals(182.9));
        expect(UnitConverter.feetAndInchesToCm(5, 0), equals(152.4));
        expect(UnitConverter.feetAndInchesToCm(0, 0), equals(0.0));
      });
    });

    group('Weight Conversions', () {
      test('kgToLbs converts correctly with 1 decimal precision', () {
        expect(UnitConverter.kgToLbs(70.0), equals(154.3));
        expect(UnitConverter.kgToLbs(80.0), equals(176.4));
        expect(UnitConverter.kgToLbs(100.0), equals(220.5));
        expect(UnitConverter.kgToLbs(0), equals(0.0));
        expect(UnitConverter.kgToLbs(-5), equals(0.0));
      });

      test('lbsToKg converts correctly with 1 decimal precision', () {
        expect(UnitConverter.lbsToKg(154.3), equals(70.0));
        expect(UnitConverter.lbsToKg(176.4), equals(80.0));
        expect(UnitConverter.lbsToKg(220.5), equals(100.0));
        expect(UnitConverter.lbsToKg(0), equals(0.0));
        expect(UnitConverter.lbsToKg(-10), equals(0.0));
      });

      test('Roundtrip conversion retains consistency within 0.1 margin', () {
        const originalKg = 75.5;
        final lbs = UnitConverter.kgToLbs(originalKg);
        final reconvertedKg = UnitConverter.lbsToKg(lbs);
        expect(reconvertedKg, closeTo(originalKg, 0.1));
      });
    });
  });
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:nutriai/core/services/image_preparation_service.dart';

void main() {
  late ImagePreparationService service;
  late Directory testDir;

  setUpAll(() {
    testDir = Directory.systemTemp.createTempSync('nutriai_image_test_');
  });

  tearDownAll(() {
    if (testDir.existsSync()) {
      testDir.deleteSync(recursive: true);
    }
  });

  setUp(() {
    service = ImagePreparationService();
  });

  Uint8List createTestImageBytes({required int width, required int height}) {
    final image = img.Image(width: width, height: height);
    // Draw some colored pixels
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        image.setPixelRgb(x, y, (x * 255 / width).toInt(), (y * 255 / height).toInt(), 128);
      }
    }
    return Uint8List.fromList(img.encodePng(image));
  }

  group('ImagePreparationService Tests', () {
    test('throws exception for empty bytes', () async {
      expect(
        () => service.prepareImageBytes(Uint8List(0)),
        throwsA(isA<ImagePreparationException>().having(
          (e) => e.message,
          'message',
          contains('empty'),
        )),
      );
    });

    test('throws exception for corrupt or invalid bytes', () async {
      final corruptBytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      expect(
        () => service.prepareImageBytes(corruptBytes),
        throwsA(isA<ImagePreparationException>().having(
          (e) => e.message,
          'message',
          contains('Invalid or unsupported'),
        )),
      );
    });

    test('throws exception when input file does not exist', () async {
      final nonExistentFile = File('${testDir.path}/non_existent.jpg');
      expect(
        () => service.prepareImageFile(nonExistentFile),
        throwsA(isA<ImagePreparationException>().having(
          (e) => e.message,
          'message',
          contains('does not exist'),
        )),
      );
    });

    test('resizes large landscape image down to long edge 1280px', () async {
      // 2000 x 1000 image
      final rawBytes = createTestImageBytes(width: 2000, height: 1000);
      final result = await service.prepareImageBytes(
        rawBytes,
        outputDirectoryPath: testDir.path,
      );

      expect(result.width, equals(1280));
      expect(result.height, equals(640));
      expect(result.mimeType, equals('image/jpeg'));
      expect(result.fileSizeBytes, lessThanOrEqualTo(1024 * 1024)); // under 1MB
      expect(result.file.existsSync(), isTrue);
    });

    test('resizes large portrait image down to long edge 1280px', () async {
      // 800 x 2400 image
      final rawBytes = createTestImageBytes(width: 800, height: 2400);
      final result = await service.prepareImageBytes(
        rawBytes,
        outputDirectoryPath: testDir.path,
      );

      expect(result.width, equals((800 * 1280 / 2400).round()));
      expect(result.height, equals(1280));
      expect(result.fileSizeBytes, lessThanOrEqualTo(1024 * 1024));
    });

    test('preserves dimensions when image long edge is smaller than 1280px', () async {
      final rawBytes = createTestImageBytes(width: 600, height: 400);
      final result = await service.prepareImageBytes(
        rawBytes,
        outputDirectoryPath: testDir.path,
      );

      expect(result.width, equals(600));
      expect(result.height, equals(400));
      expect(result.mimeType, equals('image/jpeg'));
      expect(result.fileSizeBytes, lessThanOrEqualTo(1024 * 1024));
    });

    test('prepareImageFile processes file and writes output correctly', () async {
      final testFile = File('${testDir.path}/input_meal.png');
      await testFile.writeAsBytes(createTestImageBytes(width: 1500, height: 1500));

      final result = await service.prepareImageFile(
        testFile,
        outputDirectoryPath: testDir.path,
      );

      expect(result.width, equals(1280));
      expect(result.height, equals(1280));
      expect(result.file.existsSync(), isTrue);
      expect(result.file.path.endsWith('.jpg'), isTrue);
      expect(result.fileSizeBytes, lessThanOrEqualTo(1024 * 1024));
    });
  });
}

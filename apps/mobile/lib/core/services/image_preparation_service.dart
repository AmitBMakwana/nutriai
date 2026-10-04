import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePreparationException implements Exception {
  final String message;
  const ImagePreparationException(this.message);

  @override
  String toString() => 'ImagePreparationException: $message';
}

class PreparedImageResult {
  final File file;
  final String path;
  final Uint8List bytes;
  final int width;
  final int height;
  final int fileSizeBytes;
  final String mimeType;

  const PreparedImageResult({
    required this.file,
    required this.path,
    required this.bytes,
    required this.width,
    required this.height,
    required this.fileSizeBytes,
    this.mimeType = 'image/jpeg',
  });
}

final imagePreparationServiceProvider = Provider<ImagePreparationService>((ref) {
  return ImagePreparationService();
});

class ImagePreparationService {
  static const int defaultMaxLongEdge = 1280;
  static const int defaultTargetMaxBytes = 1024 * 1024; // 1 MB target
  static const int hardMaxBytes = 5 * 1024 * 1024; // 5 MB hard limit

  /// Prepares an image file: validates format, fixes EXIF orientation,
  /// resizes to long edge ~1280px, compresses to JPEG <= 1MB, and writes to disk (or memory on web).
  Future<PreparedImageResult> prepareImageFile(
    File file, {
    int maxLongEdge = defaultMaxLongEdge,
    int targetMaxBytes = defaultTargetMaxBytes,
    String? outputDirectoryPath,
  }) async {
    final Uint8List bytes;
    if (kIsWeb) {
      try {
        bytes = await XFile(file.path).readAsBytes();
      } catch (e) {
        throw ImagePreparationException('Failed to read image data on web: $e');
      }
    } else {
      if (!await file.exists()) {
        throw const ImagePreparationException('Input image file does not exist.');
      }
      bytes = await file.readAsBytes();
    }

    final filename = file.uri.pathSegments.isNotEmpty
        ? file.uri.pathSegments.last
        : 'meal_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return prepareImageBytes(
      bytes,
      filename: filename,
      maxLongEdge: maxLongEdge,
      targetMaxBytes: targetMaxBytes,
      outputDirectoryPath: outputDirectoryPath,
      webOriginalPath: file.path,
    );
  }

  /// Prepares image from raw bytes with orientation baking, resizing, and compression.
  Future<PreparedImageResult> prepareImageBytes(
    Uint8List bytes, {
    String filename = 'meal_image.jpg',
    int maxLongEdge = defaultMaxLongEdge,
    int targetMaxBytes = defaultTargetMaxBytes,
    String? outputDirectoryPath,
    String? webOriginalPath,
  }) async {
    if (bytes.isEmpty) {
      throw const ImagePreparationException('Image data is empty.');
    }

    // 1. Validate format & decode image
    img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const ImagePreparationException(
        'Invalid or unsupported image format. Supported formats include JPEG, PNG, WEBP.',
      );
    }

    // 2. Fix orientation (bakes EXIF rotation into the pixel buffer)
    img.Image oriented = img.bakeOrientation(decoded);

    // 3. Resize long edge to ~1280px maintaining aspect ratio
    img.Image resized = _resizeToMaxLongEdge(oriented, maxLongEdge);

    // 4. Compress to JPEG (target < 1 MB, hard max 5 MB)
    Uint8List compressedBytes = _compressJpeg(
      resized,
      targetMaxBytes: targetMaxBytes,
      hardMaxBytes: hardMaxBytes,
    );

    if (compressedBytes.lengthInBytes > hardMaxBytes) {
      throw const ImagePreparationException(
        'Processed image exceeds maximum allowed size of 5 MB.',
      );
    }

    // 5. Save output file on native or return in-memory descriptor on web
    if (kIsWeb) {
      final safeWebPath = webOriginalPath ?? filename;
      return PreparedImageResult(
        file: File(safeWebPath),
        path: safeWebPath,
        bytes: compressedBytes,
        width: resized.width,
        height: resized.height,
        fileSizeBytes: compressedBytes.lengthInBytes,
        mimeType: 'image/jpeg',
      );
    }

    final dirPath = outputDirectoryPath ?? await _resolveTempDirectory();
    final base = filename.replaceAll(RegExp(r'\.[a-zA-Z0-9]+$'), '');
    final safeName = '${base}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final targetPath = '$dirPath${Platform.pathSeparator}$safeName';
    final outputFile = File(targetPath);
    await outputFile.writeAsBytes(compressedBytes);

    return PreparedImageResult(
      file: outputFile,
      path: targetPath,
      bytes: compressedBytes,
      width: resized.width,
      height: resized.height,
      fileSizeBytes: compressedBytes.lengthInBytes,
      mimeType: 'image/jpeg',
    );
  }

  img.Image _resizeToMaxLongEdge(img.Image image, int maxLongEdge) {
    final width = image.width;
    final height = image.height;
    final longEdge = width >= height ? width : height;

    if (longEdge <= maxLongEdge) {
      return image;
    }

    final double scale = maxLongEdge / longEdge;
    final targetWidth = (width * scale).round();
    final targetHeight = (height * scale).round();

    return img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );
  }

  Uint8List _compressJpeg(
    img.Image image, {
    required int targetMaxBytes,
    required int hardMaxBytes,
  }) {
    int quality = 85;
    Uint8List bestResult = img.encodeJpg(image, quality: quality);

    if (bestResult.lengthInBytes <= targetMaxBytes) {
      return bestResult;
    }

    // Quality reduction steps: 80 -> 75 -> 70 -> 65
    final qualities = [80, 75, 70, 65];
    for (final q in qualities) {
      final attempt = img.encodeJpg(image, quality: q);
      bestResult = attempt;
      if (attempt.lengthInBytes <= targetMaxBytes) {
        return attempt;
      }
    }

    // If still over target, downscale further
    img.Image downscaled = image;
    while (bestResult.lengthInBytes > targetMaxBytes &&
        downscaled.width > 640 &&
        downscaled.height > 640) {
      downscaled = img.copyResize(
        downscaled,
        width: (downscaled.width * 0.8).toInt(),
        interpolation: img.Interpolation.linear,
      );
      bestResult = img.encodeJpg(downscaled, quality: 60);
    }

    return bestResult;
  }

  Future<String> _resolveTempDirectory() async {
    if (kIsWeb) return '';
    try {
      final temp = await getTemporaryDirectory();
      return temp.path;
    } catch (_) {
      try {
        return Directory.systemTemp.path;
      } catch (_) {
        return '';
      }
    }
  }
}

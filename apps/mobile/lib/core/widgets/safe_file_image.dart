import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A platform-safe widget for rendering a local file or blob image across mobile and web.
class SafeFileImage extends StatelessWidget {
  final File file;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;

  const SafeFileImage({
    super.key,
    required this.file,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        file.path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) =>
            placeholder ?? const Center(child: Icon(Icons.restaurant, color: Colors.grey)),
      );
    }

    return Image.file(
      file,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) =>
          placeholder ?? const Center(child: Icon(Icons.restaurant, color: Colors.grey)),
    );
  }
}

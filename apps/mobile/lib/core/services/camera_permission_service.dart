import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final cameraPermissionServiceProvider = Provider<CameraPermissionService>((ref) {
  return CameraPermissionService();
});

class CameraPermissionService {
  Future<PermissionStatus> checkCameraPermission() async {
    try {
      return await Permission.camera.status;
    } catch (_) {
      // In testing or unsupported environments, return denied gracefully
      return PermissionStatus.denied;
    }
  }

  Future<PermissionStatus> requestCameraPermission() async {
    try {
      return await Permission.camera.request();
    } catch (_) {
      return PermissionStatus.denied;
    }
  }

  Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (_) {
      return false;
    }
  }
}

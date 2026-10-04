import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/services/camera_permission_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/camera_permission_view.dart';
import 'image_preview_screen.dart';

class CameraCaptureScreen extends ConsumerStatefulWidget {
  final String initialMealType;

  const CameraCaptureScreen({
    super.key,
    this.initialMealType = 'lunch',
  });

  @override
  ConsumerState<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends ConsumerState<CameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _availableCameras = [];
  int _selectedCameraIndex = 0;
  FlashMode _currentFlashMode = FlashMode.auto;

  bool _isPermissionGranted = false;
  bool _isPermanentlyDenied = false;
  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _errorMessage;

  late String _selectedMealType;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedMealType = widget.initialMealType;
    _checkPermissionAndInitCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permissions when returning from settings
    if (state == AppLifecycleState.resumed) {
      if (!_isPermissionGranted) {
        _checkPermissionAndInitCamera();
      } else if (_controller != null && !_controller!.value.isInitialized) {
        _initCamera();
      }
    }
  }

  Future<void> _checkPermissionAndInitCamera() async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    final permService = ref.read(cameraPermissionServiceProvider);
    PermissionStatus status = await permService.checkCameraPermission();

    if (!status.isGranted) {
      status = await permService.requestCameraPermission();
    }

    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
        _isPermanentlyDenied = false;
      });
      await _initCamera();
    } else {
      setState(() {
        _isPermissionGranted = false;
        _isPermanentlyDenied = status.isPermanentlyDenied;
        _isInitializing = false;
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      _availableCameras = await availableCameras();
      if (_availableCameras.isEmpty) {
        setState(() {
          _isInitializing = false;
          _errorMessage =
              'No physical camera detected. You can upload a photo from your gallery.';
        });
        return;
      }

      final camera = _availableCameras[_selectedCameraIndex];
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.jpeg,
      );

      _controller = controller;
      await controller.initialize();
      await controller.setFlashMode(_currentFlashMode);

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'Could not initialize camera: $e';
        });
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    FlashMode nextMode;
    switch (_currentFlashMode) {
      case FlashMode.auto:
        nextMode = FlashMode.always;
        break;
      case FlashMode.always:
        nextMode = FlashMode.off;
        break;
      case FlashMode.off:
        nextMode = FlashMode.auto;
        break;
      default:
        nextMode = FlashMode.auto;
    }

    try {
      await _controller!.setFlashMode(nextMode);
      setState(() {
        _currentFlashMode = nextMode;
      });
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    if (_availableCameras.length < 2) return;

    final nextIndex = (_selectedCameraIndex + 1) % _availableCameras.length;
    setState(() {
      _selectedCameraIndex = nextIndex;
      _isInitializing = true;
    });

    await _controller?.dispose();
    _controller = null;
    await _initCamera();
  }

  Future<void> _takePhoto() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile photo = await _controller!.takePicture();
      if (!mounted) return;

      setState(() {
        _isCapturing = false;
      });

      _navigateToPreview(File(photo.path));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take photo: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2400,
        maxHeight: 2400,
      );

      if (image != null && mounted) {
        _navigateToPreview(File(image.path));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick photo: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _navigateToPreview(File file) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImagePreviewScreen(
          initialFile: file,
          mealType: _selectedMealType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Camera View or Fallback State
            if (_isInitializing)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            else if (!_isPermissionGranted)
              CameraPermissionView(
                isPermanentlyDenied: _isPermanentlyDenied,
                onRequestPermission: _checkPermissionAndInitCamera,
                onOpenSettings: () =>
                    ref.read(cameraPermissionServiceProvider).openSettings(),
                onPickGallery: _pickFromGallery,
              )
            else if (_errorMessage != null || _controller == null)
              _buildNoCameraFallback(isDark)
            else
              _buildCameraPreview(),

            // 2. Top Header Controls
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(),
            ),

            // 3. Bottom Camera Controls
            if (_isPermissionGranted &&
                _controller != null &&
                _controller!.value.isInitialized)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: CameraPreview(_controller!),
        ),

        // Food plate guide frame
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: AppSpacing.sm,
                  left: 0,
                  right: 0,
                  child: Text(
                    'Center your meal plate in the frame',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoCameraFallback(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.no_photography_outlined,
                size: 48,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Camera Available',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _errorMessage ??
                  'No camera hardware was detected. You can select any meal photo from your gallery.',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Choose Photo from Gallery'),
              onPressed: _pickFromGallery,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),

          // Meal Type Selector Pill
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: AppRadius.pillBorder,
              border: Border.all(
                color: Colors.white24,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMealType,
                dropdownColor: AppColors.surfaceDark,
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 20,
                ),
                items: const [
                  DropdownMenuItem(value: 'breakfast', child: Text('Breakfast')),
                  DropdownMenuItem(value: 'lunch', child: Text('Lunch')),
                  DropdownMenuItem(value: 'dinner', child: Text('Dinner')),
                  DropdownMenuItem(value: 'snack', child: Text('Snack')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedMealType = val;
                    });
                  }
                },
              ),
            ),
          ),

          // Flash button
          IconButton(
            icon: Icon(
              _currentFlashMode == FlashMode.auto
                  ? Icons.flash_auto
                  : _currentFlashMode == FlashMode.always
                      ? Icons.flash_on
                      : Icons.flash_off,
              color: _currentFlashMode == FlashMode.off
                  ? Colors.white54
                  : Colors.amber,
            ),
            onPressed: _toggleFlash,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.xl,
        left: AppSpacing.xl,
        right: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Gallery shortcut button
          IconButton(
            icon: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 28,
            ),
            tooltip: 'Gallery',
            onPressed: _pickFromGallery,
          ),

          // Shutter capture button
          GestureDetector(
            onTap: _takePhoto,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _isCapturing
                        ? AppColors.primary.withValues(alpha: 0.7)
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: _isCapturing
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Switch camera lens button (front/back)
          IconButton(
            icon: const Icon(
              Icons.flip_camera_ios_outlined,
              color: Colors.white,
              size: 28,
            ),
            tooltip: 'Switch Camera',
            onPressed: _availableCameras.length > 1 ? _switchCamera : null,
          ),
        ],
      ),
    );
  }
}

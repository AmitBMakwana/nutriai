import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../domain/entities/meal_entity.dart';
import '../../data/repositories/ai_analysis_repository_impl.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/entities/ai_meal_analysis_entity.dart';
import '../../domain/repositories/ai_analysis_repository_interface.dart';
import '../../domain/repositories/meal_repository_interface.dart';
import 'meals_tab_provider.dart';

enum ScanStatus {
  initial,
  analyzing,
  success,
  error,
}

enum ScanErrorType {
  none,
  quotaExceeded,
  nonFood,
  serviceUnavailable,
  network,
  generic,
}

class MealScanReviewState {
  final ScanStatus status;
  final ScanErrorType errorType;
  final String? errorMessage;
  final String statusMessage;
  final AiMealAnalysisResultEntity? analysisResult;
  final List<AiDetectedItemEntity> items;
  final String mealType;
  final bool isSaving;
  final File? originalImage;

  const MealScanReviewState({
    this.status = ScanStatus.initial,
    this.errorType = ScanErrorType.none,
    this.errorMessage,
    this.statusMessage = 'Uploading meal photo...',
    this.analysisResult,
    this.items = const [],
    this.mealType = 'lunch',
    this.isSaving = false,
    this.originalImage,
  });

  int get totalCalories => items.fold<int>(0, (sum, item) => sum + item.calories);
  double get totalProtein =>
      double.parse(items.fold<double>(0.0, (sum, item) => sum + item.protein).toStringAsFixed(1));
  double get totalCarbs =>
      double.parse(items.fold<double>(0.0, (sum, item) => sum + item.carbs).toStringAsFixed(1));
  double get totalFat =>
      double.parse(items.fold<double>(0.0, (sum, item) => sum + item.fat).toStringAsFixed(1));

  bool get hasLowConfidenceItems => items.any((item) => item.isLowConfidence);

  MealScanReviewState copyWith({
    ScanStatus? status,
    ScanErrorType? errorType,
    String? errorMessage,
    String? statusMessage,
    AiMealAnalysisResultEntity? analysisResult,
    List<AiDetectedItemEntity>? items,
    String? mealType,
    bool? isSaving,
    File? originalImage,
  }) {
    return MealScanReviewState(
      status: status ?? this.status,
      errorType: errorType ?? this.errorType,
      errorMessage: errorMessage,
      statusMessage: statusMessage ?? this.statusMessage,
      analysisResult: analysisResult ?? this.analysisResult,
      items: items ?? this.items,
      mealType: mealType ?? this.mealType,
      isSaving: isSaving ?? this.isSaving,
      originalImage: originalImage ?? this.originalImage,
    );
  }
}

final mealScanReviewProvider =
    NotifierProvider<MealScanReviewNotifier, MealScanReviewState>(
  MealScanReviewNotifier.new,
);

class MealScanReviewNotifier extends Notifier<MealScanReviewState> {
  Timer? _statusRotationTimer;

  static const _statusMessages = [
    'Uploading meal photo...',
    'Scanning with AI vision...',
    'Detecting ingredients & portions...',
    'Calculating calories & macros...',
  ];

  @override
  MealScanReviewState build() {
    ref.onDispose(() {
      _statusRotationTimer?.cancel();
    });
    return const MealScanReviewState();
  }

  IAiAnalysisRepository get _analysisRepo => ref.read(aiAnalysisRepositoryProvider);
  IMealRepository get _mealRepo => ref.read(mealRepositoryProvider);

  /// Initiates backend meal image analysis with rotating status messages.
  Future<void> analyzeImage(File image, String mealType) async {
    _statusRotationTimer?.cancel();

    state = state.copyWith(
      status: ScanStatus.analyzing,
      errorType: ScanErrorType.none,
      errorMessage: null,
      statusMessage: _statusMessages.first,
      mealType: mealType,
      originalImage: image,
    );

    int messageIndex = 0;
    _statusRotationTimer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
      messageIndex = (messageIndex + 1) % _statusMessages.length;
      state = state.copyWith(statusMessage: _statusMessages[messageIndex]);
    });

    try {
      final result = await _analysisRepo.analyzeMealImage(
        image: image,
        mealType: mealType,
      );

      _statusRotationTimer?.cancel();

      if (!result.isFood) {
        state = state.copyWith(
          status: ScanStatus.error,
          errorType: ScanErrorType.nonFood,
          errorMessage: result.notes ?? 'No food or drinks were detected in this photo.',
          analysisResult: result,
          items: [],
        );
        return;
      }

      state = state.copyWith(
        status: ScanStatus.success,
        errorType: ScanErrorType.none,
        analysisResult: result,
        items: List.of(result.items),
      );
    } on QuotaExceededApiException catch (e) {
      _statusRotationTimer?.cancel();
      state = state.copyWith(
        status: ScanStatus.error,
        errorType: ScanErrorType.quotaExceeded,
        errorMessage: e.message,
      );
    } on NetworkException catch (e) {
      _statusRotationTimer?.cancel();
      state = state.copyWith(
        status: ScanStatus.error,
        errorType: ScanErrorType.network,
        errorMessage: e.message,
      );
    } on ServerException catch (e) {
      _statusRotationTimer?.cancel();
      state = state.copyWith(
        status: ScanStatus.error,
        errorType: ScanErrorType.serviceUnavailable,
        errorMessage: e.message,
      );
    } catch (e) {
      _statusRotationTimer?.cancel();
      state = state.copyWith(
        status: ScanStatus.error,
        errorType: ScanErrorType.generic,
        errorMessage: e.toString(),
      );
    }
  }

  /// Updates quantity and proportionally recalculates calories and macros.
  void updateItemQuantity(int index, double newQuantity) {
    if (index < 0 || index >= state.items.length) return;

    final current = state.items[index];
    final updated = current.rescaleQuantity(newQuantity);

    final updatedList = List<AiDetectedItemEntity>.from(state.items);
    updatedList[index] = updated;

    state = state.copyWith(items: updatedList);
  }

  /// Updates all attributes of an item.
  void updateItem(int index, AiDetectedItemEntity updatedItem) {
    if (index < 0 || index >= state.items.length) return;

    final updatedList = List<AiDetectedItemEntity>.from(state.items);
    updatedList[index] = updatedItem;

    state = state.copyWith(items: updatedList);
  }

  /// Removes a detected food item.
  void removeItem(int index) {
    if (index < 0 || index >= state.items.length) return;

    final updatedList = List<AiDetectedItemEntity>.from(state.items);
    updatedList.removeAt(index);

    state = state.copyWith(items: updatedList);
  }

  /// Adds a new food item to the detected items list.
  void addItem(AiDetectedItemEntity newItem) {
    state = state.copyWith(items: [...state.items, newItem]);
  }

  /// Saves the meal to the user's log via POST /meals with source=ai.
  Future<bool> saveMeal() async {
    if (state.items.isEmpty) return false;

    state = state.copyWith(isSaving: true);

    try {
      final now = DateTime.now();
      final dateString = DateFormat('yyyy-MM-dd').format(now);
      final timeString = DateFormat('HH:mm:ss').format(now);

      final mealItems = state.items.map((item) {
        return MealItemEntity(
          foodName: item.name,
          quantity: item.quantity,
          unit: item.unit,
          calories: item.calories,
          protein: item.protein,
          carbs: item.carbs,
          fat: item.fat,
        );
      }).toList();

      final meal = MealEntity(
        mealType: state.mealType,
        mealDate: dateString,
        mealTime: timeString,
        totalCalories: state.totalCalories,
        totalProtein: state.totalProtein,
        totalCarbs: state.totalCarbs,
        totalFat: state.totalFat,
        source: 'ai',
        analysisId: state.analysisResult?.analysisId,
        items: mealItems,
      );

      await _mealRepo.createMeal(meal);

      // Refresh Dashboard and Meals Tab
      ref.invalidate(dashboardProvider);
      ref.invalidate(mealsTabProvider);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
      return false;
    }
  }
}

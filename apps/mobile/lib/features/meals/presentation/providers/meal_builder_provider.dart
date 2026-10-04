import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository_interface.dart';
import 'meals_tab_provider.dart';

class MealBuilderState {
  final int? mealId;
  final String mealType;
  final DateTime mealDate;
  final TimeOfDay mealTime;
  final List<MealItemEntity> items;
  final bool isSaving;
  final bool isSaved;
  final String? errorMessage;

  const MealBuilderState({
    this.mealId,
    this.mealType = 'breakfast',
    required this.mealDate,
    required this.mealTime,
    this.items = const [],
    this.isSaving = false,
    this.isSaved = false,
    this.errorMessage,
  });

  int get totalCalories => items.fold(0, (sum, i) => sum + i.calories);
  double get totalProtein => items.fold(0.0, (sum, i) => sum + i.protein);
  double get totalCarbs => items.fold(0.0, (sum, i) => sum + i.carbs);
  double get totalFat => items.fold(0.0, (sum, i) => sum + i.fat);
  double get totalFiber => items.fold(0.0, (sum, i) => sum + i.fiber);

  bool get isEditMode => mealId != null;

  MealBuilderState copyWith({
    int? mealId,
    String? mealType,
    DateTime? mealDate,
    TimeOfDay? mealTime,
    List<MealItemEntity>? items,
    bool? isSaving,
    bool? isSaved,
    String? errorMessage,
  }) {
    return MealBuilderState(
      mealId: mealId ?? this.mealId,
      mealType: mealType ?? this.mealType,
      mealDate: mealDate ?? this.mealDate,
      mealTime: mealTime ?? this.mealTime,
      items: items ?? this.items,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }
}

final mealBuilderProvider =
    NotifierProvider<MealBuilderNotifier, MealBuilderState>(MealBuilderNotifier.new);

class MealBuilderNotifier extends Notifier<MealBuilderState> {
  @override
  MealBuilderState build() {
    final now = DateTime.now();
    return MealBuilderState(
      mealDate: DateTime(now.year, now.month, now.day),
      mealTime: TimeOfDay.fromDateTime(now),
    );
  }

  IMealRepository get _repo => ref.read(mealRepositoryProvider);

  void setMealType(String type) {
    state = state.copyWith(mealType: type);
  }

  void setMealDate(DateTime date) {
    state = state.copyWith(mealDate: date);
  }

  void setMealTime(TimeOfDay time) {
    state = state.copyWith(mealTime: time);
  }

  void addItem(MealItemEntity item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  void removeItem(int index) {
    if (index >= 0 && index < state.items.length) {
      final updated = List<MealItemEntity>.from(state.items)..removeAt(index);
      state = state.copyWith(items: updated);
    }
  }

  void loadForEdit(MealEntity meal) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(meal.mealDate);
    } catch (_) {
      parsedDate = DateTime.now();
    }

    TimeOfDay parsedTime;
    try {
      final parts = meal.mealTime.split(':');
      parsedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (_) {
      parsedTime = TimeOfDay.now();
    }

    state = MealBuilderState(
      mealId: meal.id,
      mealType: meal.mealType,
      mealDate: parsedDate,
      mealTime: parsedTime,
      items: meal.items,
    );
  }

  void duplicate(MealEntity meal) {
    final now = DateTime.now();
    state = MealBuilderState(
      mealId: null,
      mealType: meal.mealType,
      mealDate: DateTime(now.year, now.month, now.day),
      mealTime: TimeOfDay.fromDateTime(now),
      items: meal.items.map((i) => i.copyWith(id: null)).toList(),
    );
  }

  void reset() {
    final now = DateTime.now();
    state = MealBuilderState(
      mealDate: DateTime(now.year, now.month, now.day),
      mealTime: TimeOfDay.fromDateTime(now),
    );
  }

  Future<bool> saveMeal() async {
    if (state.items.isEmpty) {
      state = state.copyWith(errorMessage: 'Please add at least one food item.');
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final dateString = DateFormat('yyyy-MM-dd').format(state.mealDate);
      final hour = state.mealTime.hour.toString().padLeft(2, '0');
      final minute = state.mealTime.minute.toString().padLeft(2, '0');
      final timeString = '$hour:$minute:00';

      final mealToSave = MealEntity(
        id: state.mealId,
        mealType: state.mealType,
        mealDate: dateString,
        mealTime: timeString,
        totalCalories: state.totalCalories,
        totalProtein: state.totalProtein,
        totalCarbs: state.totalCarbs,
        totalFat: state.totalFat,
        totalFiber: state.totalFiber,
        items: state.items,
      );

      if (state.isEditMode) {
        await _repo.updateMeal(mealToSave);
      } else {
        await _repo.createMeal(mealToSave);
      }

      state = state.copyWith(isSaving: false, isSaved: true);

      // Refresh meals list if present
      ref.invalidate(mealsTabProvider);

      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
      return false;
    }
  }
}

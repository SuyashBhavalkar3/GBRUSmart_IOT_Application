import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StarDeltaTimerState {
  final int timerValue;
  final int? selectedPreset;
  final bool isLoading;

  const StarDeltaTimerState({
    required this.timerValue,
    this.selectedPreset,
    this.isLoading = false,
  });

  StarDeltaTimerState copyWith({
    int? timerValue,
    int? selectedPreset,
    bool? isLoading,
    bool clearPreset = false,
  }) {
    return StarDeltaTimerState(
      timerValue: timerValue ?? this.timerValue,
      selectedPreset: clearPreset ? null : (selectedPreset ?? this.selectedPreset),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class StarDeltaTimerNotifier extends StateNotifier<StarDeltaTimerState> {
  StarDeltaTimerNotifier() : super(const StarDeltaTimerState(timerValue: 30, selectedPreset: 30));

  static const int minTimer = 5;
  static const int maxTimer = 60;

  void incrementTimer() {
    if (state.timerValue < maxTimer) {
      final newValue = state.timerValue + 1;
      _updateTimerValue(newValue);
    }
  }

  void decrementTimer() {
    if (state.timerValue > minTimer) {
      final newValue = state.timerValue - 1;
      _updateTimerValue(newValue);
    }
  }

  void setPreset(int value) {
    if (value >= minTimer && value <= maxTimer) {
      state = state.copyWith(timerValue: value, selectedPreset: value);
    }
  }

  void _updateTimerValue(int newValue) {
    // If the new value matches one of the presets, select it. Otherwise, clear the preset selection.
    int? matchedPreset;
    if ([10, 20, 30, 45].contains(newValue)) {
      matchedPreset = newValue;
    }
    state = state.copyWith(
      timerValue: newValue,
      selectedPreset: matchedPreset,
      clearPreset: matchedPreset == null,
    );
  }

  Future<void> saveSettings(VoidCallback onSuccess) async {
    state = state.copyWith(isLoading: true);
    // Simulate network or save delay
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isLoading: false);
    onSuccess();
  }
}

final starDeltaTimerProvider = StateNotifierProvider<StarDeltaTimerNotifier, StarDeltaTimerState>((ref) {
  return StarDeltaTimerNotifier();
});

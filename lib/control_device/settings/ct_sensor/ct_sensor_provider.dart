import 'package:flutter_riverpod/flutter_riverpod.dart';

class CtSensorState {
  final int selectedCt;
  final bool isLoading;

  const CtSensorState({
    required this.selectedCt,
    this.isLoading = false,
  });

  CtSensorState copyWith({
    int? selectedCt,
    bool? isLoading,
  }) {
    return CtSensorState(
      selectedCt: selectedCt ?? this.selectedCt,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CtSensorNotifier extends StateNotifier<CtSensorState> {
  CtSensorNotifier() : super(const CtSensorState(selectedCt: 30));

  void setCtRating(int rating) {
    if ([30, 60, 100].contains(rating)) {
      state = state.copyWith(selectedCt: rating);
    }
  }

  bool _isSaving = false;
  bool _isCancelled = false;
  bool _hasFailedOnce = false; // Simulate failure on first attempt

  void cancelSave() {
    _isCancelled = true;
  }

  Future<bool> saveSettings() async {
    if (_isSaving) return false;
    _isSaving = true;
    _isCancelled = false;
    
    state = state.copyWith(isLoading: true);
    
    // Simulate network delay (3 seconds) in chunks to allow early cancellation
    for (int i = 0; i < 30; i++) {
      if (_isCancelled) {
        _isSaving = false;
        state = state.copyWith(isLoading: false);
        return false; // Return false but this was cancelled, so it won't show error dialog
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    _isSaving = false;
    state = state.copyWith(isLoading: false);
    
    if (!_hasFailedOnce) {
      _hasFailedOnce = true;
      return false; // Failed
    }
    
    return true; // Success on subsequent attempts
  }
}

final ctSensorProvider = StateNotifierProvider<CtSensorNotifier, CtSensorState>((ref) {
  return CtSensorNotifier();
});

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentSettingsState {
  final double lowCurrentLimit;
  final double highCurrentLimit;
  final bool isSending;
  final bool showSuccess;
  final bool showFailure;
  final bool simulateFailure;

  CurrentSettingsState({
    this.lowCurrentLimit = 4.5,
    this.highCurrentLimit = 7.0,
    this.isSending = false,
    this.showSuccess = false,
    this.showFailure = false,
    this.simulateFailure = false,
  });

  CurrentSettingsState copyWith({
    double? lowCurrentLimit,
    double? highCurrentLimit,
    bool? isSending,
    bool? showSuccess,
    bool? showFailure,
    bool? simulateFailure,
  }) {
    return CurrentSettingsState(
      lowCurrentLimit: lowCurrentLimit ?? this.lowCurrentLimit,
      highCurrentLimit: highCurrentLimit ?? this.highCurrentLimit,
      isSending: isSending ?? this.isSending,
      showSuccess: showSuccess ?? this.showSuccess,
      showFailure: showFailure ?? this.showFailure,
      simulateFailure: simulateFailure ?? this.simulateFailure,
    );
  }
}

class CurrentSettingsNotifier extends StateNotifier<CurrentSettingsState> {
  CurrentSettingsNotifier() : super(CurrentSettingsState());

  Timer? _smsTimer;

  void incrementLowCurrent() {
    if (state.lowCurrentLimit < state.highCurrentLimit - 0.5) {
      state = state.copyWith(lowCurrentLimit: state.lowCurrentLimit + 0.5);
    }
  }

  void decrementLowCurrent() {
    if (state.lowCurrentLimit > 0.5) {
      state = state.copyWith(lowCurrentLimit: state.lowCurrentLimit - 0.5);
    }
  }

  void incrementHighCurrent() {
    if (state.highCurrentLimit < 15.0) {
      state = state.copyWith(highCurrentLimit: state.highCurrentLimit + 0.5);
    }
  }

  void decrementHighCurrent() {
    if (state.highCurrentLimit > state.lowCurrentLimit + 0.5) {
      state = state.copyWith(highCurrentLimit: state.highCurrentLimit - 0.5);
    }
  }

  void toggleSimulateFailure(bool value) {
    state = state.copyWith(simulateFailure: value);
  }

  Future<void> sendCurrentCommand() async {
    _smsTimer?.cancel();
    state = state.copyWith(
      isSending: true,
      showSuccess: false,
      showFailure: false,
    );

    _smsTimer = Timer(const Duration(seconds: 3), () {
      if (state.simulateFailure) {
        state = state.copyWith(isSending: false, showFailure: true);
      } else {
        state = state.copyWith(isSending: false, showSuccess: true);
      }
    });
  }

  void cancelCurrentCommand() {
    _smsTimer?.cancel();
    state = state.copyWith(
      isSending: false,
      showSuccess: false,
      showFailure: false,
    );
  }

  void retryCurrentCommand() {
    sendCurrentCommand();
  }

  void dismissCurrentSuccessDialog() {
    state = state.copyWith(showSuccess: false);
  }

  void dismissCurrentFailureDialog() {
    state = state.copyWith(showFailure: false);
  }

  @override
  void dispose() {
    _smsTimer?.cancel();
    super.dispose();
  }
}

final currentSettingsProvider =
    StateNotifierProvider<CurrentSettingsNotifier, CurrentSettingsState>((ref) {
      return CurrentSettingsNotifier();
    });

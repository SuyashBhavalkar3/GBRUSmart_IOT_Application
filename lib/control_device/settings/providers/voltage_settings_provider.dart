import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoltageSettingsState {
  final int voltageValue;
  final bool isSending;
  final bool showSuccess;
  final bool showFailure;
  final bool simulateFailure;

  VoltageSettingsState({
    this.voltageValue = 230,
    this.isSending = false,
    this.showSuccess = false,
    this.showFailure = false,
    this.simulateFailure = false,
  });

  VoltageSettingsState copyWith({
    int? voltageValue,
    bool? isSending,
    bool? showSuccess,
    bool? showFailure,
    bool? simulateFailure,
  }) {
    return VoltageSettingsState(
      voltageValue: voltageValue ?? this.voltageValue,
      isSending: isSending ?? this.isSending,
      showSuccess: showSuccess ?? this.showSuccess,
      showFailure: showFailure ?? this.showFailure,
      simulateFailure: simulateFailure ?? this.simulateFailure,
    );
  }
}

class VoltageSettingsNotifier extends StateNotifier<VoltageSettingsState> {
  VoltageSettingsNotifier() : super(VoltageSettingsState());

  Timer? _smsTimer;

  void incrementVoltage() {
    if (state.voltageValue < 440) {
      state = state.copyWith(voltageValue: state.voltageValue + 5);
    }
  }

  void decrementVoltage() {
    if (state.voltageValue > 110) {
      state = state.copyWith(voltageValue: state.voltageValue - 5);
    }
  }

  void setPresetVoltage(int value) {
    if (value >= 110 && value <= 440) {
      state = state.copyWith(voltageValue: value);
    }
  }

  void toggleSimulateFailure(bool value) {
    state = state.copyWith(simulateFailure: value);
  }

  Future<void> sendVoltageCommand() async {
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

  void cancelVoltageCommand() {
    _smsTimer?.cancel();
    state = state.copyWith(
      isSending: false,
      showSuccess: false,
      showFailure: false,
    );
  }

  void retryVoltageCommand() {
    sendVoltageCommand();
  }

  void dismissVoltageSuccessDialog() {
    state = state.copyWith(showSuccess: false);
  }

  void dismissVoltageFailureDialog() {
    state = state.copyWith(showFailure: false);
  }

  @override
  void dispose() {
    _smsTimer?.cancel();
    super.dispose();
  }
}

final voltageSettingsProvider =
    StateNotifierProvider<VoltageSettingsNotifier, VoltageSettingsState>((ref) {
      return VoltageSettingsNotifier();
    });

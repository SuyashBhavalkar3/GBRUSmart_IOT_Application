import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/automation_state.dart';

class AutomationNotifier extends StateNotifier<AutomationState> {
  AutomationNotifier()
      : super(AutomationState(
          autoStartEnabled: false,
          autoStartDelay: 35,
          runOnceTimerEnabled: false,
          dailyScheduleEnabled: false,
          dailyScheduleStatus: "Active – Running for 5 days",
          cyclicModeEnabled: false,
          cyclicModeStatus: "Inactive",
        ));

  Timer? _simulatedSmsTimer;

  void toggleAutoStart(bool value) {
    state = state.copyWith(autoStartEnabled: value);
  }

  void toggleRunOnceTimer(bool value) {
    state = state.copyWith(runOnceTimerEnabled: value);
  }

  void toggleDailySchedule(bool value) {
    state = state.copyWith(
      dailyScheduleEnabled: value,
      dailyScheduleStatus: value ? "Active – Running for 5 days" : "Inactive",
    );
  }

  void toggleCyclicMode(bool value) {
    state = state.copyWith(
      cyclicModeEnabled: value,
      cyclicModeStatus: value ? "Active" : "Inactive",
    );
  }

  // Auto Start delay configurations
  void incrementDelay() {
    state = state.copyWith(autoStartDelay: state.autoStartDelay + 5);
  }

  void decrementDelay() {
    if (state.autoStartDelay > 5) {
      state = state.copyWith(autoStartDelay: state.autoStartDelay - 5);
    }
  }

  void setPresetDelay(int delay) {
    state = state.copyWith(autoStartDelay: delay);
  }

  void toggleSimulateFailure(bool value) {
    state = state.copyWith(simulateFailure: value);
  }

  // Simulated SMS update action
  Future<void> sendAutoStartCommand() async {
    _simulatedSmsTimer?.cancel();
    state = state.copyWith(
      isSendingCommand: true,
      showSuccessDialog: false,
      showFailureDialog: false,
    );

    // Simulate 3 seconds SMS transmission delay
    _simulatedSmsTimer = Timer(const Duration(seconds: 3), () {
      if (state.simulateFailure) {
        state = state.copyWith(
          isSendingCommand: false,
          showFailureDialog: true,
        );
      } else {
        state = state.copyWith(
          isSendingCommand: false,
          showSuccessDialog: true,
        );
      }
    });
  }

  void cancelCommand() {
    _simulatedSmsTimer?.cancel();
    state = state.copyWith(
      isSendingCommand: false,
      showSuccessDialog: false,
      showFailureDialog: false,
    );
  }

  void retryCommand() {
    sendAutoStartCommand();
  }

  void dismissSuccessDialog() {
    state = state.copyWith(showSuccessDialog: false);
  }

  void dismissFailureDialog() {
    state = state.copyWith(showFailureDialog: false);
  }

  @override
  void dispose() {
    _simulatedSmsTimer?.cancel();
    super.dispose();
  }
}

final automationProvider =
    StateNotifierProvider<AutomationNotifier, AutomationState>((ref) {
  return AutomationNotifier();
});

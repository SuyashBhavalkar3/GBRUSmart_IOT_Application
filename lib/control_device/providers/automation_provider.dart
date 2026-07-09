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
  Timer? _runOnceSmsTimer;

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

  // Run Once configurations
  void incrementHours() {
    state = state.copyWith(runOnceHours: state.runOnceHours + 1);
  }

  void decrementHours() {
    if (state.runOnceHours > 0) {
      state = state.copyWith(runOnceHours: state.runOnceHours - 1);
    }
  }

  void incrementMinutes() {
    if (state.runOnceMinutes < 55) {
      state = state.copyWith(runOnceMinutes: state.runOnceMinutes + 5);
    } else {
      state = state.copyWith(
        runOnceHours: state.runOnceHours + 1,
        runOnceMinutes: 0,
      );
    }
  }

  void decrementMinutes() {
    if (state.runOnceMinutes >= 5) {
      state = state.copyWith(runOnceMinutes: state.runOnceMinutes - 5);
    } else if (state.runOnceHours > 0) {
      state = state.copyWith(
        runOnceHours: state.runOnceHours - 1,
        runOnceMinutes: 55,
      );
    }
  }

  // Simulated SMS updates for Auto Start config
  Future<void> sendAutoStartCommand() async {
    _simulatedSmsTimer?.cancel();
    state = state.copyWith(
      isSendingCommand: true,
      showSuccessDialog: false,
      showFailureDialog: false,
    );

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

  // Simulated SMS updates for Run Once Timer config
  Future<void> sendRunOnceCommand() async {
    _runOnceSmsTimer?.cancel();
    state = state.copyWith(
      runOnceSendingCommand: true,
      runOnceShowSuccess: false,
      runOnceShowFailure: false,
    );

    _runOnceSmsTimer = Timer(const Duration(seconds: 3), () {
      if (state.simulateFailure) {
        state = state.copyWith(
          runOnceSendingCommand: false,
          runOnceShowFailure: true,
        );
      } else {
        state = state.copyWith(
          runOnceSendingCommand: false,
          runOnceShowSuccess: true,
          runOnceTimerEnabled: true, // Automatically enable run once timer state
        );
      }
    });
  }

  void cancelRunOnceCommand() {
    _runOnceSmsTimer?.cancel();
    state = state.copyWith(
      runOnceSendingCommand: false,
      runOnceShowSuccess: false,
      runOnceShowFailure: false,
    );
  }

  void retryRunOnceCommand() {
    sendRunOnceCommand();
  }

  void dismissRunOnceSuccessDialog() {
    state = state.copyWith(runOnceShowSuccess: false);
  }

  void dismissRunOnceFailureDialog() {
    state = state.copyWith(runOnceShowFailure: false);
  }

  @override
  void dispose() {
    _simulatedSmsTimer?.cancel();
    _runOnceSmsTimer?.cancel();
    super.dispose();
  }
}

final automationProvider =
    StateNotifierProvider<AutomationNotifier, AutomationState>((ref) {
  return AutomationNotifier();
});

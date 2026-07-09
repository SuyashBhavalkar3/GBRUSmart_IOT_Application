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
  Timer? _dailySmsTimer;
  Timer? _cyclicSmsTimer;

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

  // Daily Schedule configurations
  void updateScheduleName(String name) {
    state = state.copyWith(scheduleName: name);
  }

  void incrementScheduleHours() {
    state = state.copyWith(scheduleHours: state.scheduleHours + 1);
  }

  void decrementScheduleHours() {
    if (state.scheduleHours > 0) {
      state = state.copyWith(scheduleHours: state.scheduleHours - 1);
    }
  }

  void incrementScheduleMinutes() {
    if (state.scheduleMinutes < 55) {
      state = state.copyWith(scheduleMinutes: state.scheduleMinutes + 5);
    } else {
      state = state.copyWith(
        scheduleHours: state.scheduleHours + 1,
        scheduleMinutes: 0,
      );
    }
  }

  void decrementScheduleMinutes() {
    if (state.scheduleMinutes >= 5) {
      state = state.copyWith(scheduleMinutes: state.scheduleMinutes - 5);
    } else if (state.scheduleHours > 0) {
      state = state.copyWith(
        scheduleHours: state.scheduleHours - 1,
        scheduleMinutes: 55,
      );
    }
  }

  void incrementScheduleDays() {
    if (state.scheduleDays < 30) {
      state = state.copyWith(scheduleDays: state.scheduleDays + 1);
    }
  }

  void decrementScheduleDays() {
    if (state.scheduleDays > 1) {
      state = state.copyWith(scheduleDays: state.scheduleDays - 1);
    }
  }

  void toggleDryRunProtection(bool value) {
    state = state.copyWith(dryRunProtectionEnabled: value);
  }

  void deleteDailySchedule() {
    state = state.copyWith(
      dailyScheduleCreated: false,
      dailyScheduleEnabled: false,
    );
  }

  // Cyclic Mode configurations
  void incrementCyclicRunHours() {
    state = state.copyWith(cyclicRunHours: state.cyclicRunHours + 1);
  }

  void decrementCyclicRunHours() {
    if (state.cyclicRunHours > 0) {
      state = state.copyWith(cyclicRunHours: state.cyclicRunHours - 1);
    }
  }

  void incrementCyclicRunMinutes() {
    if (state.cyclicRunMinutes < 55) {
      state = state.copyWith(cyclicRunMinutes: state.cyclicRunMinutes + 5);
    } else {
      state = state.copyWith(
        cyclicRunHours: state.cyclicRunHours + 1,
        cyclicRunMinutes: 0,
      );
    }
  }

  void decrementCyclicRunMinutes() {
    if (state.cyclicRunMinutes >= 5) {
      state = state.copyWith(cyclicRunMinutes: state.cyclicRunMinutes - 5);
    } else if (state.cyclicRunHours > 0) {
      state = state.copyWith(
        cyclicRunHours: state.cyclicRunHours - 1,
        cyclicRunMinutes: 55,
      );
    }
  }

  void incrementCyclicPauseHours() {
    state = state.copyWith(cyclicPauseHours: state.cyclicPauseHours + 1);
  }

  void decrementCyclicPauseHours() {
    if (state.cyclicPauseHours > 0) {
      state = state.copyWith(cyclicPauseHours: state.cyclicPauseHours - 1);
    }
  }

  void incrementCyclicPauseMinutes() {
    if (state.cyclicPauseMinutes < 55) {
      state = state.copyWith(cyclicPauseMinutes: state.cyclicPauseMinutes + 5);
    } else {
      state = state.copyWith(
        cyclicPauseHours: state.cyclicPauseHours + 1,
        cyclicPauseMinutes: 0,
      );
    }
  }

  void decrementCyclicPauseMinutes() {
    if (state.cyclicPauseMinutes >= 5) {
      state = state.copyWith(cyclicPauseMinutes: state.cyclicPauseMinutes - 5);
    } else if (state.cyclicPauseHours > 0) {
      state = state.copyWith(
        cyclicPauseHours: state.cyclicPauseHours - 1,
        cyclicPauseMinutes: 55,
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
          runOnceTimerEnabled: true,
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

  // Simulated SMS updates for Daily Schedule config
  Future<void> sendDailyScheduleCommand() async {
    _dailySmsTimer?.cancel();
    state = state.copyWith(
      dailySendingCommand: true,
      dailyShowSuccess: false,
      dailyShowFailure: false,
    );

    _dailySmsTimer = Timer(const Duration(seconds: 3), () {
      if (state.simulateFailure) {
        state = state.copyWith(
          dailySendingCommand: false,
          dailyShowFailure: true,
        );
      } else {
        state = state.copyWith(
          dailySendingCommand: false,
          dailyShowSuccess: true,
          dailyScheduleCreated: true,
          dailyScheduleEnabled: true,
          dailyScheduleStatus: "Active – Running for ${state.scheduleDays} days",
        );
      }
    });
  }

  void cancelDailyScheduleCommand() {
    _dailySmsTimer?.cancel();
    state = state.copyWith(
      dailySendingCommand: false,
      dailyShowSuccess: false,
      dailyShowFailure: false,
    );
  }

  void retryDailyScheduleCommand() {
    sendDailyScheduleCommand();
  }

  void dismissDailySuccessDialog() {
    state = state.copyWith(dailyShowSuccess: false);
  }

  void dismissDailyFailureDialog() {
    state = state.copyWith(dailyShowFailure: false);
  }

  // Simulated SMS updates for Cyclic Mode config
  Future<void> sendCyclicCommand() async {
    _cyclicSmsTimer?.cancel();
    state = state.copyWith(
      cyclicSendingCommand: true,
      cyclicShowSuccess: false,
      cyclicShowFailure: false,
    );

    _cyclicSmsTimer = Timer(const Duration(seconds: 3), () {
      if (state.simulateFailure) {
        state = state.copyWith(
          cyclicSendingCommand: false,
          cyclicShowFailure: true,
        );
      } else {
        state = state.copyWith(
          cyclicSendingCommand: false,
          cyclicShowSuccess: true,
          cyclicModeEnabled: true,
          cyclicModeStatus: "Active",
        );
      }
    });
  }

  void cancelCyclicCommand() {
    _cyclicSmsTimer?.cancel();
    state = state.copyWith(
      cyclicSendingCommand: false,
      cyclicShowSuccess: false,
      cyclicShowFailure: false,
    );
  }

  void retryCyclicCommand() {
    sendCyclicCommand();
  }

  void dismissCyclicSuccessDialog() {
    state = state.copyWith(cyclicShowSuccess: false);
  }

  void dismissCyclicFailureDialog() {
    state = state.copyWith(cyclicShowFailure: false);
  }

  @override
  void dispose() {
    _simulatedSmsTimer?.cancel();
    _runOnceSmsTimer?.cancel();
    _dailySmsTimer?.cancel();
    _cyclicSmsTimer?.cancel();
    super.dispose();
  }
}

final automationProvider =
    StateNotifierProvider<AutomationNotifier, AutomationState>((ref) {
  return AutomationNotifier();
});

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
}

final automationProvider =
    StateNotifierProvider<AutomationNotifier, AutomationState>((ref) {
  return AutomationNotifier();
});

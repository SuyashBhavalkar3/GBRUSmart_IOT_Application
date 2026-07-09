class AutomationState {
  final bool autoStartEnabled;
  final int autoStartDelay;
  final bool runOnceTimerEnabled;
  final bool dailyScheduleEnabled;
  final String dailyScheduleStatus;
  final bool cyclicModeEnabled;
  final String cyclicModeStatus;

  // Command status flags for simulated SMS updates
  final bool isSendingCommand;
  final bool showSuccessDialog;
  final bool showFailureDialog;
  final bool simulateFailure;

  AutomationState({
    required this.autoStartEnabled,
    required this.autoStartDelay,
    required this.runOnceTimerEnabled,
    required this.dailyScheduleEnabled,
    required this.dailyScheduleStatus,
    required this.cyclicModeEnabled,
    required this.cyclicModeStatus,
    this.isSendingCommand = false,
    this.showSuccessDialog = false,
    this.showFailureDialog = false,
    this.simulateFailure = false,
  });

  AutomationState copyWith({
    bool? autoStartEnabled,
    int? autoStartDelay,
    bool? runOnceTimerEnabled,
    bool? dailyScheduleEnabled,
    String? dailyScheduleStatus,
    bool? cyclicModeEnabled,
    String? cyclicModeStatus,
    bool? isSendingCommand,
    bool? showSuccessDialog,
    bool? showFailureDialog,
    bool? simulateFailure,
  }) {
    return AutomationState(
      autoStartEnabled: autoStartEnabled ?? this.autoStartEnabled,
      autoStartDelay: autoStartDelay ?? this.autoStartDelay,
      runOnceTimerEnabled: runOnceTimerEnabled ?? this.runOnceTimerEnabled,
      dailyScheduleEnabled: dailyScheduleEnabled ?? this.dailyScheduleEnabled,
      dailyScheduleStatus: dailyScheduleStatus ?? this.dailyScheduleStatus,
      cyclicModeEnabled: cyclicModeEnabled ?? this.cyclicModeEnabled,
      cyclicModeStatus: cyclicModeStatus ?? this.cyclicModeStatus,
      isSendingCommand: isSendingCommand ?? this.isSendingCommand,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
      showFailureDialog: showFailureDialog ?? this.showFailureDialog,
      simulateFailure: simulateFailure ?? this.simulateFailure,
    );
  }
}

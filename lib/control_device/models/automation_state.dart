class AutomationState {
  final bool autoStartEnabled;
  final int autoStartDelay;
  final bool runOnceTimerEnabled;
  final bool dailyScheduleEnabled;
  final String dailyScheduleStatus;
  final bool cyclicModeEnabled;
  final String cyclicModeStatus;

  // Run Once Timer Configs
  final int runOnceHours;
  final int runOnceMinutes;

  // Command status flags for simulated SMS updates
  final bool isSendingCommand;
  final bool showSuccessDialog;
  final bool showFailureDialog;
  final bool simulateFailure;

  // Run Once specific dialog status flags
  final bool runOnceSendingCommand;
  final bool runOnceShowSuccess;
  final bool runOnceShowFailure;

  AutomationState({
    required this.autoStartEnabled,
    required this.autoStartDelay,
    required this.runOnceTimerEnabled,
    required this.dailyScheduleEnabled,
    required this.dailyScheduleStatus,
    required this.cyclicModeEnabled,
    required this.cyclicModeStatus,
    this.runOnceHours = 4,
    this.runOnceMinutes = 30,
    this.isSendingCommand = false,
    this.showSuccessDialog = false,
    this.showFailureDialog = false,
    this.simulateFailure = false,
    this.runOnceSendingCommand = false,
    this.runOnceShowSuccess = false,
    this.runOnceShowFailure = false,
  });

  AutomationState copyWith({
    bool? autoStartEnabled,
    int? autoStartDelay,
    bool? runOnceTimerEnabled,
    bool? dailyScheduleEnabled,
    String? dailyScheduleStatus,
    bool? cyclicModeEnabled,
    String? cyclicModeStatus,
    int? runOnceHours,
    int? runOnceMinutes,
    bool? isSendingCommand,
    bool? showSuccessDialog,
    bool? showFailureDialog,
    bool? simulateFailure,
    bool? runOnceSendingCommand,
    bool? runOnceShowSuccess,
    bool? runOnceShowFailure,
  }) {
    return AutomationState(
      autoStartEnabled: autoStartEnabled ?? this.autoStartEnabled,
      autoStartDelay: autoStartDelay ?? this.autoStartDelay,
      runOnceTimerEnabled: runOnceTimerEnabled ?? this.runOnceTimerEnabled,
      dailyScheduleEnabled: dailyScheduleEnabled ?? this.dailyScheduleEnabled,
      dailyScheduleStatus: dailyScheduleStatus ?? this.dailyScheduleStatus,
      cyclicModeEnabled: cyclicModeEnabled ?? this.cyclicModeEnabled,
      cyclicModeStatus: cyclicModeStatus ?? this.cyclicModeStatus,
      runOnceHours: runOnceHours ?? this.runOnceHours,
      runOnceMinutes: runOnceMinutes ?? this.runOnceMinutes,
      isSendingCommand: isSendingCommand ?? this.isSendingCommand,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
      showFailureDialog: showFailureDialog ?? this.showFailureDialog,
      simulateFailure: simulateFailure ?? this.simulateFailure,
      runOnceSendingCommand: runOnceSendingCommand ?? this.runOnceSendingCommand,
      runOnceShowSuccess: runOnceShowSuccess ?? this.runOnceShowSuccess,
      runOnceShowFailure: runOnceShowFailure ?? this.runOnceShowFailure,
    );
  }
}

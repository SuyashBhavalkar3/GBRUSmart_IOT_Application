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

  // Daily Schedule Configs
  final bool dailyScheduleCreated;
  final String scheduleName;
  final int scheduleHours;
  final int scheduleMinutes;
  final int scheduleDays;
  final bool dryRunProtectionEnabled;

  // Command status flags for simulated SMS updates
  final bool isSendingCommand;
  final bool showSuccessDialog;
  final bool showFailureDialog;
  final bool simulateFailure;

  // Run Once specific dialog status flags
  final bool runOnceSendingCommand;
  final bool runOnceShowSuccess;
  final bool runOnceShowFailure;

  // Daily Schedule specific dialog status flags
  final bool dailySendingCommand;
  final bool dailyShowSuccess;
  final bool dailyShowFailure;

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
    this.dailyScheduleCreated = false,
    this.scheduleName = "Morning Irrigation",
    this.scheduleHours = 4,
    this.scheduleMinutes = 30,
    this.scheduleDays = 5,
    this.dryRunProtectionEnabled = true,
    this.isSendingCommand = false,
    this.showSuccessDialog = false,
    this.showFailureDialog = false,
    this.simulateFailure = false,
    this.runOnceSendingCommand = false,
    this.runOnceShowSuccess = false,
    this.runOnceShowFailure = false,
    this.dailySendingCommand = false,
    this.dailyShowSuccess = false,
    this.dailyShowFailure = false,
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
    bool? dailyScheduleCreated,
    String? scheduleName,
    int? scheduleHours,
    int? scheduleMinutes,
    int? scheduleDays,
    bool? dryRunProtectionEnabled,
    bool? isSendingCommand,
    bool? showSuccessDialog,
    bool? showFailureDialog,
    bool? simulateFailure,
    bool? runOnceSendingCommand,
    bool? runOnceShowSuccess,
    bool? runOnceShowFailure,
    bool? dailySendingCommand,
    bool? dailyShowSuccess,
    bool? dailyShowFailure,
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
      dailyScheduleCreated: dailyScheduleCreated ?? this.dailyScheduleCreated,
      scheduleName: scheduleName ?? this.scheduleName,
      scheduleHours: scheduleHours ?? this.scheduleHours,
      scheduleMinutes: scheduleMinutes ?? this.scheduleMinutes,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      dryRunProtectionEnabled: dryRunProtectionEnabled ?? this.dryRunProtectionEnabled,
      isSendingCommand: isSendingCommand ?? this.isSendingCommand,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
      showFailureDialog: showFailureDialog ?? this.showFailureDialog,
      simulateFailure: simulateFailure ?? this.simulateFailure,
      runOnceSendingCommand: runOnceSendingCommand ?? this.runOnceSendingCommand,
      runOnceShowSuccess: runOnceShowSuccess ?? this.runOnceShowSuccess,
      runOnceShowFailure: runOnceShowFailure ?? this.runOnceShowFailure,
      dailySendingCommand: dailySendingCommand ?? this.dailySendingCommand,
      dailyShowSuccess: dailyShowSuccess ?? this.dailyShowSuccess,
      dailyShowFailure: dailyShowFailure ?? this.dailyShowFailure,
    );
  }
}

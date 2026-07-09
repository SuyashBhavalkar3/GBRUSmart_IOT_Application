class AutomationState {
  final bool autoStartEnabled;
  final int autoStartDelay;
  final bool runOnceTimerEnabled;
  final bool dailyScheduleEnabled;
  final String dailyScheduleStatus;
  final bool cyclicModeEnabled;
  final String cyclicModeStatus;

  AutomationState({
    required this.autoStartEnabled,
    required this.autoStartDelay,
    required this.runOnceTimerEnabled,
    required this.dailyScheduleEnabled,
    required this.dailyScheduleStatus,
    required this.cyclicModeEnabled,
    required this.cyclicModeStatus,
  });

  AutomationState copyWith({
    bool? autoStartEnabled,
    int? autoStartDelay,
    bool? runOnceTimerEnabled,
    bool? dailyScheduleEnabled,
    String? dailyScheduleStatus,
    bool? cyclicModeEnabled,
    String? cyclicModeStatus,
  }) {
    return AutomationState(
      autoStartEnabled: autoStartEnabled ?? this.autoStartEnabled,
      autoStartDelay: autoStartDelay ?? this.autoStartDelay,
      runOnceTimerEnabled: runOnceTimerEnabled ?? this.runOnceTimerEnabled,
      dailyScheduleEnabled: dailyScheduleEnabled ?? this.dailyScheduleEnabled,
      dailyScheduleStatus: dailyScheduleStatus ?? this.dailyScheduleStatus,
      cyclicModeEnabled: cyclicModeEnabled ?? this.cyclicModeEnabled,
      cyclicModeStatus: cyclicModeStatus ?? this.cyclicModeStatus,
    );
  }
}

class DeviceState {
  final String name;
  final String type;
  final String serialNumber;
  final bool isMotorRunning;
  final String lastActionMessage;
  final DateTime lastActionTime;
  final bool isAutoModeOn;
  final bool isSendingCommand;
  final bool showSuccessDialog;
  final bool showFailureDialog;
  final String? lastAttemptedCommand; // 'START', 'STOP', 'CHECK', 'CALL'
  final bool simulateFailure; // For testing UI dialogs easily

  DeviceState({
    required this.name,
    required this.type,
    required this.serialNumber,
    required this.isMotorRunning,
    required this.lastActionMessage,
    required this.lastActionTime,
    required this.isAutoModeOn,
    required this.isSendingCommand,
    required this.showSuccessDialog,
    required this.showFailureDialog,
    this.lastAttemptedCommand,
    required this.simulateFailure,
  });

  DeviceState copyWith({
    String? name,
    String? type,
    String? serialNumber,
    bool? isMotorRunning,
    String? lastActionMessage,
    DateTime? lastActionTime,
    bool? isAutoModeOn,
    bool? isSendingCommand,
    bool? showSuccessDialog,
    bool? showFailureDialog,
    String? lastAttemptedCommand,
    bool? simulateFailure,
  }) {
    return DeviceState(
      name: name ?? this.name,
      type: type ?? this.type,
      serialNumber: serialNumber ?? this.serialNumber,
      isMotorRunning: isMotorRunning ?? this.isMotorRunning,
      lastActionMessage: lastActionMessage ?? this.lastActionMessage,
      lastActionTime: lastActionTime ?? this.lastActionTime,
      isAutoModeOn: isAutoModeOn ?? this.isAutoModeOn,
      isSendingCommand: isSendingCommand ?? this.isSendingCommand,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
      showFailureDialog: showFailureDialog ?? this.showFailureDialog,
      lastAttemptedCommand: lastAttemptedCommand ?? this.lastAttemptedCommand,
      simulateFailure: simulateFailure ?? this.simulateFailure,
    );
  }
}

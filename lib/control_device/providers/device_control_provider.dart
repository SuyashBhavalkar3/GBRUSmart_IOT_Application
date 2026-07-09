import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/device_state.dart';

class DeviceControlNotifier extends StateNotifier<DeviceState> {
  DeviceControlNotifier()
      : super(DeviceState(
          name: "GBRU Mobile Auto",
          type: "Borewell Pump",
          serialNumber: "MA-2024-45821",
          isMotorRunning: false,
          lastActionMessage: "Stop Motor",
          lastActionTime: DateTime.now().subtract(const Duration(hours: 1)),
          isAutoModeOn: true,
          isSendingCommand: false,
          showSuccessDialog: false,
          showFailureDialog: false,
          simulateFailure: false, // Default is successful commands
        ));

  Future<void> startMotor() async {
    if (state.isSendingCommand) return;
    state = state.copyWith(
      isSendingCommand: true,
      showSuccessDialog: false,
      showFailureDialog: false,
      lastAttemptedCommand: 'START',
    );
    
    await Future.delayed(const Duration(seconds: 3));
    if (!state.isSendingCommand) return; // Cancelled
    
    if (state.simulateFailure) {
      state = state.copyWith(
        isSendingCommand: false,
        showFailureDialog: true,
      );
    } else {
      state = state.copyWith(
        isMotorRunning: true,
        lastActionMessage: "Start Motor",
        lastActionTime: DateTime.now(),
        isSendingCommand: false,
        showSuccessDialog: true,
      );
    }
  }

  Future<void> stopMotor() async {
    if (state.isSendingCommand) return;
    state = state.copyWith(
      isSendingCommand: true,
      showSuccessDialog: false,
      showFailureDialog: false,
      lastAttemptedCommand: 'STOP',
    );
    
    await Future.delayed(const Duration(seconds: 3));
    if (!state.isSendingCommand) return; // Cancelled
    
    if (state.simulateFailure) {
      state = state.copyWith(
        isSendingCommand: false,
        showFailureDialog: true,
      );
    } else {
      state = state.copyWith(
        isMotorRunning: false,
        lastActionMessage: "Stop Motor",
        lastActionTime: DateTime.now(),
        isSendingCommand: false,
        showSuccessDialog: true,
      );
    }
  }

  void cancelCommand() {
    state = state.copyWith(
      isSendingCommand: false,
      showSuccessDialog: false,
      showFailureDialog: false,
    );
  }

  void dismissSuccessDialog() {
    state = state.copyWith(showSuccessDialog: false);
  }

  void dismissFailureDialog() {
    state = state.copyWith(showFailureDialog: false);
  }

  void toggleSimulateFailure(bool value) {
    state = state.copyWith(simulateFailure: value);
  }

  void toggleAutoMode(bool value) {
    state = state.copyWith(isAutoModeOn: value);
  }

  Future<void> retryLastCommand() async {
    dismissFailureDialog();
    final lastCmd = state.lastAttemptedCommand;
    if (lastCmd == 'START') {
      await startMotor();
    } else if (lastCmd == 'STOP') {
      await stopMotor();
    } else if (lastCmd == 'CHECK') {
      await checkStatus();
    } else if (lastCmd == 'CALL') {
      await callDevice();
    }
  }

  Future<void> checkStatus() async {
    if (state.isSendingCommand) return;
    state = state.copyWith(
      isSendingCommand: true,
      showSuccessDialog: false,
      showFailureDialog: false,
      lastAttemptedCommand: 'CHECK',
    );
    
    await Future.delayed(const Duration(seconds: 3));
    if (!state.isSendingCommand) return; // Cancelled
    
    if (state.simulateFailure) {
      state = state.copyWith(
        isSendingCommand: false,
        showFailureDialog: true,
      );
    } else {
      state = state.copyWith(
        lastActionMessage: "Status Checked",
        lastActionTime: DateTime.now(),
        isSendingCommand: false,
        showSuccessDialog: true,
      );
    }
  }

  Future<void> callDevice() async {
    if (state.isSendingCommand) return;
    state = state.copyWith(
      isSendingCommand: true,
      showSuccessDialog: false,
      showFailureDialog: false,
      lastAttemptedCommand: 'CALL',
    );
    
    await Future.delayed(const Duration(seconds: 3));
    if (!state.isSendingCommand) return; // Cancelled
    
    if (state.simulateFailure) {
      state = state.copyWith(
        isSendingCommand: false,
        showFailureDialog: true,
      );
    } else {
      state = state.copyWith(
        lastActionMessage: "Device Called",
        lastActionTime: DateTime.now(),
        isSendingCommand: false,
        showSuccessDialog: true,
      );
    }
  }
}

final deviceControlProvider =
    StateNotifierProvider<DeviceControlNotifier, DeviceState>((ref) {
  return DeviceControlNotifier();
});

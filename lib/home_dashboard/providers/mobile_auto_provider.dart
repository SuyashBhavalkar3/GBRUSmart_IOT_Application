import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mobile_auto_device_model.dart';

/// State object representing the onboarding journey, inputs, and the user's devices list.
class MobileAutoOnboardingState {
  final String? deviceId; // IMEI or scan value entered in Step 1
  final String? contactNumber; // SIM contact number inside device entered in Step 2
  final String otpStep1; // 6-digit OTP entered in step 1
  final String otpStep3; // 6-digit OTP entered in step 3
  final int resendSecondsRemaining; // Countdown for Resend OTP (starts at 44)
  final bool isLoading; // Loading indicator for network actions
  final String? errorMessage; // Validation or submission errors
  final DeviceOwnershipStatus? ownershipStatus; // Target ownership status from provider/installer state
  final List<MobileAutoDevice> approvedDevices; // User's self-owned/approved devices
  final List<MobileAutoDevice> linkedDevices;   // Devices shared/linked with the user (read-only)

  const MobileAutoOnboardingState({
    this.deviceId,
    this.contactNumber,
    this.otpStep1 = '',
    this.otpStep3 = '',
    this.resendSecondsRemaining = 0,
    this.isLoading = false,
    this.errorMessage,
    this.ownershipStatus,
    this.approvedDevices = const [],
    this.linkedDevices = const [],
  });

  /// Factory method for the default initial state.
  factory MobileAutoOnboardingState.initial() {
    return const MobileAutoOnboardingState();
  }

  /// Copies the current state with optionally modified values.
  MobileAutoOnboardingState copyWith({
    String? deviceId,
    String? contactNumber,
    String? otpStep1,
    String? otpStep3,
    int? resendSecondsRemaining,
    bool? isLoading,
    String? errorMessage,
    DeviceOwnershipStatus? ownershipStatus,
    List<MobileAutoDevice>? approvedDevices,
    List<MobileAutoDevice>? linkedDevices,
    bool clearError = false,
  }) {
    return MobileAutoOnboardingState(
      deviceId: deviceId ?? this.deviceId,
      contactNumber: contactNumber ?? this.contactNumber,
      otpStep1: otpStep1 ?? this.otpStep1,
      otpStep3: otpStep3 ?? this.otpStep3,
      resendSecondsRemaining: resendSecondsRemaining ?? this.resendSecondsRemaining,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      ownershipStatus: ownershipStatus ?? this.ownershipStatus,
      approvedDevices: approvedDevices ?? this.approvedDevices,
      linkedDevices: linkedDevices ?? this.linkedDevices,
    );
  }
}

/// Notifier class that handles logic and state transitions for the onboarding flow.
class MobileAutoOnboardingNotifier extends Notifier<MobileAutoOnboardingState> {
  Timer? _resendTimer;

  @override
  MobileAutoOnboardingState build() {
    ref.onDispose(() {
      _resendTimer?.cancel();
    });

    // Initialize state with in-memory mock data
    return MobileAutoOnboardingState(
      approvedDevices: [
        MobileAutoDevice(
          deviceName: 'Mobile Auto',
          imeiNumber: '867530999123456',
          masterNumber: '+91 98765 43210',
          installedDate: DateTime(2026, 2, 12),
          ownershipStatus: DeviceOwnershipStatus.owned,
          isActive: true,
        ),
        MobileAutoDevice(
          deviceName: 'Mobile Auto Unit 2',
          imeiNumber: '867530999999999', // Triggers registeredToAnotherOwner state
          masterNumber: '+91 90000 12345',
          installedDate: DateTime(2026, 2, 15),
          ownershipStatus: DeviceOwnershipStatus.registeredToAnotherOwner,
          isActive: true,
        ),
      ],
      linkedDevices: [
        MobileAutoDevice(
          deviceName: 'Mobile Auto (Farm Link)',
          imeiNumber: '867530888111111',
          masterNumber: '+91 91111 22222',
          installedDate: DateTime(2026, 1, 20),
          ownershipStatus: DeviceOwnershipStatus.linked,
          isActive: true,
        ),
        MobileAutoDevice(
          deviceName: 'Mobile Auto (Well Pump)',
          imeiNumber: '867530888222222',
          masterNumber: '+91 92222 33333',
          installedDate: DateTime(2026, 1, 25),
          ownershipStatus: DeviceOwnershipStatus.linked,
          isActive: true,
        ),
      ],
    );
  }

  /// Set the IMEI/QR device ID input.
  void setDeviceId(String value) {
    state = state.copyWith(deviceId: value, clearError: true);
  }

  /// Set the device SIM contact number.
  void setContactNumber(String value) {
    state = state.copyWith(contactNumber: value, clearError: true);
  }

  /// Set the OTP value for Step 1 verification.
  void setOtpStep1(String value) {
    state = state.copyWith(otpStep1: value);
  }

  /// Set the OTP value for Step 3 approval.
  void setOtpStep3(String value) {
    state = state.copyWith(otpStep3: value);
  }

  /// Sets the ownership status dynamically.
  void setOwnershipStatus(DeviceOwnershipStatus status) {
    state = state.copyWith(ownershipStatus: status);
  }

  /// Adds a newly registered device to approvedDevices.
  void addApprovedDevice(MobileAutoDevice device) {
    final updatedApproved = List<MobileAutoDevice>.from(state.approvedDevices);
    
    // Check if device already exists to avoid duplicates
    final index = updatedApproved.indexWhere((d) => d.imeiNumber == device.imeiNumber);
    if (index >= 0) {
      updatedApproved[index] = device;
    } else {
      updatedApproved.add(device);
    }
    
    state = state.copyWith(approvedDevices: updatedApproved);
  }

  /// Confirms the ownership transfer for a given device IMEI.
  void confirmTransferOwnership(String imei) {
    final updatedApproved = state.approvedDevices.map((d) {
      if (d.imeiNumber == imei) {
        return d.copyWith(ownershipStatus: DeviceOwnershipStatus.owned);
      }
      return d;
    }).toList();
    
    state = state.copyWith(approvedDevices: updatedApproved);
  }

  /// Pre-fills the state from an existing pre-registered device and starts OTP timer.
  void activateExistingDevice(MobileAutoDevice device) {
    state = state.copyWith(
      deviceId: device.imeiNumber,
      contactNumber: device.masterNumber,
      ownershipStatus: device.ownershipStatus,
      clearError: true,
    );
    startResendTimer();
  }

  /// Starts the OTP resend timer countdown (44 seconds).
  void startResendTimer() {
    _resendTimer?.cancel();
    state = state.copyWith(resendSecondsRemaining: 44);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendSecondsRemaining > 1) {
        state = state.copyWith(resendSecondsRemaining: state.resendSecondsRemaining - 1);
      } else {
        state = state.copyWith(resendSecondsRemaining: 0);
        _resendTimer?.cancel();
      }
    });
  }

  /// Helper to trigger a mock API verification lag.
  Future<bool> verifyStep1DeviceId() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isLoading: false);
    return true;
  }

  /// Helper to mock step 1 OTP verification.
  Future<bool> verifyStep1Otp() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isLoading: false);
    if (state.otpStep1.length == 6) {
      return true;
    }
    state = state.copyWith(errorMessage: 'Invalid OTP. Please enter all 6 digits.');
    return false;
  }

  /// Helper to mock step 2 device SIM verify.
  Future<bool> verifyStep2Number() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isLoading: false);
    return true;
  }

  /// Helper to mock step 3 OTP approval.
  Future<bool> verifyStep3Otp() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isLoading: false);
    if (state.otpStep3.length == 6) {
      return true;
    }
    state = state.copyWith(errorMessage: 'Verification failed. Incorrect OTP.');
    return false;
  }

  /// Reset the flow state. Called when adding another device.
  void resetFlow() {
    _resendTimer?.cancel();
    state = state.copyWith(
      deviceId: null,
      contactNumber: null,
      otpStep1: '',
      otpStep3: '',
      resendSecondsRemaining: 0,
      isLoading: false,
      errorMessage: null,
      ownershipStatus: null,
    );
  }
}

/// Global provider for Mobile Auto Onboarding flow.
final mobileAutoProvider =
    NotifierProvider<MobileAutoOnboardingNotifier, MobileAutoOnboardingState>(
  MobileAutoOnboardingNotifier.new,
);

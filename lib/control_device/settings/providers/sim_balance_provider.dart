import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimBalanceState {
  final double simBalance;
  final String simNumber;
  final String provider;
  final String planType;
  final String signalStrength;
  final String lastUpdated;
  final bool isSending;
  final bool showSuccess;
  final bool showFailure;
  final bool simulateFailure;

  SimBalanceState({
    this.simBalance = 59.79,
    this.simNumber = '+91 98765 43210',
    this.provider = 'Airtel',
    this.planType = 'Prepaid',
    this.signalStrength = 'Excellent',
    this.lastUpdated = 'Today, 11:15 AM',
    this.isSending = false,
    this.showSuccess = false,
    this.showFailure = false,
    this.simulateFailure = false,
  });

  SimBalanceState copyWith({
    double? simBalance,
    String? simNumber,
    String? provider,
    String? planType,
    String? signalStrength,
    String? lastUpdated,
    bool? isSending,
    bool? showSuccess,
    bool? showFailure,
    bool? simulateFailure,
  }) {
    return SimBalanceState(
      simBalance: simBalance ?? this.simBalance,
      simNumber: simNumber ?? this.simNumber,
      provider: provider ?? this.provider,
      planType: planType ?? this.planType,
      signalStrength: signalStrength ?? this.signalStrength,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isSending: isSending ?? this.isSending,
      showSuccess: showSuccess ?? this.showSuccess,
      showFailure: showFailure ?? this.showFailure,
      simulateFailure: simulateFailure ?? this.simulateFailure,
    );
  }
}

class SimBalanceNotifier extends StateNotifier<SimBalanceState> {
  SimBalanceNotifier() : super(SimBalanceState());

  Timer? _smsTimer;

  void toggleSimulateFailure(bool value) {
    state = state.copyWith(simulateFailure: value);
  }

  Future<void> checkBalance() async {
    _smsTimer?.cancel();
    state = state.copyWith(
      isSending: true,
      showSuccess: false,
      showFailure: false,
    );

    _smsTimer = Timer(const Duration(seconds: 3), () {
      if (state.simulateFailure) {
        state = state.copyWith(isSending: false, showFailure: true);
      } else {
        // Toggle balance between 59.79 and 12.50 to let the user test both UI states
        final nextBalance = (state.simBalance == 59.79) ? 12.50 : 59.79;

        // Update last updated timestamp to current time format
        final now = DateTime.now();
        final minuteString = now.minute < 10
            ? '0${now.minute}'
            : '${now.minute}';
        final hour = now.hour > 12 ? now.hour - 12 : now.hour;
        final ampm = now.hour >= 12 ? 'PM' : 'AM';
        final formattedTime = 'Today, $hour:$minuteString $ampm';

        state = state.copyWith(
          isSending: false,
          showSuccess: true,
          simBalance: nextBalance,
          lastUpdated: formattedTime,
        );
      }
    });
  }

  void cancelSimBalanceCommand() {
    _smsTimer?.cancel();
    state = state.copyWith(
      isSending: false,
      showSuccess: false,
      showFailure: false,
    );
  }

  void retrySimBalanceCommand() {
    checkBalance();
  }

  void dismissSimBalanceSuccessDialog() {
    state = state.copyWith(showSuccess: false);
  }

  void dismissSimBalanceFailureDialog() {
    state = state.copyWith(showFailure: false);
  }

  @override
  void dispose() {
    _smsTimer?.cancel();
    super.dispose();
  }
}

final simBalanceProvider =
    StateNotifierProvider<SimBalanceNotifier, SimBalanceState>((ref) {
      return SimBalanceNotifier();
    });

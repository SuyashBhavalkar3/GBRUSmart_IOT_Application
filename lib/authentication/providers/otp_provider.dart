import 'dart:async';
import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  String _otpCode = '';
  bool _isLoading = false;
  bool _hasError = false;
  int _timerSeconds = 54; // Set to 54 based on the specific design screenshot requirement '00:54'
  Timer? _timer;

  String get otpCode => _otpCode;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  int get timerSeconds => _timerSeconds;

  bool get isValid => _otpCode.length == 6;
  bool get canResend => _timerSeconds == 0;

  void startTimer() {
    _timer?.cancel();
    _timerSeconds = 60; // Standard restart is usually 60s
    notifyListeners();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  // Allow forcing the initial time to 54 for UI matching
  void initTimer({int initialSeconds = 54}) {
    _timer?.cancel();
    _timerSeconds = initialSeconds;
    notifyListeners();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  void setOtpCode(String value) {
    _otpCode = value;
    if (_hasError) _hasError = false; // Clear error on typing
    notifyListeners();
  }

  Future<void> resendOtp({required VoidCallback onResend}) async {
    if (!canResend) return;
    
    // Trigger external resend logic
    onResend();
    
    // Restart the timer
    startTimer();
  }

  Future<void> verifyOtp({required VoidCallback onSuccess}) async {
    if (!isValid || _isLoading) return;

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    
    // Simulate invalid OTP if it is '000000'
    if (_otpCode == '000000') {
      _hasError = true;
      notifyListeners();
      return;
    }

    notifyListeners();
    onSuccess();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

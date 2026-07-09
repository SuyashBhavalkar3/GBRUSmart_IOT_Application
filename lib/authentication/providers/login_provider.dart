import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String _phoneNumber = '';
  bool _isLoading = false;

  String get phoneNumber => _phoneNumber;
  bool get isLoading => _isLoading;

  /// Validates if the phone number is exactly 10 digits and contains no special characters.
  bool get isValid {
    final cleanPhone = _phoneNumber.trim();
    if (cleanPhone.length != 10) return false;
    
    // Check if it contains only digits
    final RegExp digitRegex = RegExp(r'^[0-9]+$');
    return digitRegex.hasMatch(cleanPhone);
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  /// Exposes a callback for another developer to connect API integration later.
  /// Simulates a loading state before firing the provided callback.
  Future<void> onGetOtp({required VoidCallback onSuccess}) async {
    if (!isValid || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay for UI feedback
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // Trigger the external callback
    onSuccess();
  }
}

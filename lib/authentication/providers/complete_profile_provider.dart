import 'package:flutter/material.dart';

class CompleteProfileProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  
  bool _isLoading = false;
  
  // Validation tracking
  bool _isNameDirty = false;
  bool _isEmailDirty = false;

  String get name => _name;
  String get email => _email;
  bool get isLoading => _isLoading;

  // Validation logic
  bool get isNameValid {
    if (_name.trim().isEmpty) return false;
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(_name.trim());
  }
  
  bool get isEmailValid {
    if (_email.trim().isEmpty) return false;
    if (_email != _email.toLowerCase()) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(_email.trim());
  }

  bool get isValid => isNameValid && isEmailValid;

  // Error messages
  String? get nameError {
    if (!_isNameDirty) return null;
    if (_name.trim().isEmpty) return 'Name cannot be empty';
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(_name.trim())) return 'Name should only contain alphabets';
    return null;
  }

  String? get emailError {
    if (!_isEmailDirty) return null;
    if (_email.trim().isEmpty) return 'Email cannot be empty';
    if (_email != _email.toLowerCase()) return 'Email must be in lowercase';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_email.trim())) return 'Please enter a valid email address';
    return null;
  }

  void setName(String value) {
    _name = value;
    _isNameDirty = true;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _isEmailDirty = true;
    notifyListeners();
  }

  Future<void> saveAndContinue({required VoidCallback onSuccess}) async {
    // Force dirty state to show errors if they try to bypass (though button is disabled)
    _isNameDirty = true;
    _isEmailDirty = true;
    
    if (!isValid || _isLoading) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    onSuccess();
  }
}

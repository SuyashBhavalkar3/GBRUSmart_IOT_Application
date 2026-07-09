import 'package:flutter/material.dart';

class LocationDetailsProvider extends ChangeNotifier {
  // Dropdown options
  final List<String> countries = ['India', 'Nepal', 'Bangladesh', 'Sri Lanka'];
  final List<String> states = ['Maharashtra', 'Gujarat', 'Karnataka', 'Goa'];
  final List<String> districts = ['Satara', 'Pune', 'Kolhapur', 'Sangli'];
  final List<String> tehsils = ['Satara', 'Karad', 'Wai', 'Patan'];

  // Selected values
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTehsil;
  
  // Text fields
  String _pincode = '';
  String _address = '';
  
  bool _isLoading = false;
  
  // Validation tracking
  bool _isPincodeDirty = false;
  bool _isAddressDirty = false;

  // Getters
  String? get selectedCountry => _selectedCountry;
  String? get selectedState => _selectedState;
  String? get selectedDistrict => _selectedDistrict;
  String? get selectedTehsil => _selectedTehsil;
  String get pincode => _pincode;
  String get address => _address;
  bool get isLoading => _isLoading;

  // Validation logic
  bool get isCountryValid => _selectedCountry != null;
  bool get isStateValid => _selectedState != null;
  bool get isDistrictValid => _selectedDistrict != null;
  bool get isTehsilValid => _selectedTehsil != null;
  bool get isPincodeValid => _pincode.trim().length == 6 && int.tryParse(_pincode.trim()) != null;
  bool get isAddressValid => _address.trim().isNotEmpty;

  bool get isValid => 
      isCountryValid && 
      isStateValid && 
      isDistrictValid && 
      isTehsilValid && 
      isPincodeValid && 
      isAddressValid;

  // Error messages
  String? get pincodeError {
    if (!_isPincodeDirty) return null;
    if (_pincode.trim().isEmpty) return 'Pincode cannot be empty';
    if (!isPincodeValid) return 'Pincode must be 6 digits';
    return null;
  }

  String? get addressError {
    if (!_isAddressDirty) return null;
    if (_address.trim().isEmpty) return 'Address cannot be empty';
    return null;
  }

  // Setters
  void setCountry(String? value) {
    _selectedCountry = value;
    notifyListeners();
  }

  void setState(String? value) {
    _selectedState = value;
    notifyListeners();
  }

  void setDistrict(String? value) {
    _selectedDistrict = value;
    notifyListeners();
  }

  void setTehsil(String? value) {
    _selectedTehsil = value;
    notifyListeners();
  }

  void setPincode(String value) {
    _pincode = value;
    _isPincodeDirty = true;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    _isAddressDirty = true;
    notifyListeners();
  }

  Future<void> saveAndContinue({required VoidCallback onSuccess}) async {
    // Force dirty state to show errors if they try to bypass (though button is disabled)
    _isPincodeDirty = true;
    _isAddressDirty = true;
    
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

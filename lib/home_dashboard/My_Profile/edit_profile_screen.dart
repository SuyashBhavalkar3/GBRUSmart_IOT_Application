import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_colors.dart';
import '../widgets/mobile_auto/otp_input_boxes.dart';
import '../widgets/mobile_auto/primary_gradient_button.dart';
import 'profile_provider.dart';

/// Screen 12: User detail editor screen. Supports inline verification when editing the mobile contact.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  late TextEditingController _pincodeController;
  late TextEditingController _addressController;

  String _verificationOtp = '';
  bool _isVerifyingOtp = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _nameController = TextEditingController(text: profile.fullName);
    _phoneController = TextEditingController(text: profile.phoneNumber);
    _emailController = TextEditingController(text: profile.email);
    _countryController = TextEditingController(text: profile.country);
    _stateController = TextEditingController(text: profile.stateName);
    _districtController = TextEditingController(text: profile.district);
    _pincodeController = TextEditingController(text: profile.pincode);
    _addressController = TextEditingController(text: profile.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final originalProfile = ref.read(profileProvider);
    final isPhoneChanged = _phoneController.text.trim() != originalProfile.phoneNumber;

    if (isPhoneChanged) {
      // Trigger OTP verification bottom sheet
      _showOtpVerificationSheet();
    } else {
      // Save changes immediately
      _commitChanges(originalProfile.phoneNumber);
    }
  }

  void _commitChanges(String phoneToSave) {
    ref.read(profileProvider.notifier).updateProfile(
      fullName: _nameController.text.trim(),
      phoneNumber: phoneToSave,
      email: _emailController.text.trim(),
      country: _countryController.text.trim(),
      stateName: _stateController.text.trim(),
      district: _districtController.text.trim(),
      pincode: _pincodeController.text.trim(),
      address: _addressController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
    Navigator.of(context).pop();
  }

  void _showOtpVerificationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verify New Number',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "We've sent a 6-digit OTP code to verify your new mobile number: ${_phoneController.text}.",
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textGrey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  OtpInputBoxes(
                    onChanged: (otp) {
                      setSheetState(() {
                        _verificationOtp = otp;
                      });
                    },
                    onCompleted: (otp) {
                      setSheetState(() {
                        _verificationOtp = otp;
                      });
                    },
                  ),
                  const SizedBox(height: 24.0),
                  PrimaryGradientButton(
                    label: 'Verify & Save',
                    isEnabled: _verificationOtp.length == 6 && !_isVerifyingOtp,
                    isLoading: _isVerifyingOtp,
                    onPressed: () async {
                      setSheetState(() {
                        _isVerifyingOtp = true;
                      });
                      // Fake network verification wait
                      await Future.delayed(const Duration(milliseconds: 1000));
                      setSheetState(() {
                        _isVerifyingOtp = false;
                      });
                      
                      if (context.mounted) {
                        Navigator.of(context).pop(); // dismiss sheet
                        _commitChanges(_phoneController.text.trim());
                      }
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Update your personal information',
                      style: TextStyle(fontSize: 13.0, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 20.0),

                    // Avatar decoration
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 44.0,
                            backgroundColor: AppColors.lightGreenBg,
                            child: Text(
                              _nameController.text.isNotEmpty ? _nameController.text[0] : 'U',
                              style: const TextStyle(
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Tap to change photo',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28.0),

                    // Personal Information Section
                    _buildSectionTitle('Personal Information'),
                    const SizedBox(height: 12.0),
                    _buildLabel('Full Name'),
                    _buildTextField(controller: _nameController, hint: 'Enter full name'),
                    const SizedBox(height: 16.0),
                    _buildLabel('Mobile Number'),
                    _buildTextField(controller: _phoneController, hint: 'Enter phone number', keyboardType: TextInputType.phone),
                    const SizedBox(height: 16.0),
                    _buildLabel('Email Address'),
                    _buildTextField(controller: _emailController, hint: 'Enter email address', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 24.0),

                    // Location Section
                    _buildSectionTitle('Location'),
                    const SizedBox(height: 12.0),
                    _buildLabel('Country'),
                    _buildTextField(controller: _countryController, hint: 'Enter country'),
                    const SizedBox(height: 16.0),
                    _buildLabel('State'),
                    _buildTextField(controller: _stateController, hint: 'Enter state'),
                    const SizedBox(height: 16.0),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('District'),
                              _buildTextField(controller: _districtController, hint: 'District'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Pincode'),
                              _buildTextField(controller: _pincodeController, hint: 'Pincode', keyboardType: TextInputType.number),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildLabel('Address'),
                    _buildTextField(controller: _addressController, hint: 'Enter detailed address', maxLines: 3),
                    const SizedBox(height: 20.0),

                    // Warning banner about changing mobile number
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: const Color(0xFFFFB74D).withAlpha(51)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 18.0),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Changing your mobile number will require OTP verification. We will send an OTP to your new mobile number.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFFE65100),
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryGradientButton(
                    label: 'Save Changes',
                    onPressed: _saveChanges,
                  ),
                  const SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.0,
          color: AppColors.textGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14.0, color: AppColors.textDark, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}

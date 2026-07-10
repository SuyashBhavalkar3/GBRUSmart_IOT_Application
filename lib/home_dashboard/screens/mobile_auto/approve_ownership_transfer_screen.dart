import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../models/mobile_auto_device_model.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../widgets/mobile_auto/otp_input_boxes.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';
import 'ownership_transfer_request_screen.dart';

/// Screen 9: Approve Ownership Transfer OTP verification screen.
class ApproveOwnershipTransferScreen extends ConsumerStatefulWidget {
  final MobileAutoDevice device;

  const ApproveOwnershipTransferScreen({
    super.key,
    required this.device,
  });

  @override
  ConsumerState<ApproveOwnershipTransferScreen> createState() => _ApproveOwnershipTransferScreenState();
}

class _ApproveOwnershipTransferScreenState extends ConsumerState<ApproveOwnershipTransferScreen> {
  String _enteredOtp = '';
  int _secondsRemaining = 44;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 44;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _getMaskedPhoneNumber(String masterNumber) {
    final clean = masterNumber.replaceAll(' ', '');
    if (clean.length < 5) return masterNumber;
    
    // Check if it starts with +91 and has length of 13 (+919876543210)
    if (clean.startsWith('+91') && clean.length == 13) {
      return '+91 ${clean[3]}XXXXX${clean.substring(9)}'; // e.g. +91 9XXXXX321
    }
    
    if (clean.length > 6) {
      return '${clean.substring(0, 4)}XXXXX${clean.substring(clean.length - 3)}';
    }
    return masterNumber;
  }

  void _onContactSupport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const OwnershipTransferRequestScreen(),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate verification delay matching mock API verification
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (_enteredOtp.length == 6) {
      // Trigger ownership update in riverpod provider
      ref.read(mobileAutoProvider.notifier).confirmTransferOwnership(widget.device.imeiNumber);

      // Return to MyDevicesScreen
      Navigator.of(context).pop();

      // Show success notification snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ownership of ${widget.device.deviceName} transferred successfully!',
          ),
          backgroundColor: const Color(0xFF00A859),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTimerActive = _secondsRemaining > 0;
    final timerString = '00:${_secondsRemaining.toString().padLeft(2, '0')}';
    final maskedPhone = _getMaskedPhoneNumber(widget.device.masterNumber);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBF6), // Light green/mint background matching screenshot
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Approve Ownership Transfer',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: const Color(0xFFF2FBF6),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ownership Transfer',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      "We've sent a 6-digit OTP to the current registered number to approve ownership transfer.",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      maskedPhone,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 36.0),
                    
                    // OTP Input fields with white background as shown in the screenshot
                    OtpInputBoxes(
                      fillColor: Colors.white,
                      onChanged: (otp) {
                        setState(() {
                          _enteredOtp = otp;
                        });
                      },
                      onCompleted: (otp) {
                        setState(() {
                          _enteredOtp = otp;
                        });
                      },
                    ),
                    const SizedBox(height: 24.0),
                    
                    // Timer & Resend Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isTimerActive)
                            Text(
                              'Resend OTP in $timerString',
                              style: const TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 13.0,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: _startTimer,
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Color(0xFF00A859),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    
                    // Didn't receive OTP? Contact Support (in blue link style matching screenshot)
                    Center(
                      child: GestureDetector(
                        onTap: _onContactSupport,
                        child: const Text(
                          "Didn't receive OTP? Contact Support",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: PrimaryGradientButton(
                label: 'Verify & Continue',
                isEnabled: _enteredOtp.length == 6,
                isLoading: _isLoading,
                backgroundColor: const Color(0xFF00A859), // Solid green shade matching screenshot
                onPressed: _verifyOtp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

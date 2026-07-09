import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../widgets/mobile_auto/onboarding_stepper.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';
import 'confirm_otp_step1_screen.dart';

/// Screen 3: Step 1 of onboarding. User enters IMEI, contact number, or scans a QR code.
class AddDeviceIdScreen extends ConsumerStatefulWidget {
  const AddDeviceIdScreen({super.key});

  @override
  ConsumerState<AddDeviceIdScreen> createState() => _AddDeviceIdScreenState();
}

class _AddDeviceIdScreenState extends ConsumerState<AddDeviceIdScreen> {
  late TextEditingController _imeiController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(mobileAutoProvider);
    _imeiController = TextEditingController(text: state.deviceId);
    _contactController = TextEditingController(text: state.contactNumber);
  }

  @override
  void dispose() {
    _imeiController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _onScanQr() {
    // Show a beautiful mock QR scanner dialog or set a mock value
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        title: const Text('Scan QR Code'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, size: 80.0, color: AppColors.primaryGreen),
            SizedBox(height: 16.0),
            Text(
              'Scanning QR Code on your Mobile Auto device...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              const mockImei = '867530999123456';
              setState(() {
                _imeiController.text = mockImei;
              });
              ref.read(mobileAutoProvider.notifier).setDeviceId(mockImei);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Device ID scanned successfully!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: const Text('Simulate Scan', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(mobileAutoProvider);
    final notifier = ref.read(mobileAutoProvider.notifier);

    // Enabled if either QR/IMEI is entered OR contact number is entered
    final isButtonEnabled = _imeiController.text.trim().isNotEmpty ||
        _contactController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Mobile Auto Unit 1',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Stepper Widget
            const OnboardingStepper(currentStep: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Step 1: Identify Your Device',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Outlined green button with QR icon
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.qr_code_scanner, color: AppColors.primaryGreen),
                          label: const Text(
                            'Scan QR Code',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _onScanQr,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildOrDivider(),
                      const SizedBox(height: 16.0),
                      // Label + manual IMEI field
                      const Text(
                        'If QR is not available, enter IMEI number',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _imeiController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter IMEI number',
                          prefixIcon: const Icon(Icons.tag, color: AppColors.textGrey),
                          filled: true,
                          fillColor: AppColors.inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                        ),
                        onChanged: (val) {
                          notifier.setDeviceId(val);
                          setState(() {}); // trigger rebuild to update button enabled state
                        },
                      ),
                      const SizedBox(height: 16.0),
                      _buildOrDivider(),
                      const SizedBox(height: 16.0),
                      // Label + Contact number field
                      const Text(
                        'Contact number inside the device',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Enter contact number',
                          prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textGrey),
                          filled: true,
                          fillColor: AppColors.inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                        ),
                        onChanged: (val) {
                          notifier.setContactNumber(val);
                          setState(() {}); // trigger rebuild to update button enabled state
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Continue Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PrimaryGradientButton(
                label: 'Continue',
                isEnabled: isButtonEnabled,
                isLoading: onboardingState.isLoading,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final success = await notifier.verifyStep1DeviceId();
                  if (success) {
                    // Trigger OTP Timer countdown
                    notifier.startResendTimer();
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) => const ConfirmOtpStep1Screen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderGrey, thickness: 1.0)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight.withAlpha(204),
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.borderGrey, thickness: 1.0)),
      ],
    );
  }
}

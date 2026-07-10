import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app_colors.dart';
import '../../providers/mobile_auto_provider.dart';
import '../../models/mobile_auto_device_model.dart';
import '../../widgets/mobile_auto/onboarding_stepper.dart';
import '../../widgets/mobile_auto/primary_gradient_button.dart';
import '../../widgets/mobile_auto/device_summary_card.dart';
import 'confirm_otp_step3_screen.dart';

/// Screen 5: Step 2 of onboarding. User verifies the SIM contact number inside the device.
/// [isTransferFlow]: when true, passes flag down to Step 3 so success routes correctly.
class VerifyNumberStep2Screen extends ConsumerStatefulWidget {
  final bool isTransferFlow;

  const VerifyNumberStep2Screen({super.key, this.isTransferFlow = false});

  @override
  ConsumerState<VerifyNumberStep2Screen> createState() => _VerifyNumberStep2ScreenState();
}

class _VerifyNumberStep2ScreenState extends ConsumerState<VerifyNumberStep2Screen> {
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(mobileAutoProvider);
    // Remove "+91 " prefix if it was saved, or set to empty
    String initialPhone = state.contactNumber ?? '';
    if (initialPhone.startsWith('+91')) {
      initialPhone = initialPhone.replaceFirst('+91', '').trim();
    }
    _phoneController = TextEditingController(text: initialPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(mobileAutoProvider);
    final notifier = ref.read(mobileAutoProvider.notifier);

    final imei = onboardingState.deviceId?.isNotEmpty == true
        ? onboardingState.deviceId!
        : '867530999123456';
    final masterNo = onboardingState.contactNumber?.isNotEmpty == true
        ? onboardingState.contactNumber!
        : '+91 98765 43210';

    final isButtonEnabled = _phoneController.text.trim().length == 10;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Verify Your Device',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Stepper with Step 2 Active
            const OnboardingStepper(currentStep: 2),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Summary Card
                    DeviceSummaryCard(
                      device: MobileAutoDevice(
                        deviceName: 'Mobile Auto',
                        imeiNumber: imei,
                        masterNumber: masterNo,
                        installedDate: DateTime.now(),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      'Step 2: Verify Number',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Enter contact number of SIM inside the device.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.textGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    
                    // Phone Number Input Row
                    const Text(
                      'Contact Number',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Static +91 box
                        Container(
                          height: 52.0,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: AppColors.borderGrey.withAlpha(76),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: const Center(
                            child: Text(
                              '+91',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        // Number field
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter 10-digit number',
                              filled: true,
                              fillColor: AppColors.inputBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            ),
                            onChanged: (val) {
                              notifier.setContactNumber('+91 $val');
                              setState(() {}); // trigger rebuild to update button enabled state
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PrimaryGradientButton(
                label: 'Verify Device',
                isEnabled: isButtonEnabled,
                isLoading: onboardingState.isLoading,
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final verified = await notifier.verifyStep2Number();
                  if (verified) {
                    // Trigger OTP Timer countdown for step 3
                    notifier.startResendTimer();
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) => ConfirmOtpStep3Screen(
                          isTransferFlow: widget.isTransferFlow,
                        ),
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
}
